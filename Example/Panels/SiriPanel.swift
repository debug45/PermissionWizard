//
//  SiriPanel.swift
//  PermissionWizard
//
//  Created by Sergey Moskvin on 27.11.2020.
//

#if !targetEnvironment(macCatalyst)

import PermissionWizard

final class SiriPanel: Panel<Permission.siri> {
    
    override func configure() {
        super.configure()
        
        addDefaultButtons(checkStatusAction: {
            self.permission.checkStatus { self.notify($0.rawValue) }
        }, requestAccessAction: {
            try! self.permission.requestAccess { self.notify($0.rawValue) }
        })
    }
    
}

#endif
