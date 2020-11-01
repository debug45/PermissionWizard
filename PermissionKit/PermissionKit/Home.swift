//
//  Home.swift
//  PermissionKit
//
//  Created by Sergey Moskvin on 15.10.2020.
//

import HomeKit

@available(iOS 13, *)
public extension Permission {
    
    final class home: Base {
        
        public enum Status: String {
            
            case granted
            case denied
            
            case restrictedBySystem
            
        }
        
        public class override var usageDescriptionPlistKey: String? { "NSHomeKitUsageDescription" }
        
        // MARK: - Public Functions
        
        public class func requestAccess(completion: ((Status) -> Void)? = nil) {
            guard Utils.checkIsAppConfigured(for: home.self) else {
                return
            }
            
            let manager = HMHomeManager()
            Agent.takeControl(manager, callback: completion)
        }
        
    }
    
}
