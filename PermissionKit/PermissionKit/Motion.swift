//
//  Motion.swift
//  PermissionKit
//
//  Created by Sergey Moskvin on 17.10.2020.
//

import CoreMotion

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
        
        public class func checkStatus(completion: (Status) -> Void) {
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
        
        public class func requestAccess() {
            guard Utils.checkIsAppConfigured(for: motion.self) else {
                return
            }
            
            let manager = CMMotionActivityManager()
            
            manager.startActivityUpdates(to: OperationQueue.main) { _ in }
            manager.stopActivityUpdates()
        }
        
    }
    
}
