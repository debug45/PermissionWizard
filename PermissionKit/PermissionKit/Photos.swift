//
//  Photos.swift
//  PermissionKit
//
//  Created by Sergey Moskvin on 17.10.2020.
//

import Photos

public extension Permission {
    
    final class photos: Base {
        
        public enum Status: String {
            
            case granted
            case denied
            
            case notDetermined
            
            case limitedByUser
            case restrictedBySystem
            
            case unknown
            
        }
        
        public static let usageDescriptionPlistKey = "NSPhotoLibraryUsageDescription"
        public static let addingOnlyUsageDescriptionPlistKey = "NSPhotoLibraryAddUsageDescription"
        
        // MARK: - Public Functions
        
        public class func checkStatus(forAddingOnly: Bool, completion: (Status) -> Void) {
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
        
        public class func requestAccess(forAddingOnly: Bool, completion: ((Status) -> Void)? = nil) {
            let plistKey = forAddingOnly ? addingOnlyUsageDescriptionPlistKey : usageDescriptionPlistKey
            
            guard Utils.checkIsAppConfigured(for: photos.self, usageDescriptionPlistKey: plistKey) else {
                return
            }
            
            let accessLevel: PHAccessLevel = forAddingOnly ? .addOnly : .readWrite
            
            PHPhotoLibrary.requestAuthorization(for: accessLevel) { _ in
                guard let completion = completion else {
                    return
                }
                
                self.checkStatus(forAddingOnly: forAddingOnly) { completion($0) }
            }
        }
        
    }
    
}
