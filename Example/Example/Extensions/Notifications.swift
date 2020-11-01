//
//  Notifications.swift
//  Example
//
//  Created by Sergey Moskvin on 18.10.2020.
//

import PermissionKit

@available(iOS 10, *)
extension Permission.notifications: Unifiable {
    
    static func checkStatus(completion: @escaping (String?) -> Void) {
        checkStatus { completion($0.rawValue) }
    }
    
    static func requestAccess(completion: @escaping (String?) -> Void) {
        requestAccess(options: [.alert, .badge, .sound]) { completion($0.rawValue) }
    }
    
}
