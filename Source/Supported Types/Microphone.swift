//
//  Microphone.swift
//  PermissionWizard
//
//  Created by Sergey Moskvin on 15.10.2020.
//

#if MICROPHONE || !CUSTOM_SETTINGS

import AVKit

public extension Permission {
    
    final class microphone: SupportedType, Checkable, Requestable {
        
        public typealias Status = Permission.Status.Microphone
        
        // MARK: Overriding Properties
        
        public override class var usageDescriptionPlistKey: String { "NSMicrophoneUsageDescription" }
        
        // MARK: Public Functions
        
        public static func checkStatus(completion: @escaping (Status) -> Void) {
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
        
        @available(iOS 13, *)
        public static func checkStatus() async -> Status {
            await withCheckedContinuation { checkedContinuation in
                checkStatus { status in
                    checkedContinuation.resume(returning: status)
                }
            }
        }
        
        public static func requestAccess(completion: ((Status) -> Void)? = nil) throws {
            try Utils.checkIsAppConfigured(for: microphone.self, usageDescriptionPlistKey: usageDescriptionPlistKey)
            requestAccessForced(completion: completion)
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
        
        // MARK: Internal Functions
        
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
