//
//  Music.swift
//  Example
//
//  Created by Sergey Moskvin on 17.10.2020.
//

import PermissionKit

@available(iOS 9.3, *)
extension Permission.music: Unifiable {
    
    static func checkStatus(completion: @escaping (String?) -> Void) {
        checkStatus { completion($0.rawValue) }
    }
    
    static func requestAccess(completion: @escaping (String?) -> Void) {
        requestAccess { completion($0.rawValue) }
    }
    
}
