//
//  Motion.swift
//  Example
//
//  Created by Sergey Moskvin on 17.10.2020.
//

import PermissionKit

@available(iOS 11, *)
extension Permission.motion: Unifiable {
    
    static func checkStatus(completion: @escaping (String?) -> Void) {
        checkStatus { completion($0.rawValue) }
    }
    
    static func requestAccess(completion: @escaping (String?) -> Void) {
        requestAccess()
        
        print("⚠️ The ”requestAccess“ does not return a result for motion, use the ”checkStatus“ if necessary")
        completion(nil)
    }
    
}
