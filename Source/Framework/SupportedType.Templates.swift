//
//  SupportedType.Templates.swift
//  PermissionWizard
//
//  Created by Sergey Moskvin on 26.11.2020.
//

protocol Checkable: Permission.SupportedType {
    
    associatedtype Status
    
    // MARK: Public Functions
    
    /**
     Asks the system for the current status of the permission type

     - Parameter completion: A block that will be invoked to return the check result
    */
    static func checkStatus(completion: @escaping (Status) -> Void)
    
    /**
     Asks the system for the current status of the permission type
    */
    @available(iOS 13, *)
    static func checkStatus() async -> Status
    
}

protocol Requestable: Permission.SupportedType {
    
    associatedtype Status
    
    // MARK: Public Functions
    
    /**
     Asks a user for access the permission type

     - Parameter completion: A block that will be invoked to return the request result
     - Throws: `Permission.Error`, if something went wrong. For example, your ”Info.plist“ is configured incorrectly.
    */
    static func requestAccess(completion: ((Status) -> Void)?) throws
    
    /**
     Asks a user for access the permission type

     - Throws: `Permission.Error`, if something went wrong. For example, your ”Info.plist“ is configured incorrectly.
    */
    @available(iOS 13, *)
    static func requestAccess() async throws -> Status
    
}
