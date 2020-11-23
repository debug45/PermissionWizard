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
    
    final class bluetooth: Base {
        
        /**
         A key that must be added to your ”Info.plist“ to work with the permission type

         For each permission type you are using, Apple requires to add the corresponding string to your ”Info.plist“ that describes a purpose of your access requests
        */
        public static let usageDescriptionPlistKey = "NSBluetoothAlwaysUsageDescription"
        
        override class var contextName: String { "Bluetooth" }
        
        private static var existingAgent: Agent?
        
        // MARK: - Public Functions
        
        /**
         Asks the system for the current status of the permission type

         - Parameter completion: A block that will be invoked to return the check result. The invoke will occur in a dispatch queue that is set by ”Permission.preferredQueue“.
        */
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
        
        /**
         Asks a user for access the permission type

         - Parameter completion: A block that will be invoked to return the request result. The invoke will occur in a dispatch queue that is set by ”Permission.preferredQueue“.
         - Throws: `Permission.Error`, if something went wrong. For example, your ”Info.plist“ is configured incorrectly.
        */
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
