//
//  Contacts.swift
//  PermissionKit
//
//  Created by Sergey Moskvin on 03.10.2020.
//

import Contacts

public extension Permission {
    
    class contacts {
        
        public enum Status: String {
            
            case granted
            case denied
            
            case notDetermined
            case restrictedBySystem
            
            case unknown
            
        }
        
        // MARK: - Public Functions
        
        public static func checkStatus(completion: (Status) -> Void) {
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
        
        public static func requestAccess(completion: ((Status) -> Void)? = nil) {
            guard Bundle.main.object(forInfoDictionaryKey: "NSContactsUsageDescription") != nil else {
                print("❌ You must add a row with the ”NSContactsUsageDescription“ key to your app‘s plist file and specify the reason why you are requesting access to contacts. This information will be displayed to a user.")
                return
            }
            
            let store = CNContactStore()
            
            store.requestAccess(for: .contacts) { _, _ in
                guard let completion = completion else {
                    return
                }
                
                self.checkStatus { completion($0) }
            }
        }
        
    }
    
}
