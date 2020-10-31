//
//  Base.swift
//  PermissionKit
//
//  Created by Sergey Moskvin on 14.10.2020.
//

public class Base {
    
    public class var contextName: String { .init(describing: self) }
    public class var usageDescriptionPlistKey: String? { nil }
    
}
