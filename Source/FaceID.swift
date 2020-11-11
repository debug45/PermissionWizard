//
//  FaceID.swift
//  PermissionWizard
//
//  Created by Sergey Moskvin on 31.10.2020.
//

#if FACE_ID || !CUSTOM_SETTINGS

import LocalAuthentication

@available(iOS 11, *)
public extension Permission {
    
    final class faceID: Permission {
        
        public enum Status: String {
            
            case grantedOrNotDetermined
            case denied
            
            case notSupportedByDevice
            case notEnrolled
            
            case unknown
            
        }
        
        public override class var titleName: String { "Face ID" }
        public override class var contextName: String { titleName }
        
        public override class var usageDescriptionPlistKey: String? { "NSFaceIDUsageDescription" }
        
        // MARK: - Public Functions
        
        public class func checkStatus(completion: @escaping (Status) -> Void) {
            let context = LAContext()
            
            var error: NSError?
            let isReady = context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error)
            
            let completion = Utils.linkToPreferredQueue(completion)
            
            guard context.biometryType == .faceID else {
                completion(.notSupportedByDevice)
                return
            }
            
            switch error?.code {
                case nil where isReady:
                    completion(.grantedOrNotDetermined)
                case LAError.biometryNotAvailable.rawValue:
                    completion(.denied)
                case LAError.biometryNotEnrolled.rawValue:
                    completion(.notEnrolled)
                
                default:
                    completion(.unknown)
            }
        }
        
        public class func requestAccess(completion: ((Status) -> Void)? = nil) {
            guard Utils.checkIsAppConfigured(for: faceID.self) else {
                return
            }
            
            LAContext().evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: " ") { _, _ in
                guard let completion = completion else {
                    return
                }
                
                self.checkStatus { completion($0) }
            }
        }
        
    }
    
}

#endif
