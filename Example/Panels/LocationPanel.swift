//
//  LocationPanel.swift
//  PermissionWizard
//
//  Created by Sergei Moskvin on 09.11.2020.
//

import PermissionWizard

final class LocationPanel: Panel<Permission.location> {
    
    // MARK: Overriding Functions
    
    override func configure() {
        super.configure()
        
        addButton(title: "Check Status") {
            self.permission.checkStatus { self.notify(about: $0) }
        }
        
        addSeparatingOffset()
        
        let whenInUseOnlySwitch = addSwitch(title: "When in Use Only", withIncreasedOffset: false)
        
        if let lastView = arrangedSubviews.last {
            setCustomSpacing(16, after: lastView)
        }
        
        addButton(title: "Request Access") {
            try! self.permission.requestAccess(whenInUseOnly: whenInUseOnlySwitch.isOn) { self.notify(about: $0) }
        }
        
        if #available(iOS 14, *) {
            addSeparatingOffset()
            
            addButton(title: "Request Temporary Precise Access") {
                try! self.permission.requestTemporaryPreciseAccess(purposePlistKey: "Default") { self.notify("[temporaryPrecise: \($0)]") }
            }
        }
    }
    
    // MARK: Private Functions
    
    private func notify(about status: Permission.location.Status) {
        let message = "[status: \(status.value.rawValue), isAccuracyReducing: \(status.isAccuracyReducing)]"
        notify(message)
    }
    
}
