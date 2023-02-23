//
//  LocalNetwork.Agent.swift
//  PermissionWizard
//
//  Created by Sergei Moskvin on 24.01.2021.
//

#if (LOCAL_NETWORK || !CUSTOM_SETTINGS) && !targetEnvironment(macCatalyst)

@available(iOS 14, *)
extension Permission.localNetwork {
    
    final class Agent: Permission.SupportedType.Agent<NetService, Status>, NetServiceDelegate {
        
        private var response: Status?
        
        // MARK: Life Cycle
        
        override init(_ manager: NetService, callback: @escaping (Status) -> Void) {
            super.init(manager, callback: callback)
            manager.delegate = self
        }
        
        // MARK: Overriding Properties
        
        override var hasDeterminedStatus: Bool {
            return response != nil
        }
        
        // MARK: Overriding Functions
        
        override func handleDeterminedStatus() {
            super.handleDeterminedStatus()
            
            if let response = response {
                invokeCallbacks(with: response)
            }
        }
        
        // MARK: Net Service Delegate
        
        func netServiceDidPublish(_ sender: NetService) {
            response = .granted
            handleDeterminedStatus()
        }
        
        func netServiceDidStop(_ sender: NetService) {
            guard response == nil else {
                return
            }
            
            response = .deniedOrNotDetermined
            handleDeterminedStatus()
        }
        
    }
    
}

#endif
