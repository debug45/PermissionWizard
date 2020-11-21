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
        
        public enum Status: String {
            
            case granted
            case denied
            
            case notDetermined
            case restrictedBySystem
            
            case unknown
            
        }
        
        public static let usageDescriptionPlistKey = "NSMotionUsageDescription"
        
        // MARK: - Public Functions
        
        public class func checkStatus(completion: @escaping (Status) -> Void) {
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
        
        public class func requestAccess() throws {
            try Utils.checkIsAppConfigured(for: motion.self, usageDescriptionPlistKey: usageDescriptionPlistKey)
            
            let manager = CMMotionActivityManager()
            
            manager.startActivityUpdates(to: OperationQueue.main) { _ in }
            manager.stopActivityUpdates()
        }
        
    }
    
}

#endif
