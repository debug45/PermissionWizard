//
//  LocationPanel.swift
//  PermissionKit.Example
//
//  Created by Sergey Moskvin on 09.11.2020.
//

import PermissionKit

final class LocationPanel: Panel<Permission.location> {
    
    // MARK: - Overriding Functions
    
    override func configure() {
        super.configure()
        
        addButton(title: "Check Status") {
            self.permission.checkStatus { self.notify(about: $0) }
        }
        
        if #available(iOS 11, *) {
            addSeparatingOffset()
        }
        
        let whenInUseOnlySwitch = addSwitch(title: "When in Use Only", withIncreasedOffset: false)
        
        addButton(title: "Request Access") {
            self.permission.requestAccess(whenInUseOnly: whenInUseOnlySwitch.isOn) { self.notify(about: $0) }
        }
        
#if !targetEnvironment(macCatalyst)
        if #available(iOS 14, *) {
            addSeparatingOffset()
            
            addButton(title: "Request Temporary Precise Access") {
                self.permission.requestTemporaryPreciseAccess(purposePlistKey: "Default") { self.notify("[temporaryPrecise: \($0)]") }
            }
        }
#endif
    }
    
    // MARK: - Private Functions
    
    private func notify(about status: Permission.location.CombinedStatus) {
        let message = "[status: \(status.value.rawValue), isReducing: \(status.isReducing)]"
        notify(message)
    }
    
}
