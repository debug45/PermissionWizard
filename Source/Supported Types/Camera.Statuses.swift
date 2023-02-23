//
//  Camera.Statuses.swift
//  PermissionWizard
//
//  Created by Sergei Moskvin on 24.11.2020.
//

#if CAMERA || !CUSTOM_SETTINGS

public extension Permission.Status {
    
#if MICROPHONE || !CUSTOM_SETTINGS
    struct Camera {
        
        public typealias Narrow = Common
        public typealias Combined = (camera: Narrow, microphone: Permission.microphone.Status?)
        
    }
#else
    typealias Camera = Common
#endif
    
}

#endif
