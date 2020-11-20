//
//  RemindersPanel.swift
//  PermissionWizard
//
//  Created by Sergey Moskvin on 09.11.2020.
//

import PermissionWizard

final class RemindersPanel: Panel<Permission.reminders> {
    
    override func configure() {
        super.configure()
        
        addDefaultButtons(checkStatusAction: {
            self.permission.checkStatus { self.notify($0.rawValue) }
        }, requestAccessAction: {
            try! self.permission.requestAccess { self.notify($0.rawValue) }
        })
    }
    
}
