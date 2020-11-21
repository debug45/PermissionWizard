//
//  Bluetooth.swift
//  PermissionWizard
//
//  Created by Sergey Moskvin on 25.10.2020.
//

#if BLUETOOTH || !CUSTOM_SETTINGS

import CoreBluetooth

@available(iOS 13.1, *)
public extension Permission {
    
    final class bluetooth: Permission {
        
        public enum Status: String {
            
            case granted
            case denied
            
            case notDetermined
            case restrictedBySystem
            
            case unknown
            
        }
        
        public override class var contextName: String { titleName }
        
        public static let usageDescriptionPlistKey = "NSBluetoothAlwaysUsageDescription"
        
        private static var existingAgent: Agent?
        
        // MARK: - Public Functions
        
        public class func checkStatus(completion: @escaping (Status) -> Void) {
            let completion = Utils.linkToPreferredQueue(completion)
            
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
        
        public class func requestAccess(completion: ((Status) -> Void)? = nil) throws {
            try Utils.checkIsAppConfigured(for: bluetooth.self, usageDescriptionPlistKey: usageDescriptionPlistKey)
            
            if let existingAgent = existingAgent, let completion = completion {
                existingAgent.addCallback(completion)
            } else {
                let manager = CBCentralManager()
                
                existingAgent = Agent(manager) { status in
                    completion?(status)
                    self.existingAgent = nil
                }
            }
        }
        
    }
    
}

#endif
