//
//  Utils.swift
//  PermissionWizard
//
//  Created by Sergei Moskvin on 14.10.2020.
//

import UIKit

struct Utils {
    
#if ASSETS || !CUSTOM_SETTINGS
    private static let iconsBundleName = "Icons"
    private static let localizationsBundleName = "Localizations"
    
    private static let squircleIconCornerRadius: CGFloat = 7
    
    private static let iconBorderWidth: CGFloat = 1
    private static let iconBorderColor = UIColor.black.withAlphaComponent(0.1)
#endif
    
    // MARK: Internal Functions
    
    static func linkToQueue<T>(_ queue: DispatchQueue, closure: @escaping (T) -> Void) -> (T) -> Void {
        return { parameter in
            queue.async {
                closure(parameter)
            }
        }
    }
    
    static func linkToQueue(_ queue: DispatchQueue, closure: @escaping () -> Void) -> () -> Void {
        return {
            queue.async {
                closure()
            }
        }
    }
    
    static func checkIsAppConfigured(for permission: Permission.SupportedType.Type, usageDescriptionsPlistKeys: [String]) throws {
        for plistKey in usageDescriptionsPlistKeys {
            let value = Bundle.main.object(forInfoDictionaryKey: plistKey) as? String
            
            if value?.isEmpty != false {
                throw createInvalidAppConfigurationError(permissionName: permission.contextName, missingPlistKey: plistKey)
            }
        }
    }
    
    static func checkIsAppConfigured(for permission: Permission.SupportedType.Type, usageDescriptionPlistKey: String? = nil) throws {
        guard let plistKey = usageDescriptionPlistKey else {
            return
        }
        
        try checkIsAppConfigured(for: permission, usageDescriptionsPlistKeys: [plistKey])
    }
    
    static func createInvalidAppConfigurationError(permissionName: String, missingPlistKey: String, keyParent: (type: String, ownKey: String)? = nil, isTechnicalKey: Bool = false) -> Permission.Error {
        var clarification = ""
        
        if let keyParent = keyParent {
            clarification = " (to a nested \(keyParent.type) with the key “\(keyParent.ownKey)”)"
        }
        
        let additionalInfo = !isTechnicalKey ? " and specify the reason why you are requesting access to \(permissionName). This information will be displayed to a user" : ""
        let message = "❌ You must add a row with the “\(missingPlistKey)” key to your app’s plist file\(clarification)\(additionalInfo)."
        
        let type = Permission.Error.SupportedType.missingPlistKey(details: message)
        return Permission.Error(type, message: message)
    }
    
#if ASSETS || !CUSTOM_SETTINGS
    static func getEmbeddedIcon(name: String, makeSquircle: Bool, shouldBorder: Bool, for screen: UIScreen) -> UIImage? {
        var bundle = Bundle(for: Permission.SupportedType.self)
        
#if !EXAMPLE
        guard let url = bundle.url(forResource: iconsBundleName, withExtension: "bundle") else {
            return nil
        }
        
        bundle = Bundle(url: url) ?? bundle
#endif
        
        let name = uppercaseFirstLetter(name)
        
        guard var icon = UIImage(named: name, in: bundle, compatibleWith: nil) else {
            return nil
        }
        
        let frame = CGRect(origin: .zero, size: icon.size)
        UIGraphicsBeginImageContextWithOptions(frame.size, false, screen.scale)
        
        if makeSquircle {
            let path = UIBezierPath(roundedRect: frame, cornerRadius: squircleIconCornerRadius)
            path.addClip()
        }
        
        icon.draw(in: frame)
        
        if shouldBorder {
            let borderWidth = iconBorderWidth / screen.scale
            let frame = frame.insetBy(dx: borderWidth / 2, dy: borderWidth / 2)
            
            let path = UIBezierPath(roundedRect: frame, cornerRadius: makeSquircle ? squircleIconCornerRadius : 0)
            path.lineWidth = borderWidth
            
            iconBorderColor.setStroke()
            path.stroke()
        }
        
        icon = UIGraphicsGetImageFromCurrentImageContext() ?? icon
        UIGraphicsEndImageContext()
        
        return icon
    }
    
    static func getEmbeddedString(key: String, specificLocalization: String? = nil) -> String? {
        var bundle = Bundle(for: Permission.SupportedType.self)
        
#if !EXAMPLE
        guard let url = bundle.url(forResource: localizationsBundleName, withExtension: "bundle") else {
            return nil
        }
        
        bundle = Bundle(url: url) ?? bundle
#endif
        
        if let specificLocalization = specificLocalization {
            guard let path = bundle.path(forResource: specificLocalization, ofType: "lproj") else {
                return nil
            }
            
            bundle = Bundle(path: path) ?? bundle
        }
        
        let key = uppercaseFirstLetter(key)
        return bundle.localizedString(forKey: key, value: nil, table: nil)
    }
#endif
    
    // MARK: Private Functions
    
#if ASSETS || !CUSTOM_SETTINGS
    private static func uppercaseFirstLetter(_ value: String) -> String {
        return value.prefix(1).uppercased() + value.dropFirst()
    }
#endif
    
}
