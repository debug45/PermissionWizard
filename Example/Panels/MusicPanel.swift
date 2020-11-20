//
//  MusicPanel.swift
//  PermissionWizard
//
//  Created by Sergey Moskvin on 09.11.2020.
//

import PermissionWizard

final class MusicPanel: Panel<Permission.music> {
    
    override func configure() {
        super.configure()
        
        addDefaultButtons(checkStatusAction: {
            self.permission.checkStatus { self.notify($0.rawValue) }
        }, requestAccessAction: {
            try! self.permission.requestAccess { self.notify($0.rawValue) }
        })
    }
    
}
