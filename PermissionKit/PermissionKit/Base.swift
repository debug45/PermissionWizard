//
//  Base.swift
//  PermissionKit
//
//  Created by Sergey Moskvin on 14.10.2020.
//

public class Base {
    
    public class var titleName: String {
        let value = String(describing: self)
        return value.prefix(1).uppercased() + value.dropFirst()
    }
    
    public class var contextName: String { .init(describing: self) }
    
    public class var usageDescriptionPlistKey: String? { nil }
    
}
