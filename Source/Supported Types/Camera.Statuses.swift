//
//  Camera.Statuses.swift
//  PermissionWizard
//
//  Created by Sergey Moskvin on 24.11.2020.
//

#if CAMERA || !CUSTOM_SETTINGS

extension Permission.Status {
    
#if MICROPHONE || !CUSTOM_SETTINGS
    public typealias CameraNarrow = Common
    public typealias CameraCombined = (camera: CameraNarrow, microphone: Permission.microphone.Status?)
#else
    public typealias Camera = Common
#endif
    
}

#endif
