//
//  LocalNetwork.Status.swift
//  PermissionWizard
//
//  Created by Sergei Moskvin on 24.01.2021.
//

#if (LOCAL_NETWORK || !CUSTOM_SETTINGS) && !targetEnvironment(macCatalyst)

public extension Permission.Status {
    
    enum LocalNetwork: String {
        
        /// A user grants access
        case granted
        /// A user denies access or has not been asked for it yet
        case deniedOrNotDetermined
        
    }
    
}

#endif
