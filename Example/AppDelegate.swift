//
//  AppDelegate.swift
//  PermissionWizard
//
//  Created by Sergey Moskvin on 03.10.2020.
//

import UIKit

@UIApplicationMain
final class AppDelegate: UIResponder, UIApplicationDelegate {
    
    // MARK: Life Cycle
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        DispatchQueue.main.async {
            // A blank network request to reveal hidden Cellular Data permission
            
            guard let url = URL(string: "https://apple.com") else {
                return
            }
            
            let task = URLSession.shared.dataTask(with: url) { _, _, _ in }
            task.resume()
        }
        
        return true
    }
    
    // MARK: Internal Properties
    
    var window: UIWindow?
    
}
