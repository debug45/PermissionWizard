//
//  LocalNetwork.swift
//  PermissionKit
//
//  Created by Sergey Moskvin on 31.10.2020.
//

#if LOCAL_NETWORK || !CUSTOM_SETTINGS

import Network

@available(iOS 14, *)
public extension Permission {
    
    final class localNetwork: Permission {
        
        public override class var titleName: String { "Local Network" }
        public override class var contextName: String { titleName.lowercased() }
        
        public override class var usageDescriptionPlistKey: String? { "NSLocalNetworkUsageDescription" }
        
        // MARK: - Public Functions
        
        public class func requestAccess(servicePlistKey: String) {
            guard Utils.checkIsAppConfiguredForLocalNetworkAccess(servicePlistKey: servicePlistKey) else {
                return
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
