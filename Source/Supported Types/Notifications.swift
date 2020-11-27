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
        
        // MARK: - Overriding Properties
        
        @available(*, unavailable)
        public override class var usageDescriptionPlistKey: String { .init() }
        
        // MARK: - Public Functions
        
        public static func checkStatus(completion: @escaping (Status) -> Void) {
            UNUserNotificationCenter.current().getNotificationSettings { settings in
                let completion = Utils.linkToPreferredQueue(completion)
                
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
        
        public static func requestAccess(options: UNAuthorizationOptions, completion: ((Status) -> Void)? = nil) throws {
            try Utils.checkIsAppConfigured(for: notifications.self)
            
            UNUserNotificationCenter.current().requestAuthorization(options: options) { _, _ in
                guard let completion = completion else {
                    return
                }
                
                self.checkStatus { completion($0) }
            }
        }
        
    }
    
}

#endif
