//
//  FaceID.swift
//  Example
//
//  Created by Sergey Moskvin on 01.11.2020.
//

import PermissionKit

extension Permission.faceID: Unifiable {
    
    static func checkStatus(completion: @escaping (String?) -> Void) {
        checkStatus { completion($0.rawValue) }
    }
    
    static func requestAccess(completion: @escaping (String?) -> Void) {
        requestAccess { completion($0.rawValue) }
    }
    
}
