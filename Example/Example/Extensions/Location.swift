//
//  Location.swift
//  Example
//
//  Created by Sergey Moskvin on 24.10.2020.
//

import PermissionKit

extension Permission.location: Unifiable {
    
    static func checkStatus(completion: @escaping (String?) -> Void) {
        checkStatus { completion($0.value.rawValue) }
    }
    
    static func requestAccess(completion: @escaping (String?) -> Void) {
        requestAccess(whenInUseOnly: false) { completion($0.value.rawValue) }
    }
    
}
