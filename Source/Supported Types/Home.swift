//
//  Home.swift
//  PermissionWizard
//
//  Created by Sergey Moskvin on 15.10.2020.
//

#if HOME || !CUSTOM_SETTINGS

import HomeKit

@available(iOS 13, macCatalyst 14, *)
public extension Permission {
    
    final class home: SupportedType, Requestable {
        
        public typealias Status = Permission.Status.Home
        
        private static var existingAgent: Agent?
        
        // MARK: Overriding Properties
        
        public override class var usageDescriptionPlistKey: String { "NSHomeKitUsageDescription" }
        
#if ASSETS || !CUSTOM_SETTINGS
        override class var shouldBorderIcon: Bool { true }
#endif
        
        // MARK: Public Functions
        
        public static func requestAccess(completion: ((Status) -> Void)? = nil, forcedInvokationQueue: DispatchQueue? = Constants.defaultCompletionInvokationQueue) throws {
            try Utils.checkIsAppConfigured(for: home.self, usageDescriptionPlistKey: usageDescriptionPlistKey)
            
            var completion = completion
            
            if let forcedInvokationQueue = forcedInvokationQueue, let closure = completion {
                completion = Utils.linkToQueue(forcedInvokationQueue, closure: closure)
            }
            
            if let existingAgent = existingAgent {
                if let completion = completion {
                    existingAgent.addCallback(completion)
                }
            } else {
                let manager = HMHomeManager()
                
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
