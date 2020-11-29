//
//  FaceID.Status.swift
//  PermissionWizard
//
//  Created by Sergey Moskvin on 24.11.2020.
//

#if (FACE_ID || !CUSTOM_SETTINGS) && !targetEnvironment(macCatalyst)

@available(iOS 11, *)
public extension Permission.Status {
    
    enum FaceID: String {
        
        /// A user grants access or has not been asked for it yet
        case grantedOrNotDetermined
        /// A user denies access
        case denied
        
        /// A device does not support Face ID
        case notSupportedByDevice
        /// Face ID is not configured by a user
        case notEnrolled
        
        /// Unsupported by PermissionWizard, please report it
        case unknown
        
    }
    
}

#endif
