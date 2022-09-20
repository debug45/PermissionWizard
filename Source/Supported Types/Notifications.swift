//
//  Notifications.swift
//  PermissionWizard
//
//  Created by Sergey Moskvin on 18.10.2020.
//

#if NOTIFICATIONS || !CUSTOM_SETTINGS

import UserNotifications

public extension Permission {
    
    final class notifications: SupportedType, Checkable {
        
        public typealias Status = Permission.Status.Notifications
        
        // MARK: Overriding Properties
        
        @available(*, unavailable)
        public override class var usageDescriptionPlistKey: String { .init() }
        
        // MARK: Public Functions
        
        public static func checkStatus(completion: @escaping (Status) -> Void, forcedInvokationQueue: DispatchQueue? = Constants.defaultCompletionInvokationQueue) {
            UNUserNotificationCenter.current().getNotificationSettings { settings in
                var completion = completion
                
                if let forcedInvokationQueue = forcedInvokationQueue {
                    completion = Utils.linkToQueue(forcedInvokationQueue, closure: completion)
                }
                
                switch settings.authorizationStatus {
                    case .authorized:
                        completion(.granted)
                    case .denied:
                        completion(.denied)
                    case .notDetermined:
                        completion(.notDetermined)
                    case .provisional:
                        completion(.provisionalOnly)
                    case .ephemeral:
                        completion(.ephemeralOnly)
                    
                    @unknown default:
                        completion(.unknown)
                }
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
        
        /**
         Asks a user for access the permission type

         - Parameter options: Notification features, access to which you want to request
         - Parameter completion: A closure that will be invoked to return the request result
         - Parameter forcedInvokationQueue: A forced dispatch queue to invoke the completion closure. The default value is `DispatchQueue.main`.
         - Throws: `Permission.Error`, if something went wrong
        */
        public static func requestAccess(options: UNAuthorizationOptions, completion: ((Status) -> Void)? = nil, forcedInvokationQueue: DispatchQueue? = Constants.defaultCompletionInvokationQueue) throws {
            try Utils.checkIsAppConfigured(for: notifications.self)
            
            UNUserNotificationCenter.current().requestAuthorization(options: options) { _, _ in
                guard let completion = completion else {
                    return
                }
                
                self.checkStatus(completion: {
                    completion($0)
                }, forcedInvokationQueue: forcedInvokationQueue)
            }
        }
        
        /**
         Asks a user for access the permission type

         - Parameter options: Notification features, access to which you want to request
         - Throws: `Permission.Error`, if something went wrong
        */
        @available(iOS 13, *)
        @discardableResult public static func requestAccess(options: UNAuthorizationOptions) async throws -> Status {
            try await withCheckedThrowingContinuation { checkedContinuation in
                do {
                    try requestAccess(options: options) { status in
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
