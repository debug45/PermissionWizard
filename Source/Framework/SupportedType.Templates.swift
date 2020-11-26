//
//  SupportedType.Templates.swift
//  PermissionWizard
//
//  Created by Sergey Moskvin on 26.11.2020.
//

protocol Checkable: Permission.SupportedType {
    
    associatedtype Status
    
    // MARK: - Public Functions
    
    /**
     Asks the system for the current status of the permission type

     - Parameter completion: A block that will be invoked to return the check result. The invoke will occur in a dispatch queue that is set by ”Permission.preferredQueue“.
    */
    static func checkStatus(completion: @escaping (Status) -> Void)
    
}

protocol Requestable: Permission.SupportedType {
    
    associatedtype Status
    
    // MARK: - Public Functions
    
    /**
     Asks a user for access the permission type

     - Parameter completion: A block that will be invoked to return the request result. The invoke will occur in a dispatch queue that is set by ”Permission.preferredQueue“.
     - Throws: `Permission.Error`, if something went wrong. For example, your ”Info.plist“ is configured incorrectly.
    */
    static func requestAccess(completion: ((Status) -> Void)?) throws
    
}
