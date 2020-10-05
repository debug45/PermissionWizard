//
//  ViewController.swift
//  PermissionKit.Example
//
//  Created by Sergey Moskvin on 03.10.2020.
//

import PermissionKit
import UIKit

final class ViewController: UIViewController {
    
    // MARK: - User Interaction
    
    @IBAction func contactsButtonDidPress(_ sender: Any) {
        showMenu(checkStatus: {
            Permission.contacts.checkStatus { status in
                print("Contacts: \(status)")
            }
        }, requestAccess: {
            Permission.contacts.requestAccess { status in
                print("Contacts: \(status)")
            }
        })
    }
    
    // MARK: - Private Functions
    
    private func showMenu(checkStatus: @escaping () -> Void, requestAccess: @escaping () -> Void) {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .alert)
        
        let checkStatusAction = UIAlertAction(title: "Check status", style: .default) { _ in checkStatus() }
        alertController.addAction(checkStatusAction)
        
        let requestAccessAction = UIAlertAction(title: "Request access", style: .default) { _ in requestAccess() }
        alertController.addAction(requestAccessAction)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
}
