//
//  Health.swift
//  PermissionWizard
//
//  Created by Sergey Moskvin on 18.10.2020.
//

#if HEALTH || !CUSTOM_SETTINGS
#if !targetEnvironment(macCatalyst)

import HealthKit

public extension Permission {
    
    final class health: Permission {
        
        public enum WritingStatus: String {
            
            case granted
            case denied
            
            case notDetermined
            case unknown
            
        }
        
        public static let readingUsageDescriptionPlistKey = "NSHealthUpdateUsageDescription"
        public static let writingUsageDescriptionPlistKey = "NSHealthShareUsageDescription"
        
        // MARK: - Public Functions
        
        public class func checkStatusForWriting(of dataType: HKObjectType, completion: @escaping (WritingStatus) -> Void) {
            let completion = Utils.linkToPreferredQueue(completion)
            
            switch HKHealthStore().authorizationStatus(for: dataType) {
                case .sharingAuthorized:
                    completion(.granted)
                case .sharingDenied:
                    completion(.denied)
                case .notDetermined:
                    completion(.notDetermined)
                
                @unknown default:
                    completion(.unknown)
            }
        }
        
        public class func requestAccess(forReading readingTypes: Set<HKObjectType>, writing writingTypes: Set<HKSampleType>, completion: (() -> Void)? = nil) {
            var plistKeys = !readingTypes.isEmpty ? [readingUsageDescriptionPlistKey] : []
            
            if !writingTypes.isEmpty {
                plistKeys.append(writingUsageDescriptionPlistKey)
            }
            
            guard Utils.checkIsAppConfigured(for: health.self, usageDescriptionsPlistKeys: plistKeys) else {
                return
            }
            
            HKHealthStore().requestAuthorization(toShare: writingTypes, read: readingTypes) { _, _ in
                guard let unwrapped = completion else {
                    return
                }
                
                let completion = Utils.linkToPreferredQueue(unwrapped)
                completion()
            }
        }
        
    }
    
}

#endif
#endif
