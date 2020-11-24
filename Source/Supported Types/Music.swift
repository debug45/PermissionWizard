//
//  Music.swift
//  PermissionWizard
//
//  Created by Sergey Moskvin on 17.10.2020.
//

#if MUSIC || !CUSTOM_SETTINGS

import MediaPlayer

public extension Permission {
    
    final class music: Base {
        
        // MARK: - Overriding Properties
        
        public override class var usageDescriptionPlistKey: String { "NSAppleMusicUsageDescription" }
        
        // MARK: - Overriding Functions
        
        public override class func checkStatus(completion: @escaping (Status) -> Void) {
            let completion = Utils.linkToPreferredQueue(completion)
            
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
        
        public override class func requestAccess(completion: ((Status) -> Void)? = nil) throws {
            try Utils.checkIsAppConfigured(for: music.self, usageDescriptionPlistKey: usageDescriptionPlistKey)
            
            MPMediaLibrary.requestAuthorization { _ in
                guard let completion = completion else {
                    return
                }
                
                self.checkStatus { completion($0) }
            }
        }
        
    }
    
}

#endif
