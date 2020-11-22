//
//  Base.swift
//  PermissionWizard
//
//  Created by Sergey Moskvin on 21.11.2020.
//

import UIKit

extension Permission {
    
    public class Base {
        
        // MARK: - Properties
        
        class var contextName: String { .init(describing: self) }
        
        class var shouldBorderIcon: Bool { false }
        
        // MARK: - Public Functions
        
#if ASSETS || !CUSTOM_SETTINGS
        /**
         Returns an image representing the permission type for your UI

         All provided icons are native, the same as displayed in the system preferences

         - Parameter squircle: A flag indicating whether the image must be styled like in the system preferences
         - Parameter screen: A screen where the image will be displayed. It used to ensure proper scaling.
        */
        public class func getIcon(squircle: Bool = true, for screen: UIScreen = .main) -> UIImage? {
            let name = String(describing: self)
            return Utils.getEmbeddedIcon(name: name, makeSquircle: squircle, shouldBorder: shouldBorderIcon, for: screen)
        }
        
        /**
         Returns a localized string representing the permission type for your UI

         All provided strings are native, the same as displayed in the system preferences

         # Examples
         `Camera, Face ID, Local Network`

         - Parameter specificLocalization: A code of the desired localization according to ISO 639 (for example, ”ru“ or ”pt-BR“). By default, the current system preference.
        */
        public class func getLocalizedName(specificLocalization: String? = nil) -> String? {
            let key = String(describing: self)
            return Utils.getEmbeddedString(key: key, specificLocalization: specificLocalization)
        }
#endif
        
    }
    
}
