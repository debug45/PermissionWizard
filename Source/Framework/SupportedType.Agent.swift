//
//  SupportedType.Agent.swift
//  PermissionWizard
//
//  Created by Sergei Moskvin on 05.11.2020.
//

extension Permission.SupportedType {
    
    class Agent<Manager, Status>: NSObject {
        
        private var callbacks: [(Status) -> Void] = []
        
        // MARK: Life Cycle
        
        init(_ manager: Manager, callback: @escaping (Status) -> Void) {
            self.manager = manager
            
            super.init()
            addCallback(callback)
        }
        
        // MARK: Internal Properties
        
        let manager: Manager
        
        var hasDeterminedStatus: Bool {
            return false
        }
        
        // MARK: Internal Functions
        
        func addCallback(_ callback: @escaping (Status) -> Void) {
            callbacks.append(callback)
            
            if hasDeterminedStatus {
                handleDeterminedStatus()
            }
        }
        
        func invokeCallbacks(with status: Status) {
            callbacks.forEach { $0(status) }
            callbacks.removeAll()
        }
        
        func handleDeterminedStatus() { }
        
    }
    
}
