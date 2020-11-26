//
//  Camera.swift
//  PermissionWizard
//
//  Created by Sergey Moskvin on 17.10.2020.
//

#if CAMERA || !CUSTOM_SETTINGS

import AVKit

#if !MICROPHONE && CUSTOM_SETTINGS
    extension Permission.camera: Checkable, Requestable { }
#endif

public extension Permission {
    
    final class camera: SupportedType {
        
#if MICROPHONE || !CUSTOM_SETTINGS
        public typealias Status = Permission.Status.CameraCombined
#else
        public typealias Status = Permission.Status.Camera
#endif
        
        // MARK: - Overriding Properties
        
        public override class var usageDescriptionPlistKey: String { "NSCameraUsageDescription" }
        
        // MARK: - Public Functions
        
#if MICROPHONE || !CUSTOM_SETTINGS
        public class func checkStatus(withMicrophone: Bool, completion: @escaping (Status) -> Void) {
            checkNarrowStatus { narrow in
                var combined = Status(camera: narrow, microphone: nil)
                
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
        
        public class func requestAccess(withMicrophone: Bool, completion: ((Status) -> Void)? = nil) throws {
            try Utils.checkIsAppConfigured(for: camera.self, usageDescriptionPlistKey: usageDescriptionPlistKey)
            
            if withMicrophone {
                try Utils.checkIsAppConfigured(for: microphone.self, usageDescriptionPlistKey: microphone.usageDescriptionPlistKey)
            }
            
            requestNarrowAccess { narrow in
                guard completion != nil || withMicrophone else {
                    return
                }
                
                var combined: Status = (camera: narrow, microphone: nil)
                
                if withMicrophone {
                    microphone.requestAccessForced { status in
                        combined.microphone = status
                        completion?(combined)
                    }
                } else {
                    completion?(combined)
                }
            }
        }
#else
        public class func checkStatus(completion: @escaping (Status) -> Void) {
            checkNarrowStatus(completion: completion)
        }
        
        public class func requestAccess(completion: ((Status) -> Void)? = nil) throws {
            try Utils.checkIsAppConfigured(for: camera.self, usageDescriptionPlistKey: usageDescriptionPlistKey)
            requestNarrowAccess(completion: completion)
        }
#endif
        
        // MARK: - Private Functions
        
        private static func checkNarrowStatus(completion: @escaping (Permission.Status.Common) -> Void) {
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
        
        private static func requestNarrowAccess(completion: ((Permission.Status.Common) -> Void)? = nil) {
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
