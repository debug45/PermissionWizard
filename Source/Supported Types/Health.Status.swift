//
//  Health.Status.swift
//  PermissionWizard
//
//  Created by Sergey Moskvin on 24.11.2020.
//

#if HEALTH || !CUSTOM_SETTINGS
#if !targetEnvironment(macCatalyst)

extension Permission.Status {
    
    public enum HealthWriting: String {
        
        case granted
        case denied
        
        case notDetermined
        case unknown
        
    }
    
}

#endif
#endif
