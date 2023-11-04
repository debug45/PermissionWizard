//
//  ContactsPanel.swift
//  PermissionWizard
//
//  Created by Sergei Moskvin on 09.11.2020.
//

import PermissionWizard

final class ContactsPanel: Panel<Permission.contacts> {
    
    override func configure() {
        super.configure()
        
        addDefaultButtons(checkStatusAction: {
            if Constants.useSwiftConcurrency {
                Task {
                    let status = await self.permission.checkStatus()
                    self.notify(status.rawValue)
                }
            } else {
                self.permission.checkStatus { self.notify($0.rawValue) }
            }
        }, requestAccessAction: {
            if Constants.useSwiftConcurrency {
                Task {
                    let status = try! await self.permission.requestAccess()
                    self.notify(status.rawValue)
                }
            } else {
                try! self.permission.requestAccess { self.notify($0.rawValue) }
            }
        })
    }
    
}
