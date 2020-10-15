//
//  Contacts.swift
//  Example
//
//  Created by Sergey Moskvin on 10.10.2020.
//

import PermissionKit

extension Permission.contacts: Unifiable {
    
    static func checkStatus(completion: (String) -> Void) {
        checkStatus { completion($0.rawValue) }
    }
    
    static func requestAccess(completion: @escaping (String) -> Void) {
        requestAccess { completion($0.rawValue) }
    }
    
}
