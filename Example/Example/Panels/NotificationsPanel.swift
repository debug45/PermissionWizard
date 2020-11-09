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
                increaseOffset(after: carPlaySwitch)
            }
#endif
        }
        
        var criticalAlertsSwitch: UISwitch?
        var provisionallySwitch: UISwitch?
        
        var providingInAppSettingsSwitch: UISwitch?
        
        if #available(iOS 12, *) {
            criticalAlertsSwitch = addSwitch(title: "Critical Alerts", withIncreasedOffset: false)
            provisionallySwitch = addSwitch(title: "Provisionally")
            
            providingInAppSettingsSwitch = addSwitch(title: "Providing in-app settings")
        }
        
        addDefaultButtons(checkStatusAction: {
            self.permission.checkStatus { self.notify($0.rawValue) }
        }, requestAccessAction: {
            var options: UNAuthorizationOptions = []
            
            if alertsSwitch.isOn {
                options.insert(.alert)
            }
            
            if badgeSwitch.isOn {
                options.insert(.badge)
            }
            
            if soundSwitch.isOn {
                options.insert(.sound)
            }
            
            if carPlaySwitch.isOn {
                options.insert(.carPlay)
            }
            
            if siriAnnouncementsSwitch?.isOn == true, #available(iOS 13, *) {
                options.insert(.announcement)
            }
            
            if #available(iOS 12, *) {
                if criticalAlertsSwitch?.isOn == true {
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
    
}
