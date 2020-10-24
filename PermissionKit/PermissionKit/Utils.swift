//
//  Utils.swift
//  PermissionKit
//
//  Created by Sergey Moskvin on 14.10.2020.
//

final class Utils {
    
    // MARK: - Internal Functions
    
    static func checkIsAppConfigured(for permission: Base.Type, usageDescriptionsPlistKeys: [String]? = nil) -> Bool {
        var plistKeys = usageDescriptionsPlistKeys
        
        if plistKeys == nil {
            if let plistKey = permission.usageDescriptionPlistKey {
                plistKeys = [plistKey]
            } else {
                return true
            }
        }
        
        var result = true
        
        for plistKey in (plistKeys ?? []) {
            let value = Bundle.main.object(forInfoDictionaryKey: plistKey) as? String
            
            guard value?.isEmpty != false else {
                continue
            }
            
            let permissionName = String(describing: permission)
            notifyAboutInvalidAppConfiguration(missingPlistKey: plistKey, permissionName: permissionName)
            
            result = false
        }
        
        return result
    }
    
    static func checkIsAppConfiguredForTemporaryPreciseLocationAccess(purposePlistKey: String) -> Bool {
        let dictionaryKey = "NSLocationTemporaryUsageDescriptionDictionary"
        
        var result = false
        
        if let dictionary = Bundle.main.object(forInfoDictionaryKey: dictionaryKey) as? [String: String] {
            result = dictionary[purposePlistKey]?.isEmpty == false
        }
        
        if !result {
            let clarification = "to a nested dictionary with the key ”\(dictionaryKey)“"
            notifyAboutInvalidAppConfiguration(missingPlistKey: purposePlistKey, permissionName: "temporary precise location", clarification: clarification)
        }
        
        return result
    }
    
    // MARK: - Private Functions
    
    private static func notifyAboutInvalidAppConfiguration(missingPlistKey: String, permissionName: String, clarification: String? = nil) {
        let clarification = clarification?.isEmpty == false ? " (\(clarification!))" : ""
        print("❌ You must add a row with the ”\(missingPlistKey)“ key to your app‘s plist file\(clarification) and specify the reason why you are requesting access to \(permissionName). This information will be displayed to a user.")
    }
    
}
