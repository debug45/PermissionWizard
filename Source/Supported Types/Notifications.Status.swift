//
//  Notifications.Status.swift
//  PermissionWizard
//
//  Created by Sergey Moskvin on 24.11.2020.
//

#if NOTIFICATIONS || !CUSTOM_SETTINGS

extension Permission.Status {
    
    public enum Notifications: String {
        
        case granted
        case denied
        
        case notDetermined
        
        case provisionalOnly
        case ephemeralOnly
        
        case unknown
        
    }
    
}

#endif
