//
//  SpeechRecognition.swift
//  PermissionWizard
//
//  Created by Sergey Moskvin on 15.10.2020.
//

#if SPEECH_RECOGNITION || !CUSTOM_SETTINGS

import Speech

public extension Permission {
    
    final class speechRecognition: Permission {
        
        public enum Status: String {
            
            case granted
            case denied
            
            case notDetermined
            case restrictedBySystem
            
            case unknown
            
        }
        
        public override class var titleName: String { "Speech Recognition" }
        public override class var contextName: String { titleName.lowercased() }
        
        public override class var usageDescriptionPlistKey: String? { "NSSpeechRecognitionUsageDescription" }
        
        // MARK: - Public Functions
        
        public class func checkStatus(completion: @escaping (Status) -> Void) {
            let completion = Utils.linkToPreferredQueue(completion)
            
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

#endif
