//
//  Permission.Base.swift
//  PermissionWizard
//
//  Created by Sergey Moskvin on 21.11.2020.
//

import UIKit

extension Permission {
    
    public class Base {
        
        // MARK: - Public Properties
        
        /**
         Returns a string that can be used in your UI as the permission type title name

         # Examples
         `Bluetooth, Face ID, Microphone, Speech Recognition`
        */
        public class var titleName: String {
            return String(describing: self).capitalized
        }
        
        /**
         Returns a string that can be used in your UI as the permission type context name

         # Examples
         `Bluetooth, Face ID, microphone, speech recognition`
        */
        public class var contextName: String { .init(describing: self) }
        
        // MARK: - Internal Properties
        
        class var shouldBorderIcon: Bool { false }
        
        // MARK: - Public Functions
        
    #if ICONS || !CUSTOM_SETTINGS
        /**
         Returns an image representing the permission type for your UI

         All provided icons are native, the same as displayed in the system preferences

         - Parameter squircle: A flag indicating whether the image must be styled like in the system preferences
         - Parameter screen: A screen where the image will be displayed. It used to ensure proper scaling.
        */
        public class func getIcon(squircle: Bool = true, for screen: UIScreen = .main) -> UIImage? {
            return Utils.getEmbeddedIcon(name: titleName, makeSquircle: squircle, shouldBorder: shouldBorderIcon, for: screen)
        }
    #endif
        
    }
    
}
