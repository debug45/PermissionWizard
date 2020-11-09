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
        
        let whenInUseOnlySwitch = addSwitch(title: "When in Use Only")
        
        addDefaultButtons(checkStatusAction: {
            self.permission.checkStatus { self.notify(about: $0) }
        }, requestAccessAction: {
            self.permission.requestAccess(whenInUseOnly: whenInUseOnlySwitch.isOn) { self.notify(about: $0) }
        })
        
#if !targetEnvironment(macCatalyst)
        if #available(iOS 14, *) {
            addButton(title: "Request Temporary Precise Access") {
                self.permission.requestTemporaryPreciseAccess(purposePlistKey: "Default") { self.notify("[temporaryPrecise: \($0)]") }
            }
        }
#endif
    }
    
    // MARK: - Private Functions
    
    private func notify(about status: Permission.location.CombinedStatus) {
        let message = "[value: \(status.value.rawValue), isReducing: \(status.isReducing)]"
        notify(message)
    }
    
}
