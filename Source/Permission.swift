//
//  Permission.swift
//  PermissionWizard
//
//  Created by Sergey Moskvin on 03.10.2020.
//

import UIKit

public class Permission {
    
    private static let privacyIconName = "Privacy"
    
    // MARK: - Global Settings
    
    /**
     The dispatch queue used to invoke all completion blocks

     In some cases default system API may return a result in a different dispatch queue. Instead of risking a crash and manual queue management, you can ask to always invoke completion blocks in a preferred queue.

     # By Default
     `DispatchQueue.main`
    */
    public static var preferredQueue: DispatchQueue? = .main
    
    // MARK: - Public Functions
    
#if ICONS || !CUSTOM_SETTINGS
    /**
     Returns an image representing privacy for your UI

     The icon is native, the same as displayed in the system preferences

     - Parameter squircle: A flag indicating whether the image must be styled like in the system preferences
     - Parameter screen: A screen where the image will be displayed. It used to ensure proper scaling.
    */
    public class func getPrivacyIcon(squircle: Bool = true, for screen: UIScreen = .main) -> UIImage? {
        return Utils.getEmbeddedIcon(name: privacyIconName, makeSquircle: squircle, shouldBorder: false, for: screen)
    }
#endif
    
}
