//
//  Camera.swift
//  Example
//
//  Created by Sergey Moskvin on 17.10.2020.
//

import PermissionKit

extension Permission.camera: Unifiable {
    
    private static let withMicrophone = false
    
    // MARK: - Unifiable
    
    static func checkStatus(completion: @escaping (String?) -> Void) {
        checkStatus(withMicrophone: withMicrophone) { completion($0.camera.rawValue) }
    }
    
    static func requestAccess(completion: @escaping (String?) -> Void) {
        requestAccess(withMicrophone: withMicrophone) { completion($0.camera.rawValue) }
    }
    
}
