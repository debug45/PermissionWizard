//
//  Location.Statuses.swift
//  PermissionWizard
//
//  Created by Sergey Moskvin on 24.11.2020.
//

#if LOCATION || !CUSTOM_SETTINGS

extension Permission.Status {
    
    public enum LocationNarrow: String {
        
        case granted
        case denied
        
        case whenInUseOnly
        
        case notDetermined
        case restrictedBySystem
        
        case unknown
        
    }
    
    public typealias LocationCombined = (value: LocationNarrow, isAccuracyReducing: Bool)
    
}

#endif
