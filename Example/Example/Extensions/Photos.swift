//
//  Photos.swift
//  Example
//
//  Created by Sergey Moskvin on 17.10.2020.
//

import PermissionKit

extension Permission.photos: Unifiable {
    
    static func checkStatus(completion: @escaping (String?) -> Void) {
        checkStatus(forAddingOnly: false) { completion($0.rawValue) }
    }
    
    static func requestAccess(completion: @escaping (String?) -> Void) {
        requestAccess(forAddingOnly: false) { completion($0.rawValue) }
    }
    
}
