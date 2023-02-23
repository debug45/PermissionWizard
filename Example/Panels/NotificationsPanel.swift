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
        
        var siriAnnouncementsSwitch: UISwitch?
        
        if #available(iOS 13, *) {
            siriAnnouncementsSwitch = addSwitch(title: "Siri Announcements")
        } else {
            addSeparatingOffset()
        }
        
        var criticalAlertsSwitch: UISwitch?
        var provisionallySwitch: UISwitch?
        
        var providingInAppSettingsSwitch: UISwitch?
        
        if #available(iOS 12, *) {
            criticalAlertsSwitch = addSwitch(title: "Critical Alerts", withIncreasedOffset: false)
            provisionallySwitch = addSwitch(title: "Provisionally")
            
            let selector = #selector(provisionallySwitchDidChange)
            provisionallySwitch?.addTarget(self, action: selector, for: .valueChanged)
            
            providingInAppSettingsSwitch = addSwitch(title: "Providing In-App Settings")
        }
        
        dependentSwitches = [alertsSwitch, badgeSwitch, soundSwitch, carPlaySwitch, siriAnnouncementsSwitch, criticalAlertsSwitch].compactMap { $0 }
        
        addDefaultButtons(checkStatusAction: {
            if #available(iOS 13, *) {
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
            
            if #available(iOS 13, *), siriAnnouncementsSwitch?.isOn == true && siriAnnouncementsSwitch?.isEnabled == true {
                options.insert(.announcement)
            }
            
            if #available(iOS 12, *) {
                if criticalAlertsSwitch?.isOn == true && criticalAlertsSwitch?.isEnabled == true {
                    options.insert(.criticalAlert)
                }
                
                if provisionallySwitch?.isOn == true {
                    options.insert(.provisional)
                }
                
                if providingInAppSettingsSwitch?.isOn == true {
                    options.insert(.providesAppNotificationSettings)
                }
            }
            
            if #available(iOS 13, *) {
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
