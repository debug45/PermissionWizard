//
//  Notifications.Status.swift
//  PermissionWizard
//
//  Created by Sergey Moskvin on 24.11.2020.
//

#if NOTIFICATIONS || !CUSTOM_SETTINGS

public extension Permission.Status {
    
    enum Notifications: String {
        
        /// A user grants full access
        case granted
        /// A user denies access
        case denied
        
        /// A user has not been asked for access yet
        case notDetermined
        
        /// A user grants provisional access. Notifications are received without sound, badge, etc.
        case provisionalOnly
        /// A user grants full access for a limited amount of time. It is used for App Clips.
        case ephemeralOnly
        
        /// Unsupported by PermissionWizard, please report it
        case unknown
        
    }
    
}

#endif
