//
//  Microphone.Status.swift
//  PermissionWizard
//
//  Created by Sergey Moskvin on 24.11.2020.
//

#if MICROPHONE || !CUSTOM_SETTINGS

extension Permission.Status {
    
    public enum Microphone: String {
        
        case granted
        case denied
        
        case notDetermined
        case unknown
        
    }
    
}

#endif
