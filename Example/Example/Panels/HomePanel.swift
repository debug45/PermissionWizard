//
//  HomePanel.swift
//  PermissionKit.Example
//
//  Created by Sergey Moskvin on 09.11.2020.
//

#if !targetEnvironment(macCatalyst)

import PermissionKit

@available(iOS 13, *)
final class HomePanel: Panel<Permission.home> {
    
    override func configure() {
        super.configure()
        
        addButton(title: "Request Access") {
            self.permission.requestAccess { self.notify($0.rawValue) }
        }
    }
    
}

#endif
