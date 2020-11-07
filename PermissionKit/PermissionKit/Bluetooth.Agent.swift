//
//  Bluetooth.Agent.swift
//  PermissionKit
//
//  Created by Sergey Moskvin on 31.10.2020.
//

import CoreBluetooth

@available(iOS 13.1, *)
extension Permission.bluetooth {
    
    final class Agent: Base.Agent<CBCentralManager, Status>, CBCentralManagerDelegate {
        
        // MARK: - Life Cycle
        
        override init(_ manager: CBCentralManager, callback: @escaping (Status) -> Void) {
            super.init(manager, callback: callback)
            manager.delegate = self
        }
        
        // MARK: - Overriding Properties
        
        override var hasDeterminedStatus: Bool {
            return CBCentralManager.authorization != .notDetermined
        }
        
        // MARK: - Overriding Functions
        
        override func handleDeterminedStatus() {
            Permission.bluetooth.checkStatus { status in
                self.invokeCallbacks(with: status)
            }
        }
        
        // MARK: - Central Manager Delegate
        
        func centralManagerDidUpdateState(_ central: CBCentralManager) {
            guard hasDeterminedStatus else {
                return
            }
            
            handleDeterminedStatus()
        }
        
    }
    
}
