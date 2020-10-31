//
//  Bluetooth.swift
//  Example
//
//  Created by Sergey Moskvin on 31.10.2020.
//

import PermissionKit

extension Permission.bluetooth: Unifiable {
    
    static func checkStatus(completion: @escaping (String?) -> Void) {
        checkStatus { completion($0.rawValue) }
    }
    
    static func requestAccess(completion: @escaping (String?) -> Void) {
        requestAccess { completion($0.rawValue) }
    }
    
}
