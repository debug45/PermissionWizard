//
//  CameraPanel.swift
//  PermissionKit.Example
//
//  Created by Sergey Moskvin on 09.11.2020.
//

import PermissionKit

final class CameraPanel: Panel<Permission.camera> {
    
    // MARK: - Overriding Functions
    
    override func configure() {
        super.configure()
        
        let withMicrophoneSwitch = addSwitch(title: "With Microphone")
        
        addDefaultButtons(checkStatusAction: {
            self.permission.checkStatus(withMicrophone: withMicrophoneSwitch.isOn) { self.notify(about: $0) }
        }, requestAccessAction: {
            self.permission.requestAccess(withMicrophone: withMicrophoneSwitch.isOn) { self.notify(about: $0) }
        })
    }
    
    // MARK: - Private Functions
    
    private func notify(about status: Permission.camera.CombinedStatus) {
        var message = status.camera.rawValue
        
        if let microphone = status.microphone {
            message = "[camera: \(message), microphone: \(microphone.rawValue)]"
        }
        
        notify(message)
    }
    
}
