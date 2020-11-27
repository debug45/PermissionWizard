//
//  Motion.swift
//  PermissionWizard
//
//  Created by Sergey Moskvin on 17.10.2020.
//

#if (MOTION || !CUSTOM_SETTINGS) && !targetEnvironment(macCatalyst)

import CoreMotion

@available(iOS 11, *)
public extension Permission {
    
    final class motion: SupportedType, Checkable {
        
        public typealias Status = Permission.Status.Common
        
        // MARK: - Overriding Properties
        
        public override class var usageDescriptionPlistKey: String { "NSMotionUsageDescription" }
        
        // MARK: - Public Functions
        
        public static func checkStatus(completion: @escaping (Status) -> Void) {
            let completion = Utils.linkToPreferredQueue(completion)
            
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
        
        public static func requestAccess() throws {
            try Utils.checkIsAppConfigured(for: motion.self, usageDescriptionPlistKey: usageDescriptionPlistKey)
            
            let manager = CMMotionActivityManager()
            
            manager.startActivityUpdates(to: OperationQueue.main) { _ in }
            manager.stopActivityUpdates()
        }
        
    }
    
}

#endif
