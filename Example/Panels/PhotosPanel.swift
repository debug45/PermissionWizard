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
        
        var forAddingOnlySwitch: UISwitch?
        
        if #available(iOS 14, *) {
            forAddingOnlySwitch = addSwitch(title: "For Adding Only")
        }
        
        addDefaultButtons(checkStatusAction: {
            guard #available(iOS 14, *) else {
                if #available(iOS 13, *) {
                    Task {
                        let status = await self.permission.checkStatus()
                        self.notify(status.rawValue)
                    }
                } else {
                    self.permission.checkStatus { self.notify($0.rawValue) }
                }
                
                return
            }
            
            let forAddingOnly = forAddingOnlySwitch?.isOn == true
            
            // if #available(iOS 13, *) {
                Task {
                    let status = try! await self.permission.checkStatus(forAddingOnly: forAddingOnly)
                    self.notify(status.rawValue)
                }
            /* } else {
                self.permission.checkStatus(forAddingOnly: forAddingOnly) { self.notify($0.rawValue) }
            } */
        }, requestAccessAction: {
            guard #available(iOS 14, *) else {
                if #available(iOS 13, *) {
                    Task {
                        let status = try! await self.permission.requestAccess()
                        self.notify(status.rawValue)
                    }
                } else {
                    try! self.permission.requestAccess { self.notify($0.rawValue) }
                }
                
                return
            }
            
            let forAddingOnly = forAddingOnlySwitch?.isOn == true
            
            // if #available(iOS 13, *) {
                Task {
                    let status = try! await self.permission.requestAccess(forAddingOnly: forAddingOnly)
                    self.notify(status.rawValue)
                }
            /* } else {
                try! self.permission.requestAccess(forAddingOnly: forAddingOnly) { self.notify($0.rawValue) }
            } */
        })
    }
    
}
