//
//  Location.Agent.swift
//  PermissionKit
//
//  Created by Sergey Moskvin on 24.10.2020.
//

import CoreLocation

extension Permission.location {
    
    final class Agent: NSObject, CLLocationManagerDelegate {
        
        private static var serviceInstance: Agent?
        
        private var manager: CLLocationManager?
        private var callbacks: [(CombinedStatus) -> Void] = []
        
        // MARK: - Life Cycle
        
        convenience init(_ manager: CLLocationManager) {
            self.init()
            
            manager.delegate = self
            self.manager = manager
        }
        
        // MARK: - Internal Functions
        
        static func takeControl(_ manager: CLLocationManager, callback: ((CombinedStatus) -> Void)?) {
            if serviceInstance == nil {
                serviceInstance = .init(manager)
            }
            
            if let callback = callback {
                serviceInstance?.callbacks.append(callback)
            }
            
            if CLLocationManager.authorizationStatus() != .notDetermined {
                serviceInstance?.handleDeterminedAndDestruct()
            }
        }
        
        // MARK: - Location Manager Delegate
        
        func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
            guard CLLocationManager.authorizationStatus() != .notDetermined else {
                return
            }
            
            handleDeterminedAndDestruct()
        }
        
        func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
            // Redirection for iOS 13 and older
            locationManagerDidChangeAuthorization(manager)
        }
        
        // MARK: - Private Functions
        
        private func handleDeterminedAndDestruct() {
            Permission.location.checkStatus { status in
                callbacks.forEach { $0(status) }
            }
            
            Self.serviceInstance = nil
        }
        
    }
    
}
