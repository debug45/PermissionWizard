//
//  Bluetooth.Agent.swift
//  PermissionWizard
//
//  Created by Sergey Moskvin on 31.10.2020.
//

#if BLUETOOTH || !CUSTOM_SETTINGS

import CoreBluetooth

@available(iOS 13.1, *)
extension Permission.bluetooth {
    
    final class Agent: Permission.SupportedType.Agent<CBCentralManager, Status>, CBCentralManagerDelegate {
        
        // MARK: Life Cycle
        
        override init(_ manager: CBCentralManager, callback: @escaping (Status) -> Void) {
            super.init(manager, callback: callback)
            manager.delegate = self
        }
        
        // MARK: Overriding Properties
        
        override var hasDeterminedStatus: Bool {
            return CBCentralManager.authorization != .notDetermined
        }
        
        // MARK: Overriding Functions
        
        override func handleDeterminedStatus() {
            super.handleDeterminedStatus()
            checkStatus { self.invokeCallbacks(with: $0) }
        }
        
        // MARK: Central Manager Delegate
        
        func centralManagerDidUpdateState(_ central: CBCentralManager) {
            guard hasDeterminedStatus else {
                return
            }
            
            handleDeterminedStatus()
        }
        
    }
    
}

#endif
