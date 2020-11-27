//
//  Health.Status.swift
//  PermissionWizard
//
//  Created by Sergey Moskvin on 24.11.2020.
//

#if (HEALTH || !CUSTOM_SETTINGS) && !targetEnvironment(macCatalyst)

public extension Permission.Status {
    
    enum HealthWriting: String {
        
        case granted
        case denied
        
        case notDetermined
        case unknown
        
    }
    
}

#endif
