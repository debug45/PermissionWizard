//
//  CameraPanel.swift
//  PermissionWizard
//
//  Created by Sergei Moskvin on 09.11.2020.
//

import PermissionWizard

@available(macCatalyst 14, *)
final class CameraPanel: Panel<Permission.camera> {
    
    // MARK: Overriding Functions
    
    override func configure() {
        super.configure()
        
        let withMicrophoneSwitch = addSwitch(title: "With Microphone")
        
        addDefaultButtons(checkStatusAction: {
            let performWithCompletion = {
                self.permission.checkStatus(withMicrophone: withMicrophoneSwitch.isOn) { self.notify(about: $0) }
            }
            
#if !targetEnvironment(macCatalyst)
            guard #available(iOS 13, *), Constants.useSwiftConcurrency else {
                performWithCompletion()
                return
            }
#else
            guard Constants.useSwiftConcurrency else {
                performWithCompletion()
                return
            }
#endif
            
            Task {
                let status = await self.permission.checkStatus(withMicrophone: withMicrophoneSwitch.isOn)
                self.notify(about: status)
            }
        }, requestAccessAction: {
            let performWithCompletion = {
                try! self.permission.requestAccess(withMicrophone: withMicrophoneSwitch.isOn) { self.notify(about: $0) }
            }
            
#if !targetEnvironment(macCatalyst)
            guard #available(iOS 13, *), Constants.useSwiftConcurrency else {
                performWithCompletion()
                return
            }
#else
            guard Constants.useSwiftConcurrency else {
                performWithCompletion()
                return
            }
#endif
            
            Task {
                let status = try! await self.permission.requestAccess(withMicrophone: withMicrophoneSwitch.isOn)
                self.notify(about: status)
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
