//
//  Bluetooth.swift
//  PermissionWizard
//
//  Created by Sergei Moskvin on 25.10.2020.
//

#if BLUETOOTH || !CUSTOM_SETTINGS

import CoreBluetooth

public extension Permission {
    
    final class bluetooth: SupportedType, Checkable, Requestable {
        
        public typealias Status = Permission.Status.Common
        
        private static var existingAgent: Agent?
        
        // MARK: Overriding Properties
        
        public override class var usageDescriptionPlistKey: String { "NSBluetoothAlwaysUsageDescription" }
        
        override class var contextName: String { "Bluetooth" }
        
        // MARK: Public Functions
        
        public static func checkStatus(completion: @escaping (Status) -> Void, forcedInvokationQueue: DispatchQueue? = Constants.defaultCompletionInvokationQueue) {
            var completion = completion
            
            if let forcedInvokationQueue = forcedInvokationQueue {
                completion = Utils.linkToQueue(forcedInvokationQueue, closure: completion)
            }
            
            switch CBCentralManager.authorization {
                case .allowedAlways:
                    completion(.granted)
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
        
        public static func checkStatus() async -> Status {
            await withCheckedContinuation { checkedContinuation in
                checkStatus { status in
                    checkedContinuation.resume(returning: status)
                }
            }
        }
        
        public static func requestAccess(completion: ((Status) -> Void)? = nil, forcedInvokationQueue: DispatchQueue? = Constants.defaultCompletionInvokationQueue) throws {
            try Utils.checkIsAppConfigured(for: bluetooth.self, usageDescriptionPlistKey: usageDescriptionPlistKey)
            
            var completion = completion
            
            if let forcedInvokationQueue = forcedInvokationQueue, let closure = completion {
                completion = Utils.linkToQueue(forcedInvokationQueue, closure: closure)
            }
            
            if let existingAgent = existingAgent {
                if let completion = completion {
                    existingAgent.addCallback(completion)
                }
            } else {
                let manager = CBCentralManager()
                
                existingAgent = Agent(manager) { status in
                    completion?(status)
                    self.existingAgent = nil
                }
            }
        }
        
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
        
    }
    
}

#endif
