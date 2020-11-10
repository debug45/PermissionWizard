//
//  MotionPanel.swift
//  Permission Wizard
//
//  Created by Sergey Moskvin on 09.11.2020.
//

import PermissionWizard

@available(iOS 11, *)
final class MotionPanel: Panel<Permission.motion> {
    
    override func configure() {
        super.configure()
        
        addDefaultButtons(checkStatusAction: {
            self.permission.checkStatus { self.notify($0.rawValue) }
        }, requestAccessAction: {
            self.permission.requestAccess()
            self.notify("⚠️ The ”requestAccess“ does not support returning of a result, use the ”checkStatus“ if necessary")
        })
    }
    
}
