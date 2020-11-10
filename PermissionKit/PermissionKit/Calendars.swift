//
//  Calendars.swift
//  PermissionKit
//
//  Created by Sergey Moskvin on 14.10.2020.
//

#if CALENDARS || !CUSTOM_SETTINGS

import EventKit

public extension Permission {
    
    final class calendars: Permission {
        
        public enum Status: String {
            
            case granted
            case denied
            
            case notDetermined
            case restrictedBySystem
            
            case unknown
            
        }
        
        public override class var usageDescriptionPlistKey: String? { "NSCalendarsUsageDescription" }
        
        // MARK: - Public Functions
        
        public class func checkStatus(completion: @escaping (Status) -> Void) {
            let completion = Utils.linkToPreferredQueue(completion)
            
            switch EKEventStore.authorizationStatus(for: .event) {
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
        
        public class func requestAccess(completion: ((Status) -> Void)? = nil) {
            guard Utils.checkIsAppConfigured(for: calendars.self) else {
                return
            }
            
            EKEventStore().requestAccess(to: .event) { _, _ in
                guard let completion = completion else {
                    return
                }
                
                self.checkStatus { completion($0) }
            }
        }
        
    }
    
}

#endif
