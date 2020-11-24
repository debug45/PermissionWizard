//
//  Microphone.Status.swift
//  PermissionWizard
//
//  Created by Sergey Moskvin on 24.11.2020.
//

#if MICROPHONE || !CUSTOM_SETTINGS

extension Permission.microphone {
    
    public enum Status: String {
        
        case granted
        case denied
        
        case notDetermined
        case unknown
        
    }
    
}

#endif
