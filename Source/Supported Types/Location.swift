//
//  Location.swift
//  PermissionWizard
//
//  Created by Sergey Moskvin on 24.10.2020.
//

#if LOCATION || !CUSTOM_SETTINGS

import CoreLocation

public extension Permission {
    
    final class location: SupportedType, Checkable {
        
        public typealias Status = Permission.Status.Location.Combined
        
        /**
         Keys that must be added to your ”Info.plist“ to work with the permission type. These keys are used if you want to access location even when an app is not being used right now.

         For each permission type you are using, Apple requires to add the corresponding string to your ”Info.plist“ that describes a purpose of your access requests
        */
        public static let alwaysUsageDescriptionPlistKeys = [
            "NSLocationAlwaysAndWhenInUseUsageDescription", // Required for iOS 11 and newer
            "NSLocationAlwaysUsageDescription" // Only for iOS 10
        ]
        
        /**
         A key that must be added to your ”Info.plist“ to work with the permission type. This key is used if you want to access location only when an app is being used right now.

         For each permission type you are using, Apple requires to add the corresponding string to your ”Info.plist“ that describes a purpose of your access requests
        */
        public static let whenInUseOnlyUsageDescriptionPlistKey = "NSLocationWhenInUseUsageDescription"
        
        private static var existingAgent: Agent?
        
        // MARK: - Overriding Properties
        
        @available(*, unavailable)
        public override class var usageDescriptionPlistKey: String { .init() }
        
        // MARK: - Public Functions
        
        public static func checkStatus(completion: @escaping (Status) -> Void) {
            let manager = CLLocationManager()
            
            let narrow: Permission.Status.Location.Narrow
            
            switch CLLocationManager.authorizationStatus() {
                case .authorizedAlways:
                    narrow = .granted
                case .denied:
                    narrow = .denied
                case .authorizedWhenInUse:
                    narrow = .whenInUseOnly
                case .notDetermined:
                    narrow = .notDetermined
                case .restricted:
                    narrow = .restrictedBySystem
                
                @unknown default:
                    narrow = .unknown
            }
            
            var combined = Status(value: narrow, isAccuracyReducing: false)
            
            if #available(iOS 14, *), narrow != .notDetermined {
                combined.isAccuracyReducing = manager.accuracyAuthorization != .fullAccuracy
            }
            
            let completion = Utils.linkToPreferredQueue(completion)
            completion(combined)
        }
        
        /**
         Asks a user for access the permission type

         - Parameter whenInUseOnly: A flag indicating whether you want to access location only when an app is being used right now
         - Parameter completion: A block that will be invoked to return the request result. The invoke will occur in a dispatch queue that is set by ”Permission.preferredQueue“.
         - Throws: `Permission.Error`, if something went wrong. For example, your ”Info.plist“ is configured incorrectly.
        */
        public static func requestAccess(whenInUseOnly: Bool, completion: ((Status) -> Void)? = nil) throws {
            let plistKeys = whenInUseOnly ? [whenInUseOnlyUsageDescriptionPlistKey] : alwaysUsageDescriptionPlistKeys
            try Utils.checkIsAppConfigured(for: location.self, usageDescriptionsPlistKeys: plistKeys)
            
            if let existingAgent = existingAgent, let completion = completion {
                existingAgent.addCallback(completion)
            } else {
                let manager = CLLocationManager()
                
                if whenInUseOnly {
                    manager.requestWhenInUseAuthorization()
                } else {
                    manager.requestAlwaysAuthorization()
                }
                
                existingAgent = Agent(manager) { status in
                    completion?(status)
                    self.existingAgent = nil
                }
            }
        }
        
        /**
         Asks a user for access temporary precise location data

         It may be useful if a user grants access to location data only with reduced accuracy

         - Parameter purposePlistKey: A key that describes the purpose of your request. You must add a row with this key to your app‘s plist file, to a nested dictionary with the key ”NSLocationTemporaryUsageDescriptionDictionary“.
         - Parameter completion: A block that will be invoked to return the request result. The invoke will occur in a dispatch queue that is set by ”Permission.preferredQueue“.
         - Throws: `Permission.Error`, if something went wrong. For example, your ”Info.plist“ is configured incorrectly.
        */
        @available(iOS 14, *)
        public static func requestTemporaryPreciseAccess(purposePlistKey: String, completion: ((Bool) -> Void)? = nil) throws {
            try Utils.checkIsAppConfiguredForTemporaryPreciseLocationAccess(purposePlistKey: purposePlistKey)
            
            let manager = CLLocationManager()
            
            manager.requestTemporaryFullAccuracyAuthorization(withPurposeKey: purposePlistKey) { _ in
                guard let unwrapped = completion else {
                    return
                }
                
                let completion = Utils.linkToPreferredQueue(unwrapped)
                completion(manager.accuracyAuthorization == .fullAccuracy)
            }
        }
        
    }
    
}

#endif
