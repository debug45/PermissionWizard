//
//  Home.Status.swift
//  PermissionWizard
//
//  Created by Sergei Moskvin on 24.11.2020.
//

#if HOME || !CUSTOM_SETTINGS

@available(iOS 13, macCatalyst 14, *)
public extension Permission.Status {
    
    enum Home: String {
        
        /// A user grants access
        case granted
        /// A user denies access
        case denied
        
        /// Access is restricted by the system. For example, due to parental control configuration.
        case restrictedBySystem
        
    }
    
}

#endif
