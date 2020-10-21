//
//  Photos.swift
//  Example
//
//  Created by Sergey Moskvin on 17.10.2020.
//

import PermissionKit

extension Permission.photos: Unifiable {
    
    private static let forAddingOnly = false
    
    // MARK: - Unifiable
    
    static func checkStatus(completion: @escaping (String?) -> Void) {
        checkStatus(forAddingOnly: forAddingOnly) { completion($0.rawValue) }
    }
    
    static func requestAccess(completion: @escaping (String?) -> Void) {
        requestAccess(forAddingOnly: forAddingOnly) { completion($0.rawValue) }
    }
    
}
