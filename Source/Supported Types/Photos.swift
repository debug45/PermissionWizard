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
        
        public static let fullAccessUsageDescriptionPlistKey = "NSPhotoLibraryUsageDescription"
        public static let addingOnlyUsageDescriptionPlistKey = "NSPhotoLibraryAddUsageDescription"
        
        // MARK: - Overriding Properties
        
        @available(*, unavailable)
        public override class var usageDescriptionPlistKey: String { .init() }
        
#if ASSETS || !CUSTOM_SETTINGS
        override class var shouldBorderIcon: Bool { true }
#endif
        
        // MARK: - Public Functions
        
        @available(iOS 14, *)
        public class func checkStatus(forAddingOnly: Bool, completion: @escaping (Status) -> Void) {
            _checkStatus(forAddingOnly: forAddingOnly, completion: completion)
        }
        
        @available(iOS, deprecated: 14)
        public class func checkStatus(completion: @escaping (Status) -> Void) {
            _checkStatus(forAddingOnly: false, completion: completion)
        }
        
        @available(iOS 14, *)
        public class func requestAccess(forAddingOnly: Bool, completion: ((Status) -> Void)? = nil) throws {
            try _requestAccess(forAddingOnly: forAddingOnly, completion: completion)
        }
        
        @available(iOS, deprecated: 14)
        public class func requestAccess(completion: ((Status) -> Void)? = nil) throws {
            try _requestAccess(forAddingOnly: false, completion: completion)
        }
        
        // MARK: - Private Functions
        
        private static func _checkStatus(forAddingOnly: Bool, completion: @escaping (Status) -> Void) {
            let value: PHAuthorizationStatus
            
            if #available(iOS 14, *) {
                let accessLevel: PHAccessLevel = forAddingOnly ? .addOnly : .readWrite
                value = PHPhotoLibrary.authorizationStatus(for: accessLevel)
            } else {
                value = PHPhotoLibrary.authorizationStatus()
            }
            
            let completion = Utils.linkToPreferredQueue(completion)
            
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
        
        private static func _requestAccess(forAddingOnly: Bool, completion: ((Status) -> Void)? = nil) throws {
            let plistKey = forAddingOnly ? addingOnlyUsageDescriptionPlistKey : fullAccessUsageDescriptionPlistKey
            try Utils.checkIsAppConfigured(for: photos.self, usageDescriptionPlistKey: plistKey)
            
            let handler: (PHAuthorizationStatus) -> Void = { _ in
                guard let completion = completion else {
                    return
                }
                
                self._checkStatus(forAddingOnly: forAddingOnly) { completion($0) }
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