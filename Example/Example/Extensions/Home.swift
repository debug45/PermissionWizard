//
//  Home.swift
//  Example
//
//  Created by Sergey Moskvin on 17.10.2020.
//

import PermissionKit

extension Permission.home: Unifiable {
    
    static func checkStatus(completion: @escaping (String?) -> Void) {
        print("❌ Check only is not available for a home, use the ”requestAccess“ to check the status")
        completion(nil)
    }
    
    static func requestAccess(completion: @escaping (String?) -> Void) {
        requestAccess { completion($0.rawValue) }
    }
    
}
