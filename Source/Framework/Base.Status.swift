//
//  Base.Status.swift
//  PermissionWizard
//
//  Created by Sergey Moskvin on 22.11.2020.
//

public extension Permission.Base {
    
    enum Status: String {
        
        /// A user grants access
        case granted
        /// A user denies access
        case denied
        
        /// A user has not been asked about access yet
        case notDetermined
        /// Access is restricted by the system. For example, due to Screen Time preferences.
        case restrictedBySystem
        
        /// Unsupported by PermissionWizard, please report it
        case unknown
        
    }
    
}
