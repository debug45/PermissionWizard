//
//  Camera.swift
//  PermissionWizard
//
//  Created by Sergey Moskvin on 17.10.2020.
//

#if CAMERA || !CUSTOM_SETTINGS

import AVKit

public extension Permission {
    
    final class camera: Permission {
        
        public enum NarrowStatus: String {
            
            case granted
            case denied
            
            case notDetermined
            case restrictedBySystem
            
            case unknown
            
        }
        
#if MICROPHONE || !CUSTOM_SETTINGS
        public typealias CombinedStatus = (camera: NarrowStatus, microphone: microphone.Status?)
#endif
        
        public override class var usageDescriptionPlistKey: String? { "NSCameraUsageDescription" }
        
        // MARK: - Public Functions
        
#if MICROPHONE || !CUSTOM_SETTINGS
        public class func checkStatus(withMicrophone: Bool, completion: @escaping (CombinedStatus) -> Void) {
            checkNarrowStatus { narrow in
                var combined = CombinedStatus(camera: narrow, microphone: nil)
                
                if withMicrophone {
                    microphone.checkStatus { status in
                        combined.microphone = status
                        completion(combined)
                    }
                } else {
                    completion(combined)
                }
            }
        }
        
        public class func requestAccess(withMicrophone: Bool, completion: ((CombinedStatus) -> Void)? = nil) {
            var checklist: [Permission.Type] = [camera.self]
            
            if withMicrophone {
                checklist.append(microphone.self)
            }
            
            guard checklist.allSatisfy({ Utils.checkIsAppConfigured(for: $0) }) else {
                return
            }
            
            requestNarrowAccess { narrow in
                guard completion != nil || withMicrophone else {
                    return
                }
                
                var combined: CombinedStatus = (camera: narrow, microphone: nil)
                
                if withMicrophone {
                    microphone.requestAccess { status in
                        combined.microphone = status
                        completion?(combined)
                    }
                } else {
                    completion?(combined)
                }
            }
        }
#else
        public class func checkStatus(completion: @escaping (NarrowStatus) -> Void) {
            checkNarrowStatus(completion: completion)
        }
        
        public class func requestAccess(completion: ((NarrowStatus) -> Void)? = nil) {
            guard Utils.checkIsAppConfigured(for: camera.self) else {
                return
            }
            
            requestNarrowAccess(completion: completion)
        }
#endif
        
        // MARK: - Private Functions
        
        private static func checkNarrowStatus(completion: @escaping (NarrowStatus) -> Void) {
            let completion = Utils.linkToPreferredQueue(completion)
            
            switch AVCaptureDevice.authorizationStatus(for: .video) {
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
        
        private static func requestNarrowAccess(completion: ((NarrowStatus) -> Void)? = nil) {
            AVCaptureDevice.requestAccess(for: .video) { _ in
                guard let completion = completion else {
                    return
                }
                
                checkNarrowStatus { narrow in
                    completion(narrow)
                }
            }
        }
        
    }
    
}

#endif
