//
//  Microphone.swift
//  PermissionKit
//
//  Created by Sergey Moskvin on 15.10.2020.
//

import AVKit

public extension Permission {
    
    final class microphone: Base {
        
        public enum Status: String {
            
            case granted
            case denied
            
            case notDetermined
            case unknown
            
        }
        
        public static let usageDescriptionPlistKey = "NSMicrophoneUsageDescription"
        
        // MARK: - Public Functions
        
        public class func checkStatus(completion: (Status) -> Void) {
            switch AVAudioSession.sharedInstance().recordPermission {
                case .undetermined:
                    completion(.notDetermined)
                case .denied:
                    completion(.denied)
                case .granted:
                    completion(.granted)
                
                @unknown default:
                    completion(.unknown)
            }
        }
        
        public class func requestAccess(completion: ((Status) -> Void)? = nil) {
            guard Utils.checkIsAppConfigured(for: microphone.self) else {
                return
            }
            
            AVAudioSession.sharedInstance().requestRecordPermission { _ in
                guard let completion = completion else {
                    return
                }
                
                self.checkStatus { completion($0) }
            }
        }
        
    }
    
}
