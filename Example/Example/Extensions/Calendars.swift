//
//  Calendars.swift
//  Example
//
//  Created by Sergey Moskvin on 14.10.2020.
//

import PermissionKit

extension Permission.calendars: Unifiable {
    
    static func checkStatus(completion: (String) -> Void) {
        checkStatus { status in
            completion(status.rawValue)
        }
    }
    
    static func requestAccess(completion: @escaping (String) -> Void) {
        requestAccess { status in
            completion(status.rawValue)
        }
    }
    
}
