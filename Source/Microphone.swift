//
//  Microphone.swift
//  PermissionWizard
//
//  Created by Sergey Moskvin on 15.10.2020.
//

#if MICROPHONE || !CUSTOM_SETTINGS

import AVKit

public extension Permission {
    
    final class microphone: Permission {
        
        public enum Status: String {
            
            case granted
            case denied
            
            case notDetermined
            case unknown
            
        }
        
        public static let usageDescriptionPlistKey = "NSMicrophoneUsageDescription"
        
        // MARK: - Public Functions
        
        public class func checkStatus(completion: @escaping (Status) -> Void) {
            let completion = Utils.linkToPreferredQueue(completion)
            
            switch AVAudioSession.sharedInstance().recordPermission {
                case .granted:
                    completion(.granted)
                case .denied:
                    completion(.denied)
                case .undetermined:
                    completion(.notDetermined)
                
                @unknown default:
                    completion(.unknown)
            }
        }
        
        public class func requestAccess(completion: ((Status) -> Void)? = nil) throws {
            try Utils.checkIsAppConfigured(for: microphone.self, usageDescriptionPlistKey: usageDescriptionPlistKey)
            requestAccessForced(completion: completion)
        }
        
        // MARK: - Internal Functions
        
        static func requestAccessForced(completion: ((Status) -> Void)? = nil) {
            AVAudioSession.sharedInstance().requestRecordPermission { _ in
                guard let completion = completion else {
                    return
                }
                
                self.checkStatus { completion($0) }
            }
        }
        
    }
    
}

#endif
