//
//  Photos.Status.swift
//  PermissionWizard
//
//  Created by Sergey Moskvin on 24.11.2020.
//

#if PHOTOS || !CUSTOM_SETTINGS

public extension Permission.Status {
    
    enum Photos: String {
        
        /// A user grants full access for the terms you requested
        case granted
        /// A user denies access
        case denied
        
        /// A user has not been asked about access yet
        case notDetermined
        
        /// A user grants access to only certain photos and videos
        case limitedByUser
        /// Access is restricted by the system. For example, due to parental control configuration.
        case restrictedBySystem
        
        /// Unsupported by PermissionWizard, please report it
        case unknown
        
    }
    
}

#endif
