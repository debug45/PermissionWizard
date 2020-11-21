//
//  Base.Agent.swift
//  PermissionWizard
//
//  Created by Sergey Moskvin on 05.11.2020.
//

extension Permission.Base {
    
    class Agent<Manager, Status>: NSObject {
        
        let manager: Manager
        
        private var callbacks: [(Status) -> Void] = []
        
        // MARK: - Life Cycle
        
        init(_ manager: Manager, callback: @escaping (Status) -> Void) {
            self.manager = manager
            
            super.init()
            addCallback(callback)
        }
        
        // MARK: - Properties
        
        var hasDeterminedStatus: Bool {
            return false
        }
        
        // MARK: - Internal Functions
        
        func addCallback(_ callback: @escaping (Status) -> Void) {
            let callback = Utils.linkToPreferredQueue(callback)
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
