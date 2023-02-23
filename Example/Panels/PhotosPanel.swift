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
                self.permission.checkStatus { self.notify($0.rawValue) }
                return
            }
            
            self.permission.checkStatus(forAddingOnly: forAddingOnlySwitch?.isOn == true) { self.notify($0.rawValue) }
        }, requestAccessAction: {
            guard #available(iOS 14, *) else {
                try! self.permission.requestAccess { self.notify($0.rawValue) }
                return
            }
            
            try! self.permission.requestAccess(forAddingOnly: forAddingOnlySwitch?.isOn == true) { self.notify($0.rawValue) }
        })
    }
    
}
