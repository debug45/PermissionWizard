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
        let handler: (Permission.photos.Status) -> Void = { completion($0.rawValue) }
        
        if #available(iOS 14, *) {
            checkStatus(forAddingOnly: forAddingOnly, completion: handler)
        } else {
            checkStatus(completion: handler)
        }
    }
    
    static func requestAccess(completion: @escaping (String?) -> Void) {
        let handler: (Permission.photos.Status) -> Void = { completion($0.rawValue) }
        
        if #available(iOS 14, *) {
            requestAccess(forAddingOnly: forAddingOnly, completion: handler)
        } else {
            requestAccess(completion: handler)
        }
    }
    
}
