//
//  Health.swift
//  Example
//
//  Created by Sergey Moskvin on 20.10.2020.
//

import HealthKit
import PermissionKit

extension Permission.health: Unifiable {
    
    private static let dataType = HKObjectType.workoutType()
    
    // MARK: - Unifiable
    
    static func checkStatus(completion: @escaping (String?) -> Void) {
        checkStatusForWriting(of: dataType) {
            print("⚠️ The ”checkStatus“ returns a result for health writing only")
            completion($0.rawValue)
        }
    }
    
    static func requestAccess(completion: @escaping (String?) -> Void) {
        requestAccess(forReading: [dataType], writing: [dataType]) {
            print("⚠️ The ”requestAccess“ does not return a result for health, use the ”checkStatus“ if necessary")
            completion(nil)
        }
    }
    
}
