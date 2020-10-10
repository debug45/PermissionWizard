//
//  Reminders.swift
//  PermissionKit
//
//  Created by Sergey Moskvin on 06.10.2020.
//

import EventKit

public extension Permission {
    
    final class reminders {
        
        public enum Status: String {
            
            case granted
            case denied
            
            case notDetermined
            case restrictedBySystem
            
            case unknown
            
        }
        
        // MARK: - Public Functions
        
        public static func checkStatus(completion: (Status) -> Void) {
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
        
        public static func requestAccess(completion: ((Status) -> Void)? = nil) {
            guard Bundle.main.object(forInfoDictionaryKey: "NSRemindersUsageDescription") != nil else {
                print("❌ You must add a row with the ”NSRemindersUsageDescription“ key to your app‘s plist file and specify the reason why you are requesting access to reminders. This information will be displayed to a user.")
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
