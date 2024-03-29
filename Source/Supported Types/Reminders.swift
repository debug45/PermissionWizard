//
//  Reminders.swift
//  PermissionWizard
//
//  Created by Sergei Moskvin on 06.10.2020.
//

#if REMINDERS || !CUSTOM_SETTINGS

import EventKit

public extension Permission {
    
    final class reminders: SupportedType, Checkable, Requestable {
        
        public typealias Status = Permission.Status.Common
        
        // MARK: Overriding Properties
        
        public override class var usageDescriptionPlistKey: String { "NSRemindersUsageDescription" }
        
#if ASSETS || !CUSTOM_SETTINGS
        override class var shouldBorderIcon: Bool { true }
#endif
        
        // MARK: Public Functions
        
        public static func checkStatus(completion: @escaping (Status) -> Void, forcedInvokationQueue: DispatchQueue? = Constants.defaultCompletionInvokationQueue) {
            var completion = completion
            
            if let forcedInvokationQueue = forcedInvokationQueue {
                completion = Utils.linkToQueue(forcedInvokationQueue, closure: completion)
            }
            
            switch EKEventStore.authorizationStatus(for: .reminder) {
                case .authorized, .fullAccess:
                    completion(.granted)
                case .denied:
                    completion(.denied)
                case .notDetermined:
                    completion(.notDetermined)
                case .restricted:
                    completion(.restrictedBySystem)
                
                case .writeOnly:
                    fallthrough
                
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
            try Utils.checkIsAppConfigured(for: reminders.self, usageDescriptionPlistKey: usageDescriptionPlistKey)
            
            let completion: EKEventStoreRequestAccessCompletionHandler = { _, _ in
                guard let completion = completion else {
                    return
                }
                
                self.checkStatus(completion: {
                    completion($0)
                }, forcedInvokationQueue: forcedInvokationQueue)
            }
            
            let eventStore = EKEventStore()
            
            if #available(iOS 17, *) {
                eventStore.requestFullAccessToReminders(completion: completion)
            } else {
                eventStore.requestAccess(to: .reminder, completion: completion)
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
