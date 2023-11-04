//
//  PhotosPanel.swift
//  PermissionWizard
//
//  Created by Sergei Moskvin on 09.11.2020.
//

import PermissionWizard
import UIKit

final class PhotosPanel: Panel<Permission.photos> {
    
    override func configure() {
        super.configure()
        
        let forAddingOnlySwitch = addSwitch(title: "For Adding Only")
        
        addDefaultButtons(checkStatusAction: {
            let forAddingOnly = forAddingOnlySwitch.isOn
            
            if Constants.useSwiftConcurrency {
                Task {
                    let status = try! await self.permission.checkStatus(forAddingOnly: forAddingOnly)
                    self.notify(status.rawValue)
                }
            } else {
                self.permission.checkStatus(forAddingOnly: forAddingOnly) { self.notify($0.rawValue) }
            }
        }, requestAccessAction: {
            let forAddingOnly = forAddingOnlySwitch.isOn
            
            if Constants.useSwiftConcurrency {
                Task {
                    let status = try! await self.permission.requestAccess(forAddingOnly: forAddingOnly)
                    self.notify(status.rawValue)
                }
            } else {
                try! self.permission.requestAccess(forAddingOnly: forAddingOnly) { self.notify($0.rawValue) }
            }
        })
    }
    
}
