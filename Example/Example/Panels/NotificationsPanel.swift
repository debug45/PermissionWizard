//
//  NotificationsPanel.swift
//  PermissionKit.Example
//
//  Created by Sergey Moskvin on 09.11.2020.
//

import PermissionKit
import UIKit
import UserNotifications

final class NotificationsPanel: Panel<Permission.notifications> {
    
    private var dependentSwitches: [UISwitch] = []
    
    // MARK: - Overriding Functions
    
    override func configure() {
        super.configure()
        
        let alertsSwitch = addSwitch(title: "Alerts", withIncreasedOffset: false)
        let badgeSwitch = addSwitch(title: "Badge", withIncreasedOffset: false)
        let soundSwitch = addSwitch(title: "Sound")
        
        let carPlaySwitch = addSwitch(title: "CarPlay", withIncreasedOffset: false)
        
        var siriAnnouncementsSwitch: UISwitch?
        
        if #available(iOS 13, *) {
            siriAnnouncementsSwitch = addSwitch(title: "Siri Announcements")
        } else {
#if !targetEnvironment(macCatalyst)
            if #available(iOS 11, *) {
                addSeparatingOffset()
            }
#endif
        }
        
        var criticalAlertsSwitch: UISwitch?
        var provisionallySwitch: UISwitch?
        
        var providingInAppSettingsSwitch: UISwitch?
        
        if #available(iOS 12, *) {
            criticalAlertsSwitch = addSwitch(title: "Critical Alerts", withIncreasedOffset: false)
            provisionallySwitch = addSwitch(title: "Provisionally")
            
            let selector = #selector(provisionallySwitchDidChange)
            provisionallySwitch?.addTarget(self, action: selector, for: .valueChanged)
            
            providingInAppSettingsSwitch = addSwitch(title: "Providing in-app settings")
        }
        
        dependentSwitches = [alertsSwitch, badgeSwitch, soundSwitch, carPlaySwitch, siriAnnouncementsSwitch, criticalAlertsSwitch].compactMap { $0 }
        
        addDefaultButtons(checkStatusAction: {
            self.permission.checkStatus { self.notify($0.rawValue) }
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
            
            if siriAnnouncementsSwitch?.isOn == true && siriAnnouncementsSwitch?.isEnabled == true, #available(iOS 13, *) {
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
            
            self.permission.requestAccess(options: options) { self.notify($0.rawValue) }
        })
    }
    
    // MARK: - Private Functions
    
    @objc private func provisionallySwitchDidChange(_ switchView: UISwitch) {
        dependentSwitches.forEach { $0.isEnabled = !switchView.isOn }
    }
    
}
