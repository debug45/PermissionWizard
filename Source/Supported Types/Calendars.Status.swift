//
//  Calendars.Status.swift
//  PermissionWizard
//
//  Created by Sergei Moskvin on 31.10.2023.
//

#if CALENDARS || !CUSTOM_SETTINGS

public extension Permission.Status {
    
    enum Calendars: String {
        
        /// A user grants full access
        case fullAccess
        /// A user grants access only to add new events
        case addingOnly
        
        /// A user denies access
        case denied
        
        /// A user has not been asked for access yet
        case notDetermined
        /// Access is restricted by the system. For example, due to parental control configuration.
        case restrictedBySystem
        
        /// Unsupported by PermissionWizard, please report it
        case unknown
        
    }
    
}

#endif
