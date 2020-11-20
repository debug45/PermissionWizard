//
//  PWError.swift
//  PermissionWizard
//
//  Created by Sergey Moskvin on 20.11.2020.
//

public class PWError: NSError {
    
    public let type: SupportedType
    
    // MARK: - Life Cycle
    
    init(_ type: SupportedType, message: String? = nil) {
        self.type = type
        
        let domain = Bundle(for: PWError.self).bundleIdentifier!
        var userInfo: [String: Any] = [:]
        
        if let message = message {
            userInfo["message"] = message
        }
        
        super.init(domain: domain, code: type.rawValue, userInfo: userInfo)
    }
    
    public required init?(coder: NSCoder) {
        return nil
    }
    
}
