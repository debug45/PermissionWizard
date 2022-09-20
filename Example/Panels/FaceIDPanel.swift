//
//  FaceIDPanel.swift
//  PermissionWizard
//
//  Created by Sergey Moskvin on 09.11.2020.
//

#if !targetEnvironment(macCatalyst)

import PermissionWizard

final class FaceIDPanel: Panel<Permission.faceID> {
    
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
