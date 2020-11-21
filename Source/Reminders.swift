//
//  Reminders.swift
//  PermissionWizard
//
//  Created by Sergey Moskvin on 06.10.2020.
//

#if REMINDERS || !CUSTOM_SETTINGS

import EventKit

public extension Permission {
    
    final class reminders: Permission {
        
        public enum Status: String {
            
            case granted
            case denied
            
            case notDetermined
            case restrictedBySystem
            
            case unknown
            
        }
        
#if ICONS || !CUSTOM_SETTINGS
        public override class var shouldBorderIcon: Bool { true }
#endif
        
        public static let usageDescriptionPlistKey = "NSRemindersUsageDescription"
        
        // MARK: - Public Functions
        
        public class func checkStatus(completion: @escaping (Status) -> Void) {
            let completion = Utils.linkToPreferredQueue(completion)
            
            switch EKEventStore.authorizationStatus(for: .reminder) {
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
        
        public class func requestAccess(completion: ((Status) -> Void)? = nil) throws {
            try Utils.checkIsAppConfigured(for: reminders.self, usageDescriptionPlistKey: usageDescriptionPlistKey)
            
            EKEventStore().requestAccess(to: .reminder) { _, _ in
                guard let completion = completion else {
                    return
                }
                
                self.checkStatus { completion($0) }
            }
        }
        
    }
    
}

#endif
