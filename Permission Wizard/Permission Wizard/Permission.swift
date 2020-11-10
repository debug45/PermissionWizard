//
//  Permission.swift
//  Permission Wizard
//
//  Created by Sergey Moskvin on 03.10.2020.
//

public class Permission {
    
    // MARK: - Global Settings
    
    public static var preferredQueue: DispatchQueue? = .main
    
    // MARK: - Base Properties
    
    public class var titleName: String {
        return String(describing: self).capitalized
    }
    
    public class var contextName: String { .init(describing: self) }
    
    public class var usageDescriptionPlistKey: String? { nil }
    
}
