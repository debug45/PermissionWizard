//
//  Siri.swift
//  PermissionWizard
//
//  Created by Sergey Moskvin on 26.11.2020.
//

#if (SIRI || !CUSTOM_SETTINGS) && !targetEnvironment(macCatalyst)

import Intents

public extension Permission {
    
    final class siri: SupportedType, Checkable, Requestable {
        
        public typealias Status = Permission.Status.Common
        
        // MARK: - Overriding Properties
        
        public override class var usageDescriptionPlistKey: String { "NSSiriUsageDescription" }
        
        override class var contextName: String { "Siri" }
        
        // MARK: - Public Functions
        
        public static func checkStatus(completion: @escaping (Status) -> Void) {
            let completion = Utils.linkToPreferredQueue(completion)
            
            switch INPreferences.siriAuthorizationStatus() {
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
        
        public static func requestAccess(completion: ((Status) -> Void)? = nil) throws {
            try Utils.checkIsAppConfigured(for: siri.self, usageDescriptionPlistKey: usageDescriptionPlistKey)
            
            INPreferences.requestSiriAuthorization { _ in
                guard let completion = completion else {
                    return
                }
                
                self.checkStatus { completion($0) }
            }
        }
        
    }
    
}

#endif
