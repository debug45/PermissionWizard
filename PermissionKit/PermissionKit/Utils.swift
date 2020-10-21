//
//  Utils.swift
//  PermissionKit
//
//  Created by Sergey Moskvin on 14.10.2020.
//

final class Utils {
    
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
            guard Bundle.main.object(forInfoDictionaryKey: plistKey) == nil else {
                continue
            }
            
            let permissionName = String(describing: permission)
            print("❌ You must add a row with the ”\(plistKey)“ key to your app‘s plist file and specify the reason why you are requesting access to \(permissionName). This information will be displayed to a user.")
            
            result = false
        }
        
        return result
    }
    
}
