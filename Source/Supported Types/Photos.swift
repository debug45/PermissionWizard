//
//  Photos.swift
//  PermissionWizard
//
//  Created by Sergei Moskvin on 17.10.2020.
//

#if PHOTOS || !CUSTOM_SETTINGS

import Photos

public extension Permission {
    
    final class photos: SupportedType {
        
        public typealias Status = Permission.Status.Photos
        
        // MARK: Overriding Properties
        
        @available(*, unavailable)
        public override class var usageDescriptionPlistKey: String { .init() }
        
#if ASSETS || !CUSTOM_SETTINGS
        override class var shouldBorderIcon: Bool { true }
#endif
        
        // MARK: Public Properties
        
        /**
         A key that must be added to your “Info.plist” to work with the permission type. This key is used if you want to have full access to a user’s photos and videos.

         For each permission type you are using, Apple requires to add the corresponding string to your “Info.plist” that describes a purpose of your access requests
        */
        public static let fullAccessUsageDescriptionPlistKey = "NSPhotoLibraryUsageDescription"
        /**
         A key that must be added to your “Info.plist” to work with the permission type. This key is used if you want only to add new photos and videos to a user’s library.

         For each permission type you are using, Apple requires to add the corresponding string to your “Info.plist” that describes a purpose of your access requests
        */
        public static let addingOnlyUsageDescriptionPlistKey = "NSPhotoLibraryAddUsageDescription"
        
        // MARK: Public Functions
        
        /**
         Asks the system for the current status of the permission type

         - Parameter forAddingOnly: A flag indicating whether you want to check the ability only to add new photos and videos to a user’s library
         - Parameter completion: A closure that will be invoked to return the check result
         - Parameter forcedInvokationQueue: A forced dispatch queue to invoke the completion closure. The default value is `DispatchQueue.main`.
        */
        public static func checkStatus(forAddingOnly: Bool, completion: @escaping (Status) -> Void, forcedInvokationQueue: DispatchQueue? = Constants.defaultCompletionInvokationQueue) {
            var completion = completion
            
            if let forcedInvokationQueue = forcedInvokationQueue {
                completion = Utils.linkToQueue(forcedInvokationQueue, closure: completion)
            }
            
            let accessLevel: PHAccessLevel = forAddingOnly ? .addOnly : .readWrite
            
            switch PHPhotoLibrary.authorizationStatus(for: accessLevel) {
                case .authorized:
                    completion(.granted)
                case .denied:
                    completion(.denied)
                case .notDetermined:
                    completion(.notDetermined)
                case .limited:
                    completion(.limitedByUser)
                case .restricted:
                    completion(.restrictedBySystem)
                
                @unknown default:
                    completion(.unknown)
            }
        }
        
        /**
         Asks the system for the current status of the permission type

         - Parameter forAddingOnly: A flag indicating whether you want to check the ability only to add new photos and videos to a user’s library
        */
        public static func checkStatus(forAddingOnly: Bool) async throws -> Status {
            await withCheckedContinuation { checkedContinuation in
                checkStatus(forAddingOnly: forAddingOnly) { status in
                    checkedContinuation.resume(returning: status)
                }
            }
        }
        
        /**
         Asks a user for access the permission type

         - Parameter forAddingOnly: A flag indicating whether you want only to add new photos and videos to a user’s library
         - Parameter completion: A closure that will be invoked to return the request result
         - Parameter forcedInvokationQueue: A forced dispatch queue to invoke the completion closure. The default value is `DispatchQueue.main`.
         - Throws: `Permission.Error`, if something went wrong. For example, your “Info.plist” is configured incorrectly.
        */
        public static func requestAccess(forAddingOnly: Bool, completion: ((Status) -> Void)? = nil, forcedInvokationQueue: DispatchQueue? = Constants.defaultCompletionInvokationQueue) throws {
            let plistKey = forAddingOnly ? addingOnlyUsageDescriptionPlistKey : fullAccessUsageDescriptionPlistKey
            try Utils.checkIsAppConfigured(for: photos.self, usageDescriptionPlistKey: plistKey)
            
            let handler: (PHAuthorizationStatus) -> Void = { _ in
                guard let completion = completion else {
                    return
                }
                
                self.checkStatus(forAddingOnly: forAddingOnly, completion: {
                    completion($0)
                }, forcedInvokationQueue: forcedInvokationQueue)
            }
            
            let accessLevel: PHAccessLevel = forAddingOnly ? .addOnly : .readWrite
            PHPhotoLibrary.requestAuthorization(for: accessLevel, handler: handler)
        }
        
        /**
         Asks a user for access the permission type

         - Parameter forAddingOnly: A flag indicating whether you want only to add new photos and videos to a user’s library
         - Throws: `Permission.Error`, if something went wrong. For example, your “Info.plist” is configured incorrectly.
        */
        @discardableResult public static func requestAccess(forAddingOnly: Bool) async throws -> Status {
            try await withCheckedThrowingContinuation { checkedContinuation in
                do {
                    try requestAccess(forAddingOnly: forAddingOnly) { status in
                        checkedContinuation.resume(returning: status)
                    }
                } catch {
                    checkedContinuation.resume(throwing: error)
                }
            }
        }
        
    }
    
}

#endif
