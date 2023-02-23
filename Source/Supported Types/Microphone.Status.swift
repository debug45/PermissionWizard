//
//  Microphone.Status.swift
//  PermissionWizard
//
//  Created by Sergei Moskvin on 24.11.2020.
//

#if MICROPHONE || !CUSTOM_SETTINGS

public extension Permission.Status {
    
    enum Microphone: String {
        
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
