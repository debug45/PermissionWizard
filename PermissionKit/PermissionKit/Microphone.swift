//
//  Microphone.swift
//  PermissionKit
//
//  Created by Sergey Moskvin on 15.10.2020.
//

import AVKit

public extension Permission {
    
    final class microphone: Permission {
        
        public enum Status: String {
            
            case granted
            case denied
            
            case notDetermined
            case unknown
            
        }
        
        public override class var usageDescriptionPlistKey: String? { "NSMicrophoneUsageDescription" }
        
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
