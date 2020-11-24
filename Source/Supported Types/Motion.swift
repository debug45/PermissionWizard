//
//  Motion.swift
//  PermissionWizard
//
//  Created by Sergey Moskvin on 17.10.2020.
//

#if MOTION || !CUSTOM_SETTINGS

import CoreMotion

@available(iOS 11, *)
public extension Permission {
    
    final class motion: Base {
        
        // MARK: - Overriding Properties
        
        public override class var usageDescriptionPlistKey: String { "NSMotionUsageDescription" }
        
        // MARK: - Overriding Functions
        
        public override class func checkStatus(completion: @escaping (Status) -> Void) {
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
        
        @available(*, unavailable)
        public override class func requestAccess(completion: ((Status) -> Void)? = nil) throws { }
        
        // MARK: - Public Functions
        
        public class func requestAccess() throws {
            try Utils.checkIsAppConfigured(for: motion.self, usageDescriptionPlistKey: usageDescriptionPlistKey)
            
            let manager = CMMotionActivityManager()
            
            manager.startActivityUpdates(to: OperationQueue.main) { _ in }
            manager.stopActivityUpdates()
        }
        
    }
    
}

#endif
