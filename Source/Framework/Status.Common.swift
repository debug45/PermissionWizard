//
//  Status.Common.swift
//  PermissionWizard
//
//  Created by Sergei Moskvin on 22.11.2020.
//

public extension Permission.Status {
    
    enum Common: String {
        
        /// A user grants access
        case granted
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
