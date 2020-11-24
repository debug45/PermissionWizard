//
//  Photos.Status.swift
//  PermissionWizard
//
//  Created by Sergey Moskvin on 24.11.2020.
//

#if PHOTOS || !CUSTOM_SETTINGS

extension Permission.photos {
    
    public enum Status: String {
        
        case granted
        case denied
        
        case notDetermined
        
        case limitedByUser
        case restrictedBySystem
        
        case unknown
        
    }
    
}

#endif
