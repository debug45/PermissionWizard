//
//  Home.Status.swift
//  PermissionWizard
//
//  Created by Sergey Moskvin on 24.11.2020.
//

#if HOME || !CUSTOM_SETTINGS

@available(iOS 13, macCatalyst 14, *)
extension Permission.home {
    
    public enum Status: String {
        
        case granted
        case denied
        
        case restrictedBySystem
        
    }
    
}

#endif
