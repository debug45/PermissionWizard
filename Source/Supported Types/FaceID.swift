//
//  FaceID.swift
//  PermissionWizard
//
//  Created by Sergei Moskvin on 31.10.2020.
//

#if (FACE_ID || !CUSTOM_SETTINGS) && !targetEnvironment(macCatalyst)

import LocalAuthentication

public extension Permission {
    
    final class faceID: SupportedType, Checkable, Requestable {
        
        public typealias Status = Permission.Status.FaceID
        
        // MARK: Overriding Properties
        
        public override class var usageDescriptionPlistKey: String { "NSFaceIDUsageDescription" }
        
        override class var contextName: String { "Face ID" }
        
        // MARK: Public Functions
        
        public static func checkStatus(completion: @escaping (Status) -> Void, forcedInvokationQueue: DispatchQueue? = Constants.defaultCompletionInvokationQueue) {
            let context = LAContext()
            
            var error: NSError?
            let isReady = context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error)
            
            var completion = completion
            
            if let forcedInvokationQueue = forcedInvokationQueue {
                completion = Utils.linkToQueue(forcedInvokationQueue, closure: completion)
            }
            
            guard context.biometryType == .faceID else {
                completion(.notSupportedByDevice)
                return
            }
            
            switch error?.code {
                case nil where isReady:
                    completion(.grantedOrNotDetermined)
                case LAError.biometryNotAvailable.rawValue:
                    completion(.denied)
                case LAError.biometryNotEnrolled.rawValue:
                    completion(.notEnrolled)
                
                default:
                    completion(.unknown)
            }
        }
        
        @available(iOS 13, *)
        public static func checkStatus() async -> Status {
            await withCheckedContinuation { checkedContinuation in
                checkStatus { status in
                    checkedContinuation.resume(returning: status)
                }
            }
        }
        
        public static func requestAccess(completion: ((Status) -> Void)? = nil, forcedInvokationQueue: DispatchQueue? = Constants.defaultCompletionInvokationQueue) throws {
            try Utils.checkIsAppConfigured(for: faceID.self, usageDescriptionPlistKey: usageDescriptionPlistKey)
            
            LAContext().evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: " ") { _, _ in
                guard let completion = completion else {
                    return
                }
                
                self.checkStatus(completion: {
                    completion($0)
                }, forcedInvokationQueue: forcedInvokationQueue)
            }
        }
        
        @available(iOS 13, *)
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
