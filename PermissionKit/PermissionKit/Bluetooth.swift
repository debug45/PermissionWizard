//
//  Bluetooth.swift
//  PermissionKit
//
//  Created by Sergey Moskvin on 25.10.2020.
//

import CoreBluetooth

public extension Permission {
    
    final class bluetooth: Base {
        
        public enum Status: String {
            
            case granted
            case denied
            
            case notDetermined
            case restrictedBySystem
            
            case unknown
            
        }
        
        public class override var contextName: String { return "Bluetooth" }
        public class override var usageDescriptionPlistKey: String? { "NSBluetoothAlwaysUsageDescription" }
        
        // MARK: - Public Functions
        
        public class func checkStatus(completion: (Status) -> Void) {
            switch CBCentralManager.authorization {
                case .allowedAlways:
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
        
        public class func requestAccess(completion: ((Status) -> Void)? = nil) {
            guard Utils.checkIsAppConfigured(for: bluetooth.self) else {
                return
            }
            
            let manager = CBCentralManager(delegate: nil, queue: nil, options: nil)
            Agent.takeControl(manager, callback: completion)
        }
        
    }
    
}
