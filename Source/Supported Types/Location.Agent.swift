//
//  Location.Agent.swift
//  PermissionWizard
//
//  Created by Sergey Moskvin on 24.10.2020.
//

#if LOCATION || !CUSTOM_SETTINGS

import CoreLocation

extension Permission.location {
    
    final class Agent: Permission.SupportedType.Agent<CLLocationManager, Status>, CLLocationManagerDelegate {
        
        // MARK: Life Cycle
        
        override init(_ manager: CLLocationManager, callback: @escaping (Status) -> Void) {
            super.init(manager, callback: callback)
            manager.delegate = self
        }
        
        // MARK: Overriding Properties
        
        override var hasDeterminedStatus: Bool {
            return CLLocationManager.authorizationStatus() != .notDetermined
        }
        
        // MARK: Overriding Functions
        
        override func handleDeterminedStatus() {
            super.handleDeterminedStatus()
            checkStatus { self.invokeCallbacks(with: $0) }
        }
        
        // MARK: Location Manager Delegate
        
        func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
            guard hasDeterminedStatus else {
                return
            }
            
            handleDeterminedStatus()
        }
        
        func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
            // Redirection for iOS 13 and older
            locationManagerDidChangeAuthorization(manager)
        }
        
    }
    
}

#endif
