//
//  Photos.Status.swift
//  PermissionWizard
//
//  Created by Sergey Moskvin on 24.11.2020.
//

#if PHOTOS || !CUSTOM_SETTINGS

extension Permission.Status {
    
    public enum Photos: String {
        
        case granted
        case denied
        
        case notDetermined
        
        case limitedByUser
        case restrictedBySystem
        
        case unknown
        
    }
    
}

#endif