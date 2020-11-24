//
//  Camera.swift
//  PermissionWizard
//
//  Created by Sergey Moskvin on 17.10.2020.
//

#if CAMERA || !CUSTOM_SETTINGS

import AVKit

public extension Permission {
    
    final class camera: Base {
        
        // MARK: - Overriding Properties
        
        public override class var usageDescriptionPlistKey: String { "NSCameraUsageDescription" }
        
        // MARK: - Overriding Functions
        
#if MICROPHONE || !CUSTOM_SETTINGS
        @available(*, unavailable)
        public override class func checkStatus(completion: @escaping (Status) -> Void) { }
        
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
        
        @available(*, unavailable)
        public override class func requestAccess(completion: ((Status) -> Void)? = nil) throws { }
        
        public class func requestAccess(withMicrophone: Bool, completion: ((CombinedStatus) -> Void)? = nil) throws {
            try Utils.checkIsAppConfigured(for: camera.self, usageDescriptionPlistKey: usageDescriptionPlistKey)
            
            if withMicrophone {
                try Utils.checkIsAppConfigured(for: microphone.self, usageDescriptionPlistKey: microphone.usageDescriptionPlistKey)
            }
            
            requestNarrowAccess { narrow in
                guard completion != nil || withMicrophone else {
                    return
                }
                
                var combined: CombinedStatus = (camera: narrow, microphone: nil)
                
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
        public override class func checkStatus(completion: @escaping (NarrowStatus) -> Void) {
            checkNarrowStatus(completion: completion)
        }
        
        public override class func requestAccess(completion: ((NarrowStatus) -> Void)? = nil) {
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
