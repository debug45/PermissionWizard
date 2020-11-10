//
//  Home.Agent.swift
//  Permission Wizard
//
//  Created by Sergey Moskvin on 17.10.2020.
//

#if HOME || !CUSTOM_SETTINGS
#if !targetEnvironment(macCatalyst)

import HomeKit

@available(iOS 13, *)
extension Permission.home {
    
    final class Agent: Permission.Agent<HMHomeManager, Status>, HMHomeManagerDelegate {
        
        // MARK: - Life Cycle
        
        override init(_ manager: HMHomeManager, callback: @escaping (Status) -> Void) {
            super.init(manager, callback: callback)
            manager.delegate = self
        }
        
        // MARK: - Overriding Properties
        
        override var hasDeterminedStatus: Bool {
            return manager.authorizationStatus.contains(.determined)
        }
        
        // MARK: - Overriding Functions
        
        override func handleDeterminedStatus() {
            super.handleDeterminedStatus()
            
            let status = manager.authorizationStatus
            let converted: Status
            
            if status.contains(.authorized) {
                if status.contains(.restricted) {
                    converted = .restrictedBySystem
                } else {
                    converted = .granted
                }
            } else {
                converted = .denied
            }
            
            invokeCallbacks(with: converted)
        }
        
        // MARK: - Home Manager Delegate
        
        func homeManager(_ manager: HMHomeManager, didUpdate status: HMHomeManagerAuthorizationStatus) {
            guard hasDeterminedStatus else {
                return
            }
            
            handleDeterminedStatus()
        }
        
    }
    
}

#endif
#endif
