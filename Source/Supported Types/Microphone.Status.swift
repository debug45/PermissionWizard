//
//  Microphone.Status.swift
//  PermissionWizard
//
//  Created by Sergey Moskvin on 24.11.2020.
//

#if MICROPHONE || !CUSTOM_SETTINGS

public extension Permission.Status {
    
    enum Microphone: String {
        
        case granted
        case denied
        
        case notDetermined
        case unknown
        
    }
    
}

#endif
