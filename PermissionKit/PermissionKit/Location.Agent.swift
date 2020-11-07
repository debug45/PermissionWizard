//
//  Location.Agent.swift
//  PermissionKit
//
//  Created by Sergey Moskvin on 24.10.2020.
//

import CoreLocation

extension Permission.location {
    
    final class Agent: Base.Agent<CLLocationManager, CombinedStatus>, CLLocationManagerDelegate {
        
        // MARK: - Life Cycle
        
        override init(_ manager: CLLocationManager, callback: @escaping (CombinedStatus) -> Void) {
            super.init(manager, callback: callback)
            manager.delegate = self
        }
        
        // MARK: - Overriding Properties
        
        override var hasDeterminedStatus: Bool {
            return CLLocationManager.authorizationStatus() != .notDetermined
        }
        
        // MARK: - Overriding Functions
        
        override func handleDeterminedStatus() {
            Permission.location.checkStatus { status in
                self.invokeCallbacks(with: status)
            }
        }
        
        // MARK: - Location Manager Delegate
        
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
