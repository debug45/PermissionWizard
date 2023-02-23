//
//  Location.Statuses.swift
//  PermissionWizard
//
//  Created by Sergei Moskvin on 24.11.2020.
//

#if LOCATION || !CUSTOM_SETTINGS

public extension Permission.Status {
    
    struct Location {
        
        public enum Narrow: String {
            
            /// A user grants access that can be used even when an app is not being used right now
            case granted
            /// A user denies access
            case denied
            
            /// A user grants access that can be used only when an app is being used right now
            case whenInUseOnly
            
            /// A user has not been asked for access yet
            case notDetermined
            /// Access is restricted by the system. For example, due to parental control configuration.
            case restrictedBySystem
            
            /// Unsupported by PermissionWizard, please report it
            case unknown
            
        }
        
        public typealias Combined = (value: Narrow, isAccuracyReducing: Bool)
        
    }
    
}

#endif
