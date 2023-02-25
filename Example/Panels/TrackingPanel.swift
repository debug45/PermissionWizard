//
//  TrackingPanel.swift
//  PermissionWizard
//
//  Created by Sergei Moskvin on 03.12.2020.
//

#if !targetEnvironment(macCatalyst)

import PermissionWizard

@available(iOS 14, *)
final class TrackingPanel: Panel<Permission.tracking> {
    
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
