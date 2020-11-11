//
//  Permission.swift
//  PermissionWizard
//
//  Created by Sergey Moskvin on 03.10.2020.
//

import UIKit

public class Permission {
    
    // MARK: - Global Settings
    
    public static var preferredQueue: DispatchQueue? = .main
    
    // MARK: - Base Properties
    
#if ICONS || !CUSTOM_SETTINGS
    public class var icon: UIImage? {
        var bundle = Bundle(for: self)
        
        guard let url = bundle.url(forResource: "Icons", withExtension: "bundle") else {
            return nil
        }
        
        bundle = Bundle(url: url) ?? bundle
        return UIImage(named: titleName, in: bundle, compatibleWith: nil)
    }
    
    public class var shouldBorderIcon: Bool { false }
#endif
    
    public class var titleName: String {
        return String(describing: self).capitalized
    }
    
    public class var contextName: String { .init(describing: self) }
    
    public class var usageDescriptionPlistKey: String? { nil }
    
}
