//
//  Location.swift
//  PermissionKit
//
//  Created by Sergey Moskvin on 24.10.2020.
//

#if LOCATION || !CUSTOM_SETTINGS

import CoreLocation

public extension Permission {
    
    final class location: Permission {
        
        public enum NarrowStatus: String {
            
            case granted
            case denied
            
            case whenInUseOnly
            
            case notDetermined
            case restrictedBySystem
            
            case unknown
            
        }
        
        public typealias CombinedStatus = (value: NarrowStatus, isReducing: Bool)
        
        public static let alwaysUsageDescriptionPlistKeys = [
            "NSLocationAlwaysAndWhenInUseUsageDescription", // Required for iOS 11 and newer
            "NSLocationAlwaysUsageDescription" // Only for iOS 10
        ]
        
        public static let whenInUseOnlyUsageDescriptionPlistKey = "NSLocationWhenInUseUsageDescription"
        
        private static var existingAgent: Agent?
        
        // MARK: - Public Functions
        
        public class func checkStatus(completion: @escaping (CombinedStatus) -> Void) {
            let manager = CLLocationManager()
            
            let narrow: NarrowStatus
            
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
            
            var combined = CombinedStatus(value: narrow, isReducing: false)
            
#if !targetEnvironment(macCatalyst)
            if #available(iOS 14, *) {
                combined.isReducing = manager.accuracyAuthorization != .fullAccuracy
            }
#endif
            
            let completion = Utils.linkToPreferredQueue(completion)
            completion(combined)
        }
        
        public class func requestAccess(whenInUseOnly: Bool, completion: ((CombinedStatus) -> Void)? = nil) {
            let plistKeys = whenInUseOnly ? [whenInUseOnlyUsageDescriptionPlistKey] : alwaysUsageDescriptionPlistKeys
            
            guard Utils.checkIsAppConfigured(for: location.self, usageDescriptionsPlistKeys: plistKeys) else {
                return
            }
            
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
        
#if !targetEnvironment(macCatalyst)
        
        @available(iOS 14, *)
        public class func requestTemporaryPreciseAccess(purposePlistKey: String, completion: ((Bool) -> Void)? = nil) {
            guard Utils.checkIsAppConfiguredForTemporaryPreciseLocationAccess(purposePlistKey: purposePlistKey) else {
                return
            }
            
            let manager = CLLocationManager()
            
            manager.requestTemporaryFullAccuracyAuthorization(withPurposeKey: purposePlistKey) { _ in
                guard let unwrapped = completion else {
                    return
                }
                
                let completion = Utils.linkToPreferredQueue(unwrapped)
                completion(manager.accuracyAuthorization == .fullAccuracy)
            }
        }
        
#endif
        
    }
    
}

#endif
