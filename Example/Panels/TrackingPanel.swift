//
//  TrackingPanel.swift
//  PermissionWizard
//
//  Created by Sergey Moskvin on 03.12.2020.
//

#if !targetEnvironment(macCatalyst)

import PermissionWizard

@available(iOS 14, *)
final class TrackingPanel: Panel<Permission.tracking> {
    
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
