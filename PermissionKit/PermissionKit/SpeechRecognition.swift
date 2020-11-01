//
//  SpeechRecognition.swift
//  PermissionKit
//
//  Created by Sergey Moskvin on 15.10.2020.
//

import Speech

@available(iOS 10, *)
public extension Permission {
    
    final class speechRecognition: Base {
        
        public enum Status: String {
            
            case granted
            case denied
            
            case notDetermined
            case restrictedBySystem
            
            case unknown
            
        }
        
        public class override var contextName: String { return "speech recognition" }
        public class override var usageDescriptionPlistKey: String? { "NSSpeechRecognitionUsageDescription" }
        
        // MARK: - Public Functions
        
        public class func checkStatus(completion: (Status) -> Void) {
            switch SFSpeechRecognizer.authorizationStatus() {
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
            guard Utils.checkIsAppConfigured(for: speechRecognition.self) else {
                return
            }
            
            SFSpeechRecognizer.requestAuthorization() { _ in
                guard let completion = completion else {
                    return
                }
                
                self.checkStatus { completion($0) }
            }
        }
        
    }
    
}
