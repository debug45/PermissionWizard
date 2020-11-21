//
//  Utils.swift
//  PermissionWizard
//
//  Created by Sergey Moskvin on 14.10.2020.
//

final class Utils {
    
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
    
    static func checkIsAppConfigured(for permission: Permission.Type, usageDescriptionsPlistKeys: [String]) throws {
        for plistKey in usageDescriptionsPlistKeys {
            let value = Bundle.main.object(forInfoDictionaryKey: plistKey) as? String
            
            if value?.isEmpty != false {
                throw createInvalidAppConfigurationError(missingPlistKey: plistKey, permissionName: permission.contextName)
            }
        }
    }
    
    static func checkIsAppConfigured(for permission: Permission.Type, usageDescriptionPlistKey: String? = nil) throws {
        guard let plistKey = usageDescriptionPlistKey else {
            return
        }
        
        try checkIsAppConfigured(for: permission, usageDescriptionsPlistKeys: [plistKey])
    }
    
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
    
    @available(iOS 14, *)
    static func checkIsAppConfiguredForTemporaryPreciseLocationAccess(purposePlistKey: String) throws {
        let dictionaryKey = "NSLocationTemporaryUsageDescriptionDictionary"
        
        if let dictionary = Bundle.main.object(forInfoDictionaryKey: dictionaryKey) as? [String: String], dictionary[purposePlistKey]?.isEmpty == false {
            return
        }
        
        let clarification = "to a nested dictionary with the key ”\(dictionaryKey)“"
        throw createInvalidAppConfigurationError(missingPlistKey: purposePlistKey, permissionName: "temporary precise location", clarification: clarification)
    }
    
    // MARK: - Private Functions
    
    private static func createInvalidAppConfigurationError(missingPlistKey: String, permissionName: String, clarification: String? = nil) -> PWError {
        let clarification = clarification?.isEmpty == false ? " (\(clarification!))" : ""
        
        let message = "❌ You must add a row with the ”\(missingPlistKey)“ key to your app‘s plist file\(clarification) and specify the reason why you are requesting access to \(permissionName). This information will be displayed to a user."
        return PWError(.missingPlistKey, message: message)
    }
    
}
