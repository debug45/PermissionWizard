//
//  Motion.swift
//  PermissionWizard
//
//  Created by Sergei Moskvin on 17.10.2020.
//

#if (MOTION || !CUSTOM_SETTINGS) && !targetEnvironment(macCatalyst)

import CoreMotion

public extension Permission {
    
    final class motion: SupportedType, Checkable {
        
        public typealias Status = Permission.Status.Common
        
        // MARK: Overriding Properties
        
        public override class var usageDescriptionPlistKey: String { "NSMotionUsageDescription" }
        
        // MARK: Public Functions
        
        public static func checkStatus(completion: @escaping (Status) -> Void, forcedInvokationQueue: DispatchQueue? = Constants.defaultCompletionInvokationQueue) {
            var completion = completion
            
            if let forcedInvokationQueue = forcedInvokationQueue {
                completion = Utils.linkToQueue(forcedInvokationQueue, closure: completion)
            }
            
            switch CMSensorRecorder.authorizationStatus() {
                case .authorized:
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

         To find out a user’s decision, use the status check method

         - Throws: `Permission.Error`, if something went wrong. For example, your “Info.plist” is configured incorrectly.
        */
        public static func requestAccess() throws {
            try Utils.checkIsAppConfigured(for: motion.self, usageDescriptionPlistKey: usageDescriptionPlistKey)
            
            let manager = CMMotionActivityManager()
            
            manager.startActivityUpdates(to: OperationQueue.main) { _ in }
            manager.stopActivityUpdates()
        }
        
    }
    
}

#endif
