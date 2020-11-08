//
//  Reminders.swift
//  PermissionKit
//
//  Created by Sergey Moskvin on 06.10.2020.
//

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
        
        public override class var usageDescriptionPlistKey: String? { "NSRemindersUsageDescription" }
        
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
        
        public class func requestAccess(completion: ((Status) -> Void)? = nil) {
            guard Utils.checkIsAppConfigured(for: reminders.self) else {
                return
            }
            
            EKEventStore().requestAccess(to: .reminder) { _, _ in
                guard let completion = completion else {
                    return
                }
                
                self.checkStatus { completion($0) }
            }
        }
        
    }
    
}
