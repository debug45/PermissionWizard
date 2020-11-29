//
//  Health.swift
//  PermissionWizard
//
//  Created by Sergey Moskvin on 18.10.2020.
//

#if (HEALTH || !CUSTOM_SETTINGS) && !targetEnvironment(macCatalyst)

import HealthKit

public extension Permission {
    
    final class health: SupportedType {
        
        public typealias Status = Permission.Status.HealthWriting
        
        /**
         A key that must be added to your ”Info.plist“ to work with the permission type. This key is used if you want to read health data.

         For each permission type you are using, Apple requires to add the corresponding string to your ”Info.plist“ that describes a purpose of your access requests
        */
        public static let readingUsageDescriptionPlistKey = "NSHealthUpdateUsageDescription"
        /**
         A key that must be added to your ”Info.plist“ to work with the permission type. This key is used if you want to write health data.

         For each permission type you are using, Apple requires to add the corresponding string to your ”Info.plist“ that describes a purpose of your access requests
        */
        public static let writingUsageDescriptionPlistKey = "NSHealthShareUsageDescription"
        
        // MARK: - Overriding Properties
        
        @available(*, unavailable)
        public override class var usageDescriptionPlistKey: String { .init() }
        
#if ASSETS || !CUSTOM_SETTINGS
        override class var shouldBorderIcon: Bool { true }
#endif
        
        // MARK: - Public Functions
        
        /**
         Asks the system for the current status of the permission type

         Due to limitations of default system API, you can check only write access

         - Parameter dataType: A type of health data, access to which you want to check
         - Parameter completion: A block that will be invoked to return the check result. The invoke will occur in a dispatch queue that is set by ”Permission.preferredQueue“.
        */
        public static func checkStatusForWriting(of dataType: HKObjectType, completion: @escaping (Status) -> Void) {
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
        
        /**
         Asks a user for access the permission type

         To find out a user‘s decision, use the status check method

         - Parameter readingTypes: Types of health data, access to which reading you want to request
         - Parameter writingTypes: Types of health data, access to which writing you want to request
         - Parameter completion: A block that will be invoked after a user makes a decision. The invoke will occur in a dispatch queue that is set by ”Permission.preferredQueue“.
         - Throws: `Permission.Error`, if something went wrong. For example, your ”Info.plist“ is configured incorrectly.
        */
        public static func requestAccess(forReading readingTypes: Set<HKObjectType>, writing writingTypes: Set<HKSampleType>, completion: (() -> Void)? = nil) throws {
            var plistKeys = !readingTypes.isEmpty ? [readingUsageDescriptionPlistKey] : []
            
            if !writingTypes.isEmpty {
                plistKeys.append(writingUsageDescriptionPlistKey)
            }
            
            try Utils.checkIsAppConfigured(for: health.self, usageDescriptionsPlistKeys: plistKeys)
            
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
