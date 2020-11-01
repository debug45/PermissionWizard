//
//  Music.swift
//  PermissionKit
//
//  Created by Sergey Moskvin on 17.10.2020.
//

import MediaPlayer

@available(iOS 9.3, *)
public extension Permission {
    
    final class music: Base {
        
        public enum Status: String {
            
            case granted
            case denied
            
            case notDetermined
            case restrictedBySystem
            
            case unknown
            
        }
        
        public class override var usageDescriptionPlistKey: String? { "NSAppleMusicUsageDescription" }
        
        // MARK: - Public Functions
        
        public class func checkStatus(completion: (Status) -> Void) {
            switch MPMediaLibrary.authorizationStatus() {
                case .authorized:
                    completion(.granted)
                case .denied:
                    completion(.denied)
                case .notDetermined:
                    completion(.notDetermined)
                case .restricted:
                    completion(.restrictedBySystem)
                
                @unknown default:
                    completion(.unknown)
            }
        }
        
        public class func requestAccess(completion: ((Status) -> Void)? = nil) {
            guard Utils.checkIsAppConfigured(for: music.self) else {
                return
            }
            
            MPMediaLibrary.requestAuthorization { _ in
                guard let completion = completion else {
                    return
                }
                
                self.checkStatus { completion($0) }
            }
        }
        
    }
    
}
