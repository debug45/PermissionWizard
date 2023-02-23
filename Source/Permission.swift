//
//  Permission.swift
//  PermissionWizard
//
//  Created by Sergei Moskvin on 03.10.2020.
//

import UIKit

public struct Permission {
    
#if ASSETS || !CUSTOM_SETTINGS
    private static let privacyAssetKey = "Privacy"
#endif
    
    // MARK: Public Functions
    
#if ASSETS || !CUSTOM_SETTINGS
    /**
     Returns an image representing privacy for your UI

     The icon is native, the same as displayed in the system preferences

     - Parameter squircle: A flag indicating whether the image must be styled like in the system preferences
     - Parameter screen: A screen where the image will be displayed, it is used to ensure proper scaling
    */
    public static func getPrivacyIcon(squircle: Bool = true, for screen: UIScreen = .main) -> UIImage? {
        return Utils.getEmbeddedIcon(name: privacyAssetKey, makeSquircle: squircle, shouldBorder: false, for: screen)
    }
    
    /**
     Returns a localized string representing privacy for your UI

     The string is native, the same as displayed in the system preferences

     - Parameter specificLocalization: A code of the desired localization according to ISO 639. For example, “ru” or “pt-BR”. By default, the current system localization.
    */
    public static func getPrivacyLocalizedTitle(specificLocalization: String? = nil) -> String? {
        return Utils.getEmbeddedString(key: privacyAssetKey, specificLocalization: specificLocalization)
    }
#endif
    
}
