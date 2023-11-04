//
//  NotificationsPanel.swift
//  PermissionWizard
//
//  Created by Sergei Moskvin on 09.11.2020.
//

import PermissionWizard
import UIKit
import UserNotifications

final class NotificationsPanel: Panel<Permission.notifications> {
    
    private var dependentSwitches: [UISwitch] = []
    
    // MARK: Overriding Functions
    
    override func configure() {
        super.configure()
        
        let alertsSwitch = addSwitch(title: "Alerts", isOn: true, withIncreasedOffset: false)
        let badgeSwitch = addSwitch(title: "Badge", isOn: true, withIncreasedOffset: false)
        let soundSwitch = addSwitch(title: "Sound", isOn: true)
        
        let carPlaySwitch = addSwitch(title: "CarPlay", withIncreasedOffset: false)
        let siriAnnouncementsSwitch = addSwitch(title: "Siri Announcements")
        
        let criticalAlertsSwitch = addSwitch(title: "Critical Alerts", withIncreasedOffset: false)
        let provisionallySwitch = addSwitch(title: "Provisionally")
        
        let selector = #selector(provisionallySwitchDidChange)
        provisionallySwitch.addTarget(self, action: selector, for: .valueChanged)
        
        let providingInAppSettingsSwitch = addSwitch(title: "Providing In-App Settings")
        
        dependentSwitches = [alertsSwitch, badgeSwitch, soundSwitch, carPlaySwitch, siriAnnouncementsSwitch, criticalAlertsSwitch].compactMap { $0 }
        
        addDefaultButtons(checkStatusAction: {
            if Constants.useSwiftConcurrency {
                Task {
                    let status = await self.permission.checkStatus()
                    self.notify(status.rawValue)
                }
            } else {
                self.permission.checkStatus { self.notify($0.rawValue) }
            }
        }, requestAccessAction: {
            var options: UNAuthorizationOptions = []
            
            if alertsSwitch.isOn && alertsSwitch.isEnabled {
                options.insert(.alert)
            }
            
            if badgeSwitch.isOn && badgeSwitch.isEnabled {
                options.insert(.badge)
            }
            
            if soundSwitch.isOn && soundSwitch.isEnabled {
                options.insert(.sound)
            }
            
            if carPlaySwitch.isOn && carPlaySwitch.isEnabled {
                options.insert(.carPlay)
            }
            
            if siriAnnouncementsSwitch.isOn && siriAnnouncementsSwitch.isEnabled {
                options.insert(.announcement)
            }
            
            if criticalAlertsSwitch.isOn && criticalAlertsSwitch.isEnabled {
                options.insert(.criticalAlert)
            }
            
            if provisionallySwitch.isOn {
                options.insert(.provisional)
            }
            
            if providingInAppSettingsSwitch.isOn {
                options.insert(.providesAppNotificationSettings)
            }
            
            if Constants.useSwiftConcurrency {
                Task {
                    let status = try! await self.permission.requestAccess(options: options)
                    self.notify(status.rawValue)
                }
            } else {
                try! self.permission.requestAccess(options: options) { self.notify($0.rawValue) }
            }
        })
    }
    
    // MARK: Private Functions
    
    @objc private func provisionallySwitchDidChange(_ switchView: UISwitch) {
        dependentSwitches.forEach { $0.isEnabled = !switchView.isOn }
    }
    
}
