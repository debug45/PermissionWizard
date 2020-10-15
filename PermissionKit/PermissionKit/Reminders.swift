//
//  Reminders.swift
//  PermissionKit
//
//  Created by Sergey Moskvin on 06.10.2020.
//

import EventKit

public extension Permission {
    
    final class reminders: Base {
        
        public enum Status: String {
            
            case granted
            case denied
            
            case notDetermined
            case restrictedBySystem
            
            case unknown
            
        }
        
        public static let usageDescriptionPlistKey = "NSRemindersUsageDescription"
        
        // MARK: - Public Functions
        
        public class func checkStatus(completion: (Status) -> Void) {
            switch EKEventStore.authorizationStatus(for: .reminder) {
                case .notDetermined:
                    completion(.notDetermined)
                case .restricted:
                    completion(.restrictedBySystem)
                case .denied:
                    completion(.denied)
                case .authorized:
                    completion(.granted)
                
                @unknown default:
                    completion(.unknown)
            }
        }
        
        public class func requestAccess(completion: ((Status) -> Void)? = nil) {
            guard Utils.checkIsAppConfigured(for: reminders.self) else {
                return
            }
            
            let store = EKEventStore()
            
            store.requestAccess(to: .reminder) { _, _ in
                guard let completion = completion else {
                    return
                }
                
                self.checkStatus { completion($0) }
            }
        }
        
    }
    
}
