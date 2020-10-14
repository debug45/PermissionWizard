//
//  Calendars.swift
//  PermissionKit
//
//  Created by Sergey Moskvin on 14.10.2020.
//

import EventKit

public extension Permission {
    
    final class calendars {
        
        public enum Status: String {
            
            case granted
            case denied
            
            case notDetermined
            case restrictedBySystem
            
            case unknown
            
        }
        
        // MARK: - Public Functions
        
        public static func checkStatus(completion: (Status) -> Void) {
            switch EKEventStore.authorizationStatus(for: .event) {
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
            guard Bundle.main.object(forInfoDictionaryKey: "NSCalendarsUsageDescription") != nil else {
                print("❌ You must add a row with the ”NSCalendarsUsageDescription“ key to your app‘s plist file and specify the reason why you are requesting access to calendars. This information will be displayed to a user.")
                return
            }
            
            let store = EKEventStore()
            
            store.requestAccess(to: .event) { _, _ in
                guard let completion = completion else {
                    return
                }
                
                self.checkStatus { completion($0) }
            }
        }
        
    }
    
}
