//
//  CameraPanel.swift
//  PermissionWizard
//
//  Created by Sergei Moskvin on 09.11.2020.
//

import PermissionWizard

final class CameraPanel: Panel<Permission.camera> {
    
    // MARK: Overriding Functions
    
    override func configure() {
        super.configure()
        
        let withMicrophoneSwitch = addSwitch(title: "With Microphone")
        
        addDefaultButtons(checkStatusAction: {
            if #available(iOS 13, *) {
                Task {
                    let status = await self.permission.checkStatus(withMicrophone: withMicrophoneSwitch.isOn)
                    self.notify(about: status)
                }
            } else {
                self.permission.checkStatus(withMicrophone: withMicrophoneSwitch.isOn) { self.notify(about: $0) }
            }
        }, requestAccessAction: {
            if #available(iOS 13, *) {
                Task {
                    let status = try! await self.permission.requestAccess(withMicrophone: withMicrophoneSwitch.isOn)
                    self.notify(about: status)
                }
            } else {
                try! self.permission.requestAccess(withMicrophone: withMicrophoneSwitch.isOn) { self.notify(about: $0) }
            }
        })
    }
    
    // MARK: Private Functions
    
    private func notify(about status: Permission.camera.Status) {
        var message = status.camera.rawValue
        
        if let microphone = status.microphone {
            message = "[camera: \(message), microphone: \(microphone.rawValue)]"
        }
        
        notify(message)
    }
    
}
