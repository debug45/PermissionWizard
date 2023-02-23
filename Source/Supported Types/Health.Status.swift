//
//  Health.Status.swift
//  PermissionWizard
//
//  Created by Sergei Moskvin on 24.11.2020.
//

#if (HEALTH || !CUSTOM_SETTINGS) && !targetEnvironment(macCatalyst)

public extension Permission.Status {
    
    enum HealthWriting: String {
        
        /// A user grants access
        case granted
        /// A user denies access
        case denied
        
        /// A user has not been asked for access yet
        case notDetermined
        /// Unsupported by PermissionWizard, please report it
        case unknown
        
    }
    
}

#endif
