//
//  Location.Statuses.swift
//  PermissionWizard
//
//  Created by Sergey Moskvin on 24.11.2020.
//

#if LOCATION || !CUSTOM_SETTINGS

public extension Permission.Status {
    
    struct Location {
        
        public enum Narrow: String {
            
            case granted
            case denied
            
            case whenInUseOnly
            
            case notDetermined
            case restrictedBySystem
            
            case unknown
            
        }
        
        public typealias Combined = (value: Narrow, isAccuracyReducing: Bool)
        
    }
    
}

#endif
