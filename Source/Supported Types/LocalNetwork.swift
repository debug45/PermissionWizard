//
//  LocalNetwork.swift
//  PermissionWizard
//
//  Created by Sergey Moskvin on 31.10.2020.
//

#if (LOCAL_NETWORK || !CUSTOM_SETTINGS) && !targetEnvironment(macCatalyst)

import Network

@available(iOS 14, *)
public extension Permission {
    
    final class localNetwork: SupportedType {
        
        // MARK: - Overriding Properties
        
        public override class var usageDescriptionPlistKey: String { "NSLocalNetworkUsageDescription" }
        
        override class var contextName: String { "local network" }
        
        // MARK: - Public Functions
        
        /**
         Asks a user for access the permission type

         Due to limitations of default system API, you can not find out a user‘s decision

         - Parameter servicePlistKey: A key of the Bonjour service, access to which you want to request. You must add a row with this key to your app‘s plist file, to a nested array with the key ”NSBonjourServices“.
         - Throws: `Permission.Error`, if something went wrong. For example, your ”Info.plist“ is configured incorrectly.
        */
        public static func requestAccess(servicePlistKey: String) throws {
            try Utils.checkIsAppConfigured(for: localNetwork.self, usageDescriptionPlistKey: usageDescriptionPlistKey)
            
            let serviceArrayPlistKey = "NSBonjourServices"
            
            if let array = Bundle.main.object(forInfoDictionaryKey: serviceArrayPlistKey) as? [String], array.contains(servicePlistKey) { } else {
                let keyParent = (type: "array", ownKey: serviceArrayPlistKey)
                throw Utils.createInvalidAppConfigurationError(permissionName: contextName, missingPlistKey: servicePlistKey, keyParent: keyParent, isTechnicalKey: true)
            }
            
            let serviceDescriptor = NWBrowser.Descriptor.bonjour(type: servicePlistKey, domain: nil)
            let parameters = NWParameters()
            
            let browser = NWBrowser(for: serviceDescriptor, using: parameters)
            browser.stateUpdateHandler = { _ in }
            
            browser.start(queue: .main)
        }
        
    }
    
}

#endif
