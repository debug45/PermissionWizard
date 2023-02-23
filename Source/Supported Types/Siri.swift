//
//  Siri.swift
//  PermissionWizard
//
//  Created by Sergei Moskvin on 26.11.2020.
//

#if (SIRI || !CUSTOM_SETTINGS) && !targetEnvironment(macCatalyst)

import Intents

public extension Permission {
    
    final class siri: SupportedType, Checkable, Requestable {
        
        public typealias Status = Permission.Status.Common
        
        // MARK: Overriding Properties
        
        public override class var usageDescriptionPlistKey: String { "NSSiriUsageDescription" }
        
        override class var contextName: String { "Siri" }
        
        // MARK: Public Functions
        
        public static func checkStatus(completion: @escaping (Status) -> Void, forcedInvokationQueue: DispatchQueue? = Constants.defaultCompletionInvokationQueue) {
            var completion = completion
            
            if let forcedInvokationQueue = forcedInvokationQueue {
                completion = Utils.linkToQueue(forcedInvokationQueue, closure: completion)
            }
            
            switch INPreferences.siriAuthorizationStatus() {
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
        
        @available(iOS 13, *)
        public static func checkStatus() async -> Status {
            await withCheckedContinuation { checkedContinuation in
                checkStatus { status in
                    checkedContinuation.resume(returning: status)
                }
            }
        }
        
        public static func requestAccess(completion: ((Status) -> Void)? = nil, forcedInvokationQueue: DispatchQueue? = Constants.defaultCompletionInvokationQueue) throws {
            try Utils.checkIsAppConfigured(for: siri.self, usageDescriptionPlistKey: usageDescriptionPlistKey)
            
            INPreferences.requestSiriAuthorization { _ in
                guard let completion = completion else {
                    return
                }
                
                self.checkStatus(completion: {
                    completion($0)
                }, forcedInvokationQueue: forcedInvokationQueue)
            }
        }
        
        @available(iOS 13, *)
        @discardableResult public static func requestAccess() async throws -> Status {
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
        
    }
    
}

#endif
