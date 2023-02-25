//
//  Location.swift
//  PermissionWizard
//
//  Created by Sergei Moskvin on 24.10.2020.
//

#if LOCATION || !CUSTOM_SETTINGS

import CoreLocation

public extension Permission {
    
    final class location: SupportedType, Checkable {
        
        public typealias Status = Permission.Status.Location.Combined
        
        private static var existingAgent: Agent?
        
        // MARK: Overriding Properties
        
        @available(*, unavailable)
        public override class var usageDescriptionPlistKey: String { .init() }
        
        // MARK: Public Properties
        
        /**
         A key that must be added to your “Info.plist” to work with the permission type. This key is used if you want to access location even when an app is not being used right now.

         For each permission type you are using, Apple requires to add the corresponding string to your “Info.plist” that describes a purpose of your access requests
        */
        public static let alwaysUsageDescriptionPlistKey = "NSLocationAlwaysAndWhenInUseUsageDescription"
        
        /**
         A key that must be added to your “Info.plist” to work with the permission type. This key is used if you want to access location only when an app is being used right now.

         For each permission type you are using, Apple requires to add the corresponding string to your “Info.plist” that describes a purpose of your access requests
        */
        public static let whenInUseOnlyUsageDescriptionPlistKey = "NSLocationWhenInUseUsageDescription"
        
        // MARK: Public Functions
        
        public static func checkStatus(completion: @escaping (Status) -> Void, forcedInvokationQueue: DispatchQueue? = Constants.defaultCompletionInvokationQueue) {
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
            
            var completion = completion
            
            if let forcedInvokationQueue = forcedInvokationQueue {
                completion = Utils.linkToQueue(forcedInvokationQueue, closure: completion)
            }
            
            completion(combined)
        }
        
        @available(iOS 13, *)
        public static func checkStatus() async -> Status {
            await withCheckedContinuation { checkedContinuation in
                checkStatus { status in
                    checkedContinuation.resume(returning: status)
                }
            }
        }
        
        /**
         Asks a user for access the permission type

         - Parameter whenInUseOnly: A flag indicating whether you want to access location only when an app is being used right now
         - Parameter completion: A closure that will be invoked to return the request result
         - Parameter forcedInvokationQueue: A forced dispatch queue to invoke the completion closure. The default value is `DispatchQueue.main`.
         - Throws: `Permission.Error`, if something went wrong. For example, your “Info.plist” is configured incorrectly.
        */
        public static func requestAccess(whenInUseOnly: Bool, completion: ((Status) -> Void)? = nil, forcedInvokationQueue: DispatchQueue? = Constants.defaultCompletionInvokationQueue) throws {
            let plistKey = whenInUseOnly ? whenInUseOnlyUsageDescriptionPlistKey : alwaysUsageDescriptionPlistKey
            try Utils.checkIsAppConfigured(for: location.self, usageDescriptionPlistKey: plistKey)
            
            var completion = completion
            
            if let forcedInvokationQueue = forcedInvokationQueue, let closure = completion {
                completion = Utils.linkToQueue(forcedInvokationQueue, closure: closure)
            }
            
            if let existingAgent = existingAgent {
                if let completion = completion {
                    existingAgent.addCallback(completion)
                }
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
         Asks a user for access the permission type

         - Parameter whenInUseOnly: A flag indicating whether you want to access location only when an app is being used right now
         - Throws: `Permission.Error`, if something went wrong. For example, your “Info.plist” is configured incorrectly.
        */
        @available(iOS 13, *)
        @available(*, unavailable, message: "There is an unknown system bug that breaks the async version of the method")
        @discardableResult public static func requestAccess(whenInUseOnly: Bool) async throws -> Status {
            try await withCheckedThrowingContinuation { checkedContinuation in
                do {
                    try requestAccess(whenInUseOnly: whenInUseOnly) { status in
                        checkedContinuation.resume(returning: status)
                    }
                } catch {
                    checkedContinuation.resume(throwing: error)
                }
            }
        }
        
        /**
         Asks a user for access temporary precise location data

         It may be useful if a user grants access to location data only with reduced accuracy

         - Parameter purposePlistKey: A key that describes the purpose of your request. You must add a row with this key to your app‘s plist file, to a nested dictionary with the key “NSLocationTemporaryUsageDescriptionDictionary”.
         - Parameter completion: A closure that will be invoked to return the request result
         - Parameter forcedInvokationQueue: A forced dispatch queue to invoke the completion closure. The default value is `DispatchQueue.main`.
         - Throws: `Permission.Error`, if something went wrong. For example, your “Info.plist” is configured incorrectly.
        */
        @available(iOS 14, *)
        public static func requestTemporaryPreciseAccess(purposePlistKey: String, completion: ((Bool) -> Void)? = nil, forcedInvokationQueue: DispatchQueue? = Constants.defaultCompletionInvokationQueue) throws {
            try Utils.checkIsAppConfigured(for: location.self, usageDescriptionPlistKey: nil)
            
            let purposeDictionaryPlistKey = "NSLocationTemporaryUsageDescriptionDictionary"
            
            if let dictionary = Bundle.main.object(forInfoDictionaryKey: purposeDictionaryPlistKey) as? [String: String], dictionary[purposePlistKey]?.isEmpty == false { } else {
                let keyParent = (type: "dictionary", ownKey: purposeDictionaryPlistKey)
                throw Utils.createInvalidAppConfigurationError(permissionName: "temporary precise location", missingPlistKey: purposePlistKey, keyParent: keyParent)
            }
            
            let manager = CLLocationManager()
            
            manager.requestTemporaryFullAccuracyAuthorization(withPurposeKey: purposePlistKey) { _ in
                guard var completion = completion else {
                    return
                }
                
                if let forcedInvokationQueue = forcedInvokationQueue {
                    completion = Utils.linkToQueue(forcedInvokationQueue, closure: completion)
                }
                
                completion(manager.accuracyAuthorization == .fullAccuracy)
            }
        }
        
        /**
         Asks a user for access temporary precise location data

         It may be useful if a user grants access to location data only with reduced accuracy

         - Parameter purposePlistKey: A key that describes the purpose of your request. You must add a row with this key to your app‘s plist file, to a nested dictionary with the key “NSLocationTemporaryUsageDescriptionDictionary”.
         - Throws: `Permission.Error`, if something went wrong. For example, your “Info.plist” is configured incorrectly.
        */
        @available(iOS 14, *)
        @available(*, unavailable, message: "There is an unknown system bug that breaks the async version of the method")
        @discardableResult public static func requestTemporaryPreciseAccess(purposePlistKey: String) async throws -> Bool {
            try await withCheckedThrowingContinuation { checkedContinuation in
                do {
                    try requestTemporaryPreciseAccess(purposePlistKey: purposePlistKey) { status in
                        checkedContinuation.resume(returning: status)
                    }
                } catch {
                    checkedContinuation.resume(throwing: error)
                }
            }
        }
        
    }
    
}

#endif
