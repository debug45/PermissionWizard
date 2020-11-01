//
//  LocalNetwork.swift
//  Example
//
//  Created by Sergey Moskvin on 31.10.2020.
//

import PermissionKit

@available(iOS 14, *)
extension Permission.localNetwork: Unifiable {
    
    static func checkStatus(completion: @escaping (String?) -> Void) {
        print("❌ Check only is not available for a local network")
        completion(nil)
    }
    
    static func requestAccess(completion: @escaping (String?) -> Void) {
        requestAccess(servicePlistKey: "_example._tcp")
        
        print("⚠️ The ”requestAccess“ does not return a result for a local network")
        completion(nil)
    }
    
}
