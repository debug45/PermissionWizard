//
//  SiriPanel.swift
//  PermissionWizard
//
//  Created by Sergei Moskvin on 27.11.2020.
//

#if !targetEnvironment(macCatalyst)

import PermissionWizard

final class SiriPanel: Panel<Permission.siri> {
    
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

#endif
