//
//  Contacts.swift
//  PermissionWizard
//
//  Created by Sergei Moskvin on 03.10.2020.
//

#if CONTACTS || !CUSTOM_SETTINGS

import Contacts

public extension Permission {
    
    final class contacts: SupportedType, Checkable, Requestable {
        
        public typealias Status = Permission.Status.Common
        
        // MARK: Overriding Properties
        
        public override class var usageDescriptionPlistKey: String { "NSContactsUsageDescription" }
        
        // MARK: Public Functions
        
        public static func checkStatus(completion: @escaping (Status) -> Void, forcedInvokationQueue: DispatchQueue? = Constants.defaultCompletionInvokationQueue) {
            var completion = completion
            
            if let forcedInvokationQueue = forcedInvokationQueue {
                completion = Utils.linkToQueue(forcedInvokationQueue, closure: completion)
            }
            
            switch CNContactStore.authorizationStatus(for: .contacts) {
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
        
        public static func checkStatus() async -> Status {
            await withCheckedContinuation { checkedContinuation in
                checkStatus { status in
                    checkedContinuation.resume(returning: status)
                }
            }
        }
        
        public static func requestAccess(completion: ((Status) -> Void)? = nil, forcedInvokationQueue: DispatchQueue? = Constants.defaultCompletionInvokationQueue) throws {
            try Utils.checkIsAppConfigured(for: contacts.self, usageDescriptionPlistKey: usageDescriptionPlistKey)
            
            CNContactStore().requestAccess(for: .contacts) { _, _ in
                guard let completion = completion else {
                    return
                }
                
                self.checkStatus(completion: {
                    completion($0)
                }, forcedInvokationQueue: forcedInvokationQueue)
            }
        }
        
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
