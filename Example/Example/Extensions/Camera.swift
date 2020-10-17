//
//  Camera.swift
//  Example
//
//  Created by Sergey Moskvin on 17.10.2020.
//

import PermissionKit

extension Permission.camera: Unifiable {
    
    static func checkStatus(completion: (String?) -> Void) {
        checkStatus(withMicrophone: false) { completion($0.camera.rawValue) }
    }
    
    static func requestAccess(completion: @escaping (String?) -> Void) {
        requestAccess(withMicrophone: false) { completion($0.camera.rawValue) }
    }
    
}
