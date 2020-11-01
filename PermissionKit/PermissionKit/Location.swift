//
//  Location.swift
//  PermissionKit
//
//  Created by Sergey Moskvin on 24.10.2020.
//

import CoreLocation

public extension Permission {
    
    final class location: Base {
        
        public enum NarrowStatus: String {
            
            case granted
            case denied
            
            case whenInUseOnly
            
            case notDetermined
            case restrictedBySystem
            
            case unknown
            
        }
        
        public typealias CombinedStatus = (value: NarrowStatus, isReducing: Bool)
        
        public static let alwaysUsageDescriptionPlistKey = "NSLocationAlwaysAndWhenInUseUsageDescription"
        public static let whenInUseOnlyUsageDescriptionPlistKey = "NSLocationWhenInUseUsageDescription"
        
        // MARK: - Public Functions
        
        public class func checkStatus(completion: (CombinedStatus) -> Void) {
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
            
            var isReducing = false
            
            if #available(iOS 14, *) {
                isReducing = manager.accuracyAuthorization != .fullAccuracy
            }
            
            let combined = CombinedStatus(value: narrow, isReducing: isReducing)
            completion(combined)
        }
        
        public class func requestAccess(whenInUseOnly: Bool, completion: ((CombinedStatus) -> Void)? = nil) {
            let plistKeys = [whenInUseOnly ? whenInUseOnlyUsageDescriptionPlistKey : alwaysUsageDescriptionPlistKey].compactMap { $0 }
            
            guard Utils.checkIsAppConfigured(for: location.self, usageDescriptionsPlistKeys: plistKeys) else {
                return
            }
            
            let manager = CLLocationManager()
            
            if whenInUseOnly {
                manager.requestWhenInUseAuthorization()
            } else {
                manager.requestAlwaysAuthorization()
            }
            
            Agent.takeControl(manager, callback: completion)
        }
        
        @available(iOS 14, *)
        public class func requestTemporaryPreciseAccess(purposePlistKey: String, completion: ((Bool) -> Void)? = nil) {
            guard Utils.checkIsAppConfiguredForTemporaryPreciseLocationAccess(purposePlistKey: purposePlistKey) else {
                return
            }
            
            let manager = CLLocationManager()
            
            manager.requestTemporaryFullAccuracyAuthorization(withPurposeKey: purposePlistKey) { _ in
                completion?(manager.accuracyAuthorization == .fullAccuracy)
            }
        }
        
    }
    
}
