//
//  HealthPanel.swift
//  PermissionWizard
//
//  Created by Sergei Moskvin on 09.11.2020.
//

#if !targetEnvironment(macCatalyst)

import HealthKit
import PermissionWizard

final class HealthPanel: Panel<Permission.health> {
    
    private let dataType = HKObjectType.workoutType()
    
    // MARK: Overriding Functions
    
    override func configure() {
        super.configure()
        
        addButton(title: "Check Status (Writing Only)") {
            if Constants.useSwiftConcurrency {
                Task {
                    let status = await self.permission.checkStatusForWriting(of: self.dataType)
                    self.notify(status.rawValue)
                }
            } else {
                self.permission.checkStatusForWriting(of: self.dataType) { self.notify($0.rawValue) }
            }
        }
        
        addButton(title: "Request Access") {
            if Constants.useSwiftConcurrency {
                Task {
                    try! await self.permission.requestAccess(forReading: [self.dataType], writing: [self.dataType])
                    self.notifyAboutRequestInferiority()
                }
            } else {
                try! self.permission.requestAccess(forReading: [self.dataType], writing: [self.dataType]) {
                    self.notifyAboutRequestInferiority()
                }
            }
        }
    }
    
}

#endif
