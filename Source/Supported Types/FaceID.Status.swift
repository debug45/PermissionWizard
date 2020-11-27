//
//  FaceID.Status.swift
//  PermissionWizard
//
//  Created by Sergey Moskvin on 24.11.2020.
//

#if (FACE_ID || !CUSTOM_SETTINGS) && !targetEnvironment(macCatalyst)

@available(iOS 11, *)
extension Permission.Status {
    
    public enum FaceID: String {
        
        case grantedOrNotDetermined
        case denied
        
        case notSupportedByDevice
        case notEnrolled
        
        case unknown
        
    }
    
}

#endif
