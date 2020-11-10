//
//  Notifications.swift
//  PermissionKit
//
//  Created by Sergey Moskvin on 18.10.2020.
//

#if NOTIFICATIONS || !CUSTOM_SETTINGS

import UserNotifications

public extension Permission {
    
    final class notifications: Permission {
        
        public enum Status: String {
            
            case granted
            case denied
            
            case notDetermined
            
            case provisionalOnly
            case ephemeralOnly
            
            case unknown
            
        }
        
        // MARK: - Public Functions
        
        public class func checkStatus(completion: @escaping (Status) -> Void) {
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
                    
#if !targetEnvironment(macCatalyst)
                    case .ephemeral:
                        completion(.ephemeralOnly)
#endif
                    
                    @unknown default:
                        completion(.unknown)
                }
            }
        }
        
        public class func requestAccess(options: UNAuthorizationOptions, completion: ((Status) -> Void)? = nil) {
            guard Utils.checkIsAppConfigured(for: notifications.self) else {
                return
            }
            
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
