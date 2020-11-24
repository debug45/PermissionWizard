//
//  Error.SupportedType.swift
//  PermissionWizard
//
//  Created by Sergey Moskvin on 20.11.2020.
//

extension Permission.Error {
    
    public enum SupportedType {
        
        /// Unknown error inside PermissionWizard, please report it
        case libraryFailure
        /// Your ”Info.plist“ is configured incorrectly
        case missingPlistKey(details: String)
        
        // MARK: - Properties
        
        /// A value that represents PermissionWizard internal code of the error
        public var code: Int {
            switch self {
                case .libraryFailure:
                    return 0
                
                case .missingPlistKey(_):
                    return 1
            }
        }
        
    }
    
}
