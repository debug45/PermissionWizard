//
//  Contacts.swift
//  PermissionKit
//
//  Created by Sergey Moskvin on 03.10.2020.
//

import Contacts

public extension Permission {
    
    final class contacts: Base {
        
        public enum Status: String {
            
            case granted
            case denied
            
            case notDetermined
            case restrictedBySystem
            
            case unknown
            
        }
        
        public static let usageDescriptionPlistKey = "NSContactsUsageDescription"
        
        // MARK: - Public Functions
        
        public class func checkStatus(completion: (Status) -> Void) {
            switch CNContactStore.authorizationStatus(for: .contacts) {
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
            guard Utils.checkIsAppConfigured(for: contacts.self) else {
                return
            }
            
            CNContactStore().requestAccess(for: .contacts) { _, _ in
                guard let completion = completion else {
                    return
                }
                
                self.checkStatus { completion($0) }
            }
        }
        
    }
    
}
