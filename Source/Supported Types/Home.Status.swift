//
//  Home.Status.swift
//  PermissionWizard
//
//  Created by Sergey Moskvin on 24.11.2020.
//

#if HOME || !CUSTOM_SETTINGS

@available(iOS 13, macCatalyst 14, *)
public extension Permission.Status {
    
    enum Home: String {
        
        case granted
        case denied
        
        case restrictedBySystem
        
    }
    
}

#endif
