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
        public typealias Status = Permission.Status.Camera.Combined
#else
        public typealias Status = Permission.Status.Camera
#endif
        
        // MARK: Overriding Properties
        
        public override class var usageDescriptionPlistKey: String { "NSCameraUsageDescription" }
        
        // MARK: Public Functions
        
#if MICROPHONE || !CUSTOM_SETTINGS
        /**
         Asks the system for the current status of the permission type

         - Parameter withMicrophone: A flag indicating whether the microphone permission status should also be checked
         - Parameter completion: A block that will be invoked to return the check result
        */
        public static func checkStatus(withMicrophone: Bool, completion: @escaping (Status) -> Void) {
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
        
        /**
         Asks the system for the current status of the permission type

         - Parameter withMicrophone: A flag indicating whether the microphone permission status should also be checked
        */
        @available(iOS 13, *)
        public static func checkStatus(withMicrophone: Bool) async -> Status {
            await withCheckedContinuation { checkedContinuation in
                checkStatus(withMicrophone: withMicrophone) { status in
                    checkedContinuation.resume(returning: status)
                }
            }
        }
        
        /**
         Asks a user for access the permission type

         - Parameter withMicrophone: A flag indicating whether also to request access for a microphone
         - Parameter completion: A block that will be invoked to return the request result
         - Throws: `Permission.Error`, if something went wrong. For example, your ”Info.plist“ is configured incorrectly.
        */
        public static func requestAccess(withMicrophone: Bool, completion: ((Status) -> Void)? = nil) throws {
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
        
        /**
         Asks a user for access the permission type

         - Parameter withMicrophone: A flag indicating whether also to request access for a microphone
         - Throws: `Permission.Error`, if something went wrong. For example, your ”Info.plist“ is configured incorrectly.
        */
        @available(iOS 13, *)
        public static func requestAccess(withMicrophone: Bool) async throws -> Status {
            try await withCheckedThrowingContinuation { checkedContinuation in
                do {
                    try requestAccess(withMicrophone: withMicrophone) { status in
                        checkedContinuation.resume(returning: status)
                    }
                } catch {
                    checkedContinuation.resume(throwing: error)
                }
            }
        }
#else
        public static func checkStatus(completion: @escaping (Status) -> Void) {
            checkNarrowStatus(completion: completion)
        }
        
        @available(iOS 13, *)
        public static func checkStatus() async -> Status {
            await withCheckedContinuation { checkedContinuation in
                checkStatus { status in
                    checkedContinuation.resume(returning: status)
                }
            }
        }
        
        public static func requestAccess(completion: ((Status) -> Void)? = nil) throws {
            try Utils.checkIsAppConfigured(for: camera.self, usageDescriptionPlistKey: usageDescriptionPlistKey)
            requestNarrowAccess(completion: completion)
        }
        
        @available(iOS 13, *)
        public static func requestAccess() async throws -> Status {
            try await withCheckedThrowingContinuation { checkedContinuation in
                do {
                    try requestAccess { status in
                        checkedContinuation.resume(returning: status)
                    }
                } catch {
                    checkedContinuation.resume(throwing: error)
                }
            }
        }
#endif
        
        // MARK: Private Functions
        
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
