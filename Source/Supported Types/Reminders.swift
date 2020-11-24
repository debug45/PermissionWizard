//
//  Reminders.swift
//  PermissionWizard
//
//  Created by Sergey Moskvin on 06.10.2020.
//

#if REMINDERS || !CUSTOM_SETTINGS

import EventKit

public extension Permission {
    
    final class reminders: Base {
        
        // MARK: - Overriding Properties
        
        public override class var usageDescriptionPlistKey: String { "NSRemindersUsageDescription" }
        
#if ASSETS || !CUSTOM_SETTINGS
        override class var shouldBorderIcon: Bool { true }
#endif
        
        // MARK: - Overriding Functions
        
        public override class func checkStatus(completion: @escaping (Status) -> Void) {
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
        
        public override class func requestAccess(completion: ((Status) -> Void)? = nil) throws {
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
