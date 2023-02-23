//
//  HomePanel.swift
//  PermissionWizard
//
//  Created by Sergei Moskvin on 09.11.2020.
//

import PermissionWizard

@available(iOS 13, macCatalyst 14, *)
final class HomePanel: Panel<Permission.home> {
    
    override func configure() {
        super.configure()
        
        addButton(title: "Request Access") {
            // if #available(iOS 13, *) {
                Task {
                    let status = try! await self.permission.requestAccess()
                    self.notify(status.rawValue)
                }
            /* } else {
                try! self.permission.requestAccess { self.notify($0.rawValue) }
            } */
        }
    }
    
}
