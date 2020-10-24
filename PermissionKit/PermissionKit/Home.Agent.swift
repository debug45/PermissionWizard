//
//  Home.Agent.swift
//  PermissionKit
//
//  Created by Sergey Moskvin on 17.10.2020.
//

import HomeKit

extension Permission.home {
    
    final class Agent: NSObject, HMHomeManagerDelegate {
        
        private static var serviceInstance: Agent?
        
        private var manager: HMHomeManager?
        private var callbacks: [(Status) -> Void] = []
        
        // MARK: - Life Cycle
        
        convenience init(_ manager: HMHomeManager) {
            self.init()
            
            manager.delegate = self
            self.manager = manager
        }
        
        // MARK: - Internal Functions
        
        static func takeControl(_ manager: HMHomeManager, callback: ((Status) -> Void)?) {
            if serviceInstance == nil {
                serviceInstance = .init(manager)
            }
            
            if let callback = callback {
                serviceInstance?.callbacks.append(callback)
            }
            
            let status = manager.authorizationStatus
            
            if status.contains(.determined) {
                serviceInstance?.handleDeterminedAndDestruct(status)
            }
        }
        
        // MARK: - Home Manager Delegate
        
        func homeManager(_ manager: HMHomeManager, didUpdate status: HMHomeManagerAuthorizationStatus) {
            guard status.contains(.determined) else {
                return
            }
            
            handleDeterminedAndDestruct(status)
        }
        
        // MARK: - Private Functions
        
        private func handleDeterminedAndDestruct(_ status: HMHomeManagerAuthorizationStatus) {
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
            
            callbacks.forEach { $0(converted) }
            
            Self.serviceInstance = nil
        }
        
    }
    
}
