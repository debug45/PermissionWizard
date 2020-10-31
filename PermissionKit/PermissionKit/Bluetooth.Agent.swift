//
//  Bluetooth.Agent.swift
//  PermissionKit
//
//  Created by Sergey Moskvin on 31.10.2020.
//

import CoreBluetooth

extension Permission.bluetooth {
    
    final class Agent: NSObject, CBCentralManagerDelegate {
        
        private static var serviceInstance: Agent?
        
        private var manager: CBCentralManager?
        private var callbacks: [(Status) -> Void] = []
        
        // MARK: - Life Cycle
        
        convenience init(_ manager: CBCentralManager) {
            self.init()
            
            manager.delegate = self
            self.manager = manager
        }
        
        // MARK: - Internal Functions
        
        static func takeControl(_ manager: CBCentralManager, callback: ((Status) -> Void)?) {
            if serviceInstance == nil {
                serviceInstance = .init(manager)
            }
            
            if let callback = callback {
                serviceInstance?.callbacks.append(callback)
            }
            
            if CBCentralManager.authorization != .notDetermined {
                serviceInstance?.handleDeterminedAndDestruct()
            }
        }
        
        // MARK: - Central Manager Delegate
        
        func centralManagerDidUpdateState(_ central: CBCentralManager) {
            guard CBCentralManager.authorization != .notDetermined else {
                return
            }
            
            handleDeterminedAndDestruct()
        }
        
        // MARK: - Private Functions
        
        private func handleDeterminedAndDestruct() {
            Permission.bluetooth.checkStatus { status in
                callbacks.forEach { $0(status) }
            }
            
            Self.serviceInstance = nil
        }
        
    }
    
}
