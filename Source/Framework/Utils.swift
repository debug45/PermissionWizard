//
//  Utils.swift
//  PermissionWizard
//
//  Created by Sergey Moskvin on 14.10.2020.
//

import UIKit

final class Utils {
    
#if ASSETS || !CUSTOM_SETTINGS
    private static let iconsBundleName = "Icons"
    private static let localizationsBundleName = "Localizations"

    private static let squircleIconCornerRadius: CGFloat = 7
    
    private static let iconBorderWidth: CGFloat = 1
    private static let iconBorderColor = UIColor.black.withAlphaComponent(0.1)
#endif
    
    // MARK: - Internal Functions
    
    static func linkToPreferredQueue<T>(_ block: @escaping (T) -> Void) -> (T) -> Void {
        guard let preferredQueue = Permission.preferredQueue else {
            return block
        }
        
        return { parameter in
            preferredQueue.async {
                block(parameter)
            }
        }
    }
    
    static func linkToPreferredQueue(_ block: @escaping () -> Void) -> () -> Void {
        guard let preferredQueue = Permission.preferredQueue else {
            return block
        }
        
        return {
            preferredQueue.async {
                block()
            }
        }
    }
    
    static func checkIsAppConfigured(for permission: Permission.Base.Type, usageDescriptionsPlistKeys: [String]) throws {
        for plistKey in usageDescriptionsPlistKeys {
            let value = Bundle.main.object(forInfoDictionaryKey: plistKey) as? String
            
            if value?.isEmpty != false {
                throw createInvalidAppConfigurationError(missingPlistKey: plistKey, permissionName: permission.contextName)
            }
        }
    }
    
    static func checkIsAppConfigured(for permission: Permission.Base.Type, usageDescriptionPlistKey: String? = nil) throws {
        guard let plistKey = usageDescriptionPlistKey else {
            return
        }
        
        try checkIsAppConfigured(for: permission, usageDescriptionsPlistKeys: [plistKey])
    }
    
#if LOCAL_NETWORK || !CUSTOM_SETTINGS
    @available(iOS 14, *)
    static func checkIsAppConfiguredForLocalNetworkAccess(usageDescriptionPlistKey: String, servicePlistKey: String) throws {
        try checkIsAppConfigured(for: Permission.localNetwork.self, usageDescriptionPlistKey: usageDescriptionPlistKey)
        
        let arrayKey = "NSBonjourServices"
        
        if let array = Bundle.main.object(forInfoDictionaryKey: arrayKey) as? [String], array.contains(servicePlistKey) {
            return
        }
        
        let clarification = "to a nested array with the key ”\(arrayKey)“"
        throw createInvalidAppConfigurationError(missingPlistKey: servicePlistKey, permissionName: "local network", clarification: clarification)
    }
#endif
    
#if LOCATION || !CUSTOM_SETTINGS
    @available(iOS 14, *)
    static func checkIsAppConfiguredForTemporaryPreciseLocationAccess(purposePlistKey: String) throws {
        let dictionaryKey = "NSLocationTemporaryUsageDescriptionDictionary"
        
        if let dictionary = Bundle.main.object(forInfoDictionaryKey: dictionaryKey) as? [String: String], dictionary[purposePlistKey]?.isEmpty == false {
            return
        }
        
        let clarification = "to a nested dictionary with the key ”\(dictionaryKey)“"
        throw createInvalidAppConfigurationError(missingPlistKey: purposePlistKey, permissionName: "temporary precise location", clarification: clarification)
    }
#endif
    
#if ASSETS || !CUSTOM_SETTINGS
    static func getEmbeddedIcon(name: String, makeSquircle: Bool, shouldBorder: Bool, for screen: UIScreen) -> UIImage? {
        var bundle = Bundle(for: self)
        
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
        
        if #available(iOS 11, *), shouldBorder {
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
        var bundle = Bundle(for: self)
        
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
    
    // MARK: - Private Functions
    
    private static func createInvalidAppConfigurationError(missingPlistKey: String, permissionName: String, clarification: String? = nil) -> Permission.Error {
        let clarification = clarification?.isEmpty == false ? " (\(clarification!))" : ""
        
        let message = "❌ You must add a row with the ”\(missingPlistKey)“ key to your app‘s plist file\(clarification) and specify the reason why you are requesting access to \(permissionName). This information will be displayed to a user."
        return Permission.Error(.missingPlistKey, message: message)
    }
    
#if ASSETS || !CUSTOM_SETTINGS
    private static func uppercaseFirstLetter(_ value: String) -> String {
        return value.prefix(1).uppercased() + value.dropFirst()
    }
#endif
    
}
