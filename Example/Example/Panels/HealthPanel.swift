//
//  HealthPanel.swift
//  PermissionKit.Example
//
//  Created by Sergey Moskvin on 09.11.2020.
//

#if !targetEnvironment(macCatalyst)

import HealthKit
import PermissionKit

final class HealthPanel: Panel<Permission.health> {
    
    private let dataType = HKObjectType.workoutType()
    
    // MARK: - Overriding Functions
    
    override func configure() {
        super.configure()
        
        addButton(title: "Check Status (Writing Only)") {
            self.permission.checkStatusForWriting(of: self.dataType) { self.notify($0.rawValue) }
        }
        
        addButton(title: "Request Access") {
            self.permission.requestAccess(forReading: [self.dataType], writing: [self.dataType]) {
                self.notify("⚠️ The ”requestAccess“ does not support returning of a result, use the ”checkStatus“ if necessary")
            }
        }
    }
    
}

#endif
