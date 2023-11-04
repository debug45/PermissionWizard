//
//  Calendars.swift
//  PermissionWizard
//
//  Created by Sergei Moskvin on 14.10.2020.
//

#if CALENDARS || !CUSTOM_SETTINGS

import EventKit

public extension Permission {
    
    final class calendars: SupportedType, Checkable, Requestable {
        
        public typealias Status = Permission.Status.Calendars
        
        // MARK: Overriding Properties
        
        @available(*, unavailable)
        public override class var usageDescriptionPlistKey: String { .init() }
        
#if ASSETS || !CUSTOM_SETTINGS
        override class var shouldBorderIcon: Bool { true }
#endif
        
        // MARK: Public Properties
        
        /**
         Keys that must be added to your “Info.plist” to work with the permission type. These keys are used if you want to have full access to a user’s calendars.

         For each permission type you are using, Apple requires to add the corresponding string to your “Info.plist” that describes a purpose of your access requests
        */
        public static let fullAccessUsageDescriptionPlistKeys = [
            "NSCalendarsFullAccessUsageDescription", // Required for iOS 17 and newer
            "NSCalendarsUsageDescription" // Only for iOS 16 and older
        ]
        /**
         A key that must be added to your “Info.plist” to work with the permission type. This key is used if you want only to add new events to a user’s calendars.

         For each permission type you are using, Apple requires to add the corresponding string to your “Info.plist” that describes a purpose of your access requests
        */
        public static let addingOnlyUsageDescriptionPlistKey = "NSCalendarsWriteOnlyAccessUsageDescription"
        
        // MARK: Public Functions
        
        /**
         Asks the system for the current status of the permission type

         - Parameter forAddingOnly: A flag indicating whether you want to check the ability only to add new events to a user’s calendars
         - Parameter completion: A closure that will be invoked to return the check result
         - Parameter forcedInvokationQueue: A forced dispatch queue to invoke the completion closure. The default value is `DispatchQueue.main`.
        */
        @available(iOS 17, *)
        public static func checkStatus(forAddingOnly: Bool, completion: @escaping (Status) -> Void, forcedInvokationQueue: DispatchQueue? = Constants.defaultCompletionInvokationQueue) {
            _checkStatus(forAddingOnly: forAddingOnly, completion: completion, forcedInvokationQueue: forcedInvokationQueue)
        }
        
        /**
         Asks the system for the current status of the permission type

         - Parameter forAddingOnly: A flag indicating whether you want to check the ability only to add new events to a user’s calendars
        */
        @available(iOS 17, *)
        public static func checkStatus(forAddingOnly: Bool) async -> Status {
            await withCheckedContinuation { checkedContinuation in
                checkStatus(forAddingOnly: forAddingOnly) { status in
                    checkedContinuation.resume(returning: status)
                }
            }
        }
        
        @available(iOS, deprecated: 17)
        public static func checkStatus(completion: @escaping (Status) -> Void, forcedInvokationQueue: DispatchQueue? = Constants.defaultCompletionInvokationQueue) {
            _checkStatus(forAddingOnly: false, completion: completion, forcedInvokationQueue: forcedInvokationQueue)
        }
        
        @available(iOS, deprecated: 17)
        public static func checkStatus() async -> Status {
            await withCheckedContinuation { checkedContinuation in
                checkStatus { status in
                    checkedContinuation.resume(returning: status)
                }
            }
        }
        
        /**
         Asks a user for access the permission type

         - Parameter forAddingOnly: A flag indicating whether you want only to add new events to a user’s calendars
         - Parameter completion: A closure that will be invoked to return the request result
         - Parameter forcedInvokationQueue: A forced dispatch queue to invoke the completion closure. The default value is `DispatchQueue.main`.
         - Throws: `Permission.Error`, if something went wrong. For example, your “Info.plist” is configured incorrectly.
        */
        @available(iOS 17, *)
        public static func requestAccess(forAddingOnly: Bool, completion: ((Status) -> Void)? = nil, forcedInvokationQueue: DispatchQueue? = Constants.defaultCompletionInvokationQueue) throws {
            try _requestAccess(forAddingOnly: forAddingOnly, completion: completion, forcedInvokationQueue: forcedInvokationQueue)
        }
        
