//
//  LocationPanel.swift
//  PermissionWizard
//
//  Created by Sergei Moskvin on 09.11.2020.
//

import PermissionWizard

final class LocationPanel: Panel<Permission.location> {
    
    private let temporaryPreciseAccessPurposePlistKey = "Default"
    
    // MARK: Overriding Functions
    
    override func configure() {
        super.configure()
        
        addButton(title: "Check Status") {
            if #available(iOS 13, *) {
                Task {
                    let status = await self.permission.checkStatus()
                    self.notify(about: status)
                }
            } else {
                self.permission.checkStatus { self.notify(about: $0) }
            }
        }
        
        addSeparatingOffset()
        
        let whenInUseOnlySwitch = addSwitch(title: "When in Use Only", withIncreasedOffset: false)
        
        if let lastView = arrangedSubviews.last {
            setCustomSpacing(16, after: lastView)
        }
        
        addButton(title: "Request Access") {
            if #available(iOS 13, *) {
                Task {
                    let status = try! await self.permission.requestAccess(whenInUseOnly: whenInUseOnlySwitch.isOn)
                    self.notify(about: status)
                }
            } else {
                try! self.permission.requestAccess(whenInUseOnly: whenInUseOnlySwitch.isOn) { self.notify(about: $0) }
            }
        }
        
        if #available(iOS 14, *) {
            addSeparatingOffset()
            
            addButton(title: "Request Temporary Precise Access") {
                // if #available(iOS 13, *) {
                    Task {
                        let status = try! await self.permission.requestTemporaryPreciseAccess(purposePlistKey: self.temporaryPreciseAccessPurposePlistKey)
                        self.notify(aboutTemporaryPreciseAccessStatus: status)
                    }
                /* } else {
                    try! self.permission.requestTemporaryPreciseAccess(purposePlistKey: self.temporaryPreciseAccessPurposePlistKey) {
                        self.notify(aboutTemporaryPreciseAccessStatus: $0)
                    }
                } */
            }
        }
    }
    
    // MARK: Private Functions
    
    private func notify(about status: Permission.location.Status) {
        let message = "[status: \(status.value.rawValue), isAccuracyReducing: \(status.isAccuracyReducing)]"
        notify(message)
    }
    
    private func notify(aboutTemporaryPreciseAccessStatus status: Bool) {
        let message = "[temporaryPrecise: \(status)]"
        notify(message)
    }
    
}
