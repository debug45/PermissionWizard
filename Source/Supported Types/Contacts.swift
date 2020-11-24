//
//  Contacts.swift
//  PermissionWizard
//
//  Created by Sergey Moskvin on 03.10.2020.
//

#if CONTACTS || !CUSTOM_SETTINGS

import Contacts

public extension Permission {
    
    final class contacts: Base {
        
        // MARK: - Overriding Properties
        
        public override class var usageDescriptionPlistKey: String { "NSContactsUsageDescription" }
        
        // MARK: - Overriding Functions
        
        public override class func checkStatus(completion: @escaping (Status) -> Void) {
            let completion = Utils.linkToPreferredQueue(completion)
            
            switch CNContactStore.authorizationStatus(for: .contacts) {
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
            try Utils.checkIsAppConfigured(for: contacts.self, usageDescriptionPlistKey: usageDescriptionPlistKey)
            
            CNContactStore().requestAccess(for: .contacts) { _, _ in
                guard let completion = completion else {
                    return
                }
                
                self.checkStatus { completion($0) }
            }
        }
        
    }
    
}

#endif
