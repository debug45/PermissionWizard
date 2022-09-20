//
//  Photos.swift
//  PermissionWizard
//
//  Created by Sergey Moskvin on 17.10.2020.
//

#if PHOTOS || !CUSTOM_SETTINGS

import Photos

public extension Permission {
    
    final class photos: SupportedType, Checkable, Requestable {
        
        public typealias Status = Permission.Status.Photos
        
        // MARK: Overriding Properties
        
        @available(*, unavailable)
        public override class var usageDescriptionPlistKey: String { .init() }
        
#if ASSETS || !CUSTOM_SETTINGS
        override class var shouldBorderIcon: Bool { true }
#endif
        
        // MARK: Public Properties
        
        /**
         A key that must be added to your ”Info.plist“ to work with the permission type. This key is used if you want to have full access to a user‘s photos and videos.

         For each permission type you are using, Apple requires to add the corresponding string to your ”Info.plist“ that describes a purpose of your access requests
        */
        public static let fullAccessUsageDescriptionPlistKey = "NSPhotoLibraryUsageDescription"
        /**
         A key that must be added to your ”Info.plist“ to work with the permission type. This key is used if you want only to add new photos and videos to a user‘s library.

         For each permission type you are using, Apple requires to add the corresponding string to your ”Info.plist“ that describes a purpose of your access requests
        */
        public static let addingOnlyUsageDescriptionPlistKey = "NSPhotoLibraryAddUsageDescription"
        
        // MARK: Public Functions
        
        /**
         Asks the system for the current status of the permission type

         - Parameter forAddingOnly: A flag indicating whether you want to check the ability only to add new photos and videos to a user‘s library
         - Parameter completion: A closure that will be invoked to return the check result
         - Parameter forcedInvokationQueue: A forced dispatch queue to invoke the completion closure. The default value is `DispatchQueue.main`.
        */     
        @available(iOS 14, *)
        public static func checkStatus(forAddingOnly: Bool, completion: @escaping (Status) -> Void, forcedInvokationQueue: DispatchQueue? = Constants.defaultCompletionInvokationQueue) {
            _checkStatus(forAddingOnly: forAddingOnly, completion: completion, forcedInvokationQueue: forcedInvokationQueue)
        }
        
        /**
         Asks the system for the current status of the permission type

         - Parameter forAddingOnly: A flag indicating whether you want to check the ability only to add new photos and videos to a user‘s library
        */
        @available(iOS 14, *)
        public static func checkStatus(forAddingOnly: Bool) async throws -> Status {
            await withCheckedContinuation { checkedContinuation in
                checkStatus(forAddingOnly: forAddingOnly) { status in
                    checkedContinuation.resume(returning: status)
                }
            }
        }
        
        @available(iOS, deprecated: 14)
        public static func checkStatus(completion: @escaping (Status) -> Void, forcedInvokationQueue: DispatchQueue? = Constants.defaultCompletionInvokationQueue) {
            _checkStatus(forAddingOnly: false, completion: completion, forcedInvokationQueue: forcedInvokationQueue)
        }
        
        @available(iOS, introduced: 13, deprecated: 14)
        public static func checkStatus() async -> Status {
            await withCheckedContinuation { checkedContinuation in
                checkStatus { status in
                    checkedContinuation.resume(returning: status)
                }
            }
        }
        
        /**
         Asks a user for access the permission type

         - Parameter forAddingOnly: A flag indicating whether you want only to add new photos and videos to a user‘s library
         - Parameter completion: A closure that will be invoked to return the request result
         - Parameter forcedInvokationQueue: A forced dispatch queue to invoke the completion closure. The default value is `DispatchQueue.main`.
         - Throws: `Permission.Error`, if something went wrong. For example, your ”Info.plist“ is configured incorrectly.
        */
        @available(iOS 14, *)
        public static func requestAccess(forAddingOnly: Bool, completion: ((Status) -> Void)? = nil, forcedInvokationQueue: DispatchQueue? = Constants.defaultCompletionInvokationQueue) throws {
            try _requestAccess(forAddingOnly: forAddingOnly, completion: completion, forcedInvokationQueue: forcedInvokationQueue)
        }
        
        /**
         Asks a user for access the permission type

         - Parameter forAddingOnly: A flag indicating whether you want only to add new photos and videos to a user‘s library
         - Throws: `Permission.Error`, if something went wrong. For example, your ”Info.plist“ is configured incorrectly.
        */
        @available(iOS 14, *)
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
        
        @available(iOS, deprecated: 14)
        public static func requestAccess(completion: ((Status) -> Void)? = nil, forcedInvokationQueue: DispatchQueue? = Constants.defaultCompletionInvokationQueue) throws {
            try _requestAccess(forAddingOnly: false, completion: completion, forcedInvokationQueue: forcedInvokationQueue)
        }
        
        @available(iOS, introduced: 13, deprecated: 14)
        @discardableResult public static func requestAccess() async throws -> Status {
            try await withCheckedThrowingContinuation { checkedContinuation in
                do {
                    try requestAccess { status in
                        checkedContinuation.resume(returning: status)
                    }
                } catch {
                    checkedContinuation.resume(throwing: error)
                }
            }
        }
        
        // MARK: Private Functions
        
        private static func _checkStatus(forAddingOnly: Bool, completion: @escaping (Status) -> Void, forcedInvokationQueue: DispatchQueue?) {
            let value: PHAuthorizationStatus
            
            if #available(iOS 14, *) {
                let accessLevel: PHAccessLevel = forAddingOnly ? .addOnly : .readWrite
                value = PHPhotoLibrary.authorizationStatus(for: accessLevel)
            } else {
                value = PHPhotoLibrary.authorizationStatus()
            }
            
            var completion = completion
            
            if let forcedInvokationQueue = forcedInvokationQueue {
                completion = Utils.linkToQueue(forcedInvokationQueue, closure: completion)
            }
            
            switch value {
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
        
        private static func _requestAccess(forAddingOnly: Bool, completion: ((Status) -> Void)?, forcedInvokationQueue: DispatchQueue?) throws {
            let plistKey = forAddingOnly ? addingOnlyUsageDescriptionPlistKey : fullAccessUsageDescriptionPlistKey
            try Utils.checkIsAppConfigured(for: photos.self, usageDescriptionPlistKey: plistKey)
            
            let handler: (PHAuthorizationStatus) -> Void = { _ in
                guard let completion = completion else {
                    return
                }
                
                self._checkStatus(forAddingOnly: forAddingOnly, completion: {
                    completion($0)
                }, forcedInvokationQueue: forcedInvokationQueue)
            }
            
            if #available(iOS 14, *) {
                let accessLevel: PHAccessLevel = forAddingOnly ? .addOnly : .readWrite
                PHPhotoLibrary.requestAuthorization(for: accessLevel, handler: handler)
            } else {
                PHPhotoLibrary.requestAuthorization(handler)
            }
        }
        
    }
    
}

#endif
