//
//  LocalNetworkPanel.swift
//  PermissionWizard
//
//  Created by Sergei Moskvin on 09.11.2020.
//

#if !targetEnvironment(macCatalyst)

import PermissionWizard

@available(iOS 14, *)
final class LocalNetworkPanel: Panel<Permission.localNetwork> {
    
    private let servicePlistKey = "_example._tcp"
    
    // MARK: Overriding Functions
    
    override func configure() {
        super.configure()
        
        addButton(title: "Request Access") {
            // if #available(iOS 13, *) {
                Task {
                    let status = try! await self.permission.requestAccess(servicePlistKey: self.servicePlistKey)
                    self.notify(about: status)
                }
            /* } else {
                try! self.permission.requestAccess(servicePlistKey: self.servicePlistKey) { self.notify(about: $0) }
            } */
        }
    }
    
    // MARK: Private Functions
    
    private func notify(about status: Permission.localNetwork.Status) {
        let message = "[atTimeOfRequest: \(status.rawValue)]"
        notify(message)
    }
    
}

#endif
