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
    
    @IBAction func calendarsButtonDidPress(_ sender: UIButton) {
        showMenu(for: Permission.calendars.self, customer: sender)
    }
    
    @IBAction func contactsButtonDidPress(_ sender: UIButton) {
        showMenu(for: Permission.contacts.self, customer: sender)
    }
    
    @IBAction func remindersButtonDidPress(_ sender: UIButton) {
        showMenu(for: Permission.reminders.self, customer: sender)
    }
    
    // MARK: - Private Functions
    
    private func showMenu(for permission: Unifiable.Type, customer: UIButton) {
        guard let title = customer.title(for: .normal) else {
            return
        }
        
        let alertController = UIAlertController(title: title, message: nil, preferredStyle: .actionSheet)
        
        let checkStatusAction = UIAlertAction(title: "Check status", style: .default) { _ in
            permission.checkStatus { status in
                print("\(title): \(status)")
            }
        }
        
        alertController.addAction(checkStatusAction)
        
        let requestAccessAction = UIAlertAction(title: "Request access", style: .default) { _ in
            permission.requestAccess { status in
                print("\(title): \(status)")
            }
        }
        
        alertController.addAction(requestAccessAction)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
}
