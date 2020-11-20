//
//  Home.swift
//  PermissionWizard
//
//  Created by Sergey Moskvin on 15.10.2020.
//

#if HOME || !CUSTOM_SETTINGS

import HomeKit

@available(iOS 13, macCatalyst 14, *)
public extension Permission {
    
    final class home: Permission {
        
        public enum Status: String {
            
            case granted
            case denied
            
            case restrictedBySystem
            
        }
        
#if ICONS || !CUSTOM_SETTINGS
        public override class var shouldBorderIcon: Bool { true }
#endif
        
        public override class var usageDescriptionPlistKey: String? { "NSHomeKitUsageDescription" }
        
        private static var existingAgent: Agent?
        
        // MARK: - Public Functions
        
        public class func requestAccess(completion: ((Status) -> Void)? = nil) throws {
            try Utils.checkIsAppConfigured(for: home.self)
            
            if let existingAgent = existingAgent, let completion = completion {
                existingAgent.addCallback(completion)
            } else {
                let manager = HMHomeManager()
                
                existingAgent = Agent(manager) { status in
                    completion?(status)
                    self.existingAgent = nil
                }
            }
        }
        
    }
    
}

#endif
