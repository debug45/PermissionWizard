//
//  MotionPanel.swift
//  PermissionWizard
//
//  Created by Sergei Moskvin on 09.11.2020.
//

#if !targetEnvironment(macCatalyst)

import PermissionWizard

final class MotionPanel: Panel<Permission.motion> {
    
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
            try! self.permission.requestAccess()
            self.notifyAboutRequestInferiority()
        })
    }
    
}

#endif
