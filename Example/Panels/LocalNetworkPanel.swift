//
//  LocalNetworkPanel.swift
//  PermissionWizard
//
//  Created by Sergey Moskvin on 09.11.2020.
//

import PermissionWizard

@available(iOS 14, *)
final class LocalNetworkPanel: Panel<Permission.localNetwork> {
    
    override func configure() {
        super.configure()
        
        addButton(title: "Request Access") {
            try! self.permission.requestAccess(servicePlistKey: "_example._tcp")
            self.notify("⚠️ The ”requestAccess“ does not support returning of a result")
        }
    }
    
}
