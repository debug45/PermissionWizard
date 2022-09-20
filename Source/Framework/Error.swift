//
//  Error.swift
//  PermissionWizard
//
//  Created by Sergey Moskvin on 20.11.2020.
//

public extension Permission {
    
    class Error: NSError {
        
        /// A flag that represents a reason of the occured error
        public let type: SupportedType
        
        private let userInfoMessageKey = "message"
        
        // MARK: Life Cycle
        
        init(_ type: SupportedType, message: String? = nil) {
            self.type = type
            
            let domain = Bundle(for: Error.self).bundleIdentifier!
            var userInfo: [String: Any] = [:]
            
            if let message = message {
                userInfo[userInfoMessageKey] = message
            }
            
            super.init(domain: domain, code: type.code, userInfo: userInfo)
        }
        
        required init?(coder: NSCoder) {
            return nil
        }
        
    }
    
}