        /**
         Asks a user for access the permission type

         - Parameter forAddingOnly: A flag indicating whether you want only to add new events to a user’s calendars
         - Throws: `Permission.Error`, if something went wrong. For example, your “Info.plist” is configured incorrectly.
        */
        @available(iOS 17, *)
        @discardableResult public static func requestAccess(forAddingOnly: Bool) async throws -> Status {
            try await withCheckedThrowingContinuation { checkedContinuation in
                do {
                    try requestAccess(forAddingOnly: forAddingOnly) { status in
                        checkedContinuation.resume(returning: status)
                    }
                } catch {
                    checkedContinuation.resume(throwing: error)
                }
            }
        }
        
        @available(iOS, deprecated: 17)
        public static func requestAccess(completion: ((Status) -> Void)? = nil, forcedInvokationQueue: DispatchQueue? = Constants.defaultCompletionInvokationQueue) throws {
            try _requestAccess(forAddingOnly: false, completion: completion, forcedInvokationQueue: forcedInvokationQueue)
        }
        
        @available(iOS, deprecated: 17)
        @discardableResult public static func requestAccess() async throws -> Status {
            try await withCheckedThrowingContinuation { checkedContinuation in
                do {
                    try requestAccess { status in
                        checkedContinuation.resume(returning: status)
                    }
                } catch {
                    checkedContinuation.resume(throwing: error)
                }
            }
        }
        
        // MARK: Private Functions
        
        private static func _checkStatus(forAddingOnly: Bool, completion: @escaping (Status) -> Void, forcedInvokationQueue: DispatchQueue? = Constants.defaultCompletionInvokationQueue) {
            var completion = completion
            
            if let forcedInvokationQueue = forcedInvokationQueue {
                completion = Utils.linkToQueue(forcedInvokationQueue, closure: completion)
            }
            
            switch EKEventStore.authorizationStatus(for: .event) {
                case .authorized, .fullAccess:
                    completion(.fullAccess)
                case .writeOnly:
                    completion(.addingOnly)
                case .denied:
                    completion(.denied)
                case .notDetermined:
                    completion(.notDetermined)
                case .restricted:
                    completion(.restrictedBySystem)
                
                @unknown default:
                    completion(.unknown)
            }
        }
        
        private static func _requestAccess(forAddingOnly: Bool, completion: ((Status) -> Void)? = nil, forcedInvokationQueue: DispatchQueue? = Constants.defaultCompletionInvokationQueue) throws {
            let usageDescriptionsPlistKeys = forAddingOnly ? [addingOnlyUsageDescriptionPlistKey] : fullAccessUsageDescriptionPlistKeys
            try Utils.checkIsAppConfigured(for: calendars.self, usageDescriptionsPlistKeys: usageDescriptionsPlistKeys)
            
            let completionHandler: EKEventStoreRequestAccessCompletionHandler = { _, _ in
                guard let completion = completion else {
                    return
                }
                
                self._checkStatus(forAddingOnly: forAddingOnly, completion: {
                    completion($0)
                }, forcedInvokationQueue: forcedInvokationQueue)
            }
            
            let eventStore = EKEventStore()
            
            if #available(iOS 17, *) {
                if forAddingOnly {
                    eventStore.requestWriteOnlyAccessToEvents(completion: completionHandler)
                } else {
                    eventStore.requestFullAccessToEvents(completion: completionHandler)
                }
            } else {
                eventStore.requestAccess(to: .event, completion: completionHandler)
            }
        }
        
    }
    
}

#endif
