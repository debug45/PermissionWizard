//
//  Camera.Statuses.swift
//  PermissionWizard
//
//  Created by Sergey Moskvin on 24.11.2020.
//

#if CAMERA || !CUSTOM_SETTINGS

extension Permission.camera {
    
    public typealias NarrowStatus = Status
    
#if MICROPHONE || !CUSTOM_SETTINGS
    public typealias CombinedStatus = (camera: NarrowStatus, microphone: Permission.microphone.Status?)
#endif
    
}

#endif
