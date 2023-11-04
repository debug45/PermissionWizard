//
//  Health.swift
//  PermissionWizard
//
//  Created by Sergei Moskvin on 18.10.2020.
//

#if (HEALTH || !CUSTOM_SETTINGS) && !targetEnvironment(macCatalyst)

import HealthKit

public extension Permission {
    
    final class health: SupportedType {
        
        public typealias Status = Permission.Status.HealthWriting
        
        // MARK: Overriding Properties
        
        @available(*, unavailable)
        public override class var usageDescriptionPlistKey: String { .init() }
        
#if ASSETS || !CUSTOM_SETTINGS
        override class var shouldBorderIcon: Bool { true }
#endif
        
        // MARK: Public Properties
        
        /**
         A key that must be added to your “Info.plist” to work with the permission type. This key is used if you want to read health data.

         For each permission type you are using, Apple requires to add the corresponding string to your “Info.plist” that describes a purpose of your access requests
        */
        public static let readingUsageDescriptionPlistKey = "NSHealthUpdateUsageDescription"
        /**
         A key that must be added to your “Info.plist” to work with the permission type. This key is used if you want to write health data.

         For each permission type you are using, Apple requires to add the corresponding string to your “Info.plist” that describes a purpose of your access requests
        */
        public static let writingUsageDescriptionPlistKey = "NSHealthShareUsageDescription"
        
        // MARK: Public Functions
        
        /**
         Asks the system for the current status of the permission type

         Due to limitations of default system API, you can check only write access

         - Parameter dataType: A type of health data, access to which you want to check
         - Parameter completion: A closure that will be invoked to return the check result
         - Parameter forcedInvokationQueue: A forced dispatch queue to invoke the completion closure. The default value is `DispatchQueue.main`.
        */
        public static func checkStatusForWriting(of dataType: HKObjectType, completion: @escaping (Status) -> Void, forcedInvokationQueue: DispatchQueue? = Constants.defaultCompletionInvokationQueue) {
            var completion = completion
            
            if let forcedInvokationQueue = forcedInvokationQueue {
                completion = Utils.linkToQueue(forcedInvokationQueue, closure: completion)
            }
            
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
         Asks the system for the current status of the permission type

         Due to limitations of default system API, you can check only write access

         - Parameter dataType: A type of health data, access to which you want to check
        */
        public static func checkStatusForWriting(of dataType: HKObjectType) async -> Status {
            await withCheckedContinuation { checkedContinuation in
                checkStatusForWriting(of: dataType) { status in
                    checkedContinuation.resume(returning: status)
                }
            }
        }
        
        /**
         Asks a user for access the permission type

         To find out a user’s decision, use the status check method

         - Parameter readingTypes: Types of health data, access to which reading you want to request
         - Parameter writingTypes: Types of health data, access to which writing you want to request
         - Parameter completion: A closure that will be invoked after a user makes a decision
         - Parameter forcedInvokationQueue: A forced dispatch queue to invoke the completion closure. The default value is `DispatchQueue.main`.
         - Throws: `Permission.Error`, if something went wrong. For example, your “Info.plist” is configured incorrectly.
        */
        public static func requestAccess(forReading readingTypes: Set<HKObjectType>, writing writingTypes: Set<HKSampleType>, completion: (() -> Void)? = nil, forcedInvokationQueue: DispatchQueue? = Constants.defaultCompletionInvokationQueue) throws {
            var plistKeys = !readingTypes.isEmpty ? [readingUsageDescriptionPlistKey] : []
            
            if !writingTypes.isEmpty {
                plistKeys.append(writingUsageDescriptionPlistKey)
            }
            
            try Utils.checkIsAppConfigured(for: health.self, usageDescriptionsPlistKeys: plistKeys)
            
            HKHealthStore().requestAuthorization(toShare: writingTypes, read: readingTypes) { _, _ in
                guard var completion = completion else {
                    return
                }
                
                if let forcedInvokationQueue = forcedInvokationQueue {
                    completion = Utils.linkToQueue(forcedInvokationQueue, closure: completion)
                }
                
                completion()
            }
        }
        
        /**
         Asks a user for access the permission type

         The method will return after a user makes a decision. To find out the decision, use the status check method.

         - Parameter readingTypes: Types of health data, access to which reading you want to request
         - Parameter writingTypes: Types of health data, access to which writing you want to request
         - Throws: `Permission.Error`, if something went wrong. For example, your “Info.plist” is configured incorrectly.
        */
        public static func requestAccess(forReading readingTypes: Set<HKObjectType>, writing writingTypes: Set<HKSampleType>) async throws {
            try await withCheckedThrowingContinuation { checkedContinuation in
                do {
                    try requestAccess(forReading: readingTypes, writing: writingTypes) {
                        checkedContinuation.resume()
                    }
                } catch {
                    checkedContinuation.resume(throwing: error)
                }
            }
        }
        
    }
    
}

#endif
