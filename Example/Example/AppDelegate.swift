//
//  AppDelegate.swift
//  PermissionKit.Example
//
//  Created by Sergey Moskvin on 03.10.2020.
//

import UIKit

@UIApplicationMain
final class AppDelegate: UIResponder, UIApplicationDelegate {
    
    private let configurationName = "Default Configuration"
    
    // MARK: - Life Cycle
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        return true
    }
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: configurationName, sessionRole: connectingSceneSession.role)
    }
    
}
