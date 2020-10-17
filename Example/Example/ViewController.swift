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
    
    @IBAction func cameraButtonDidPress(_ sender: UIButton) {
        showMenu(for: Permission.camera.self, customer: sender)
    }
    
    @IBAction func contactsButtonDidPress(_ sender: UIButton) {
        showMenu(for: Permission.contacts.self, customer: sender)
    }
    
    @IBAction func homeButtonDidPress(_ sender: UIButton) {
        showMenu(for: Permission.home.self, customer: sender)
    }
    
    @IBAction func microphoneButtonDidPress(_ sender: UIButton) {
        showMenu(for: Permission.microphone.self, customer: sender)
    }
    
    @IBAction func musicButtonDidPress(_ sender: UIButton) {
        showMenu(for: Permission.music.self, customer: sender)
    }
    
    @IBAction func remindersButtonDidPress(_ sender: UIButton) {
        showMenu(for: Permission.reminders.self, customer: sender)
    }
    
    @IBAction func speechRecognitionButtonDidPress(_ sender: UIButton) {
        showMenu(for: Permission.speechRecognition.self, customer: sender)
    }
    
    // MARK: - Private Functions
    
    private func showMenu(for permission: Unifiable.Type, customer: UIButton) {
        guard let title = customer.title(for: .normal) else {
            return
        }
        
        let notifyAboutResult: (String?) -> Void = { status in
            if let status = status {
                print("\(title): \(status)")
            }
        }
        
        let alertController = UIAlertController(title: title, message: nil, preferredStyle: .actionSheet)
        
        let checkStatusAction = UIAlertAction(title: "Check status", style: .default) { _ in
            permission.checkStatus { notifyAboutResult($0) }
        }
        
        alertController.addAction(checkStatusAction)
        
        let requestAccessAction = UIAlertAction(title: "Request access", style: .default) { _ in
            permission.requestAccess { notifyAboutResult($0) }
        }
        
        alertController.addAction(requestAccessAction)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
}
