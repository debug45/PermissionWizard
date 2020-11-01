//
//  ViewController.swift
//  PermissionKit.Example
//
//  Created by Sergey Moskvin on 03.10.2020.
//

import PermissionKit
import UIKit

final class ViewController: UIViewController {
    
    @IBOutlet private weak var bluetoothButton: UIButton!
    @IBOutlet private weak var calendarsButton: UIButton!
    @IBOutlet private weak var cameraButton: UIButton!
    @IBOutlet private weak var contactsButton: UIButton!
    @IBOutlet private weak var faceIDButton: UIButton!
    @IBOutlet private weak var healthButton: UIButton!
    @IBOutlet private weak var homeButton: UIButton!
    @IBOutlet private weak var localNetworkButton: UIButton!
    @IBOutlet private weak var locationButton: UIButton!
    @IBOutlet private weak var microphoneButton: UIButton!
    @IBOutlet private weak var motionButton: UIButton!
    @IBOutlet private weak var musicButton: UIButton!
    @IBOutlet private weak var notificationsButton: UIButton!
    @IBOutlet private weak var photosButton: UIButton!
    @IBOutlet private weak var remindersButton: UIButton!
    @IBOutlet private weak var speechRecognitionButton: UIButton!
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let systemVersion = UIDevice.current.systemVersion
        
        bluetoothButton.isHidden = systemVersion.compare("13.1", options: .numeric) == .orderedAscending
        faceIDButton.isHidden = systemVersion.compare("11", options: .numeric) == .orderedAscending
        homeButton.isHidden = systemVersion.compare("13", options: .numeric) == .orderedAscending
        localNetworkButton.isHidden = systemVersion.compare("14", options: .numeric) == .orderedAscending
        motionButton.isHidden = systemVersion.compare("11", options: .numeric) == .orderedAscending
        musicButton.isHidden = systemVersion.compare("9.3", options: .numeric) == .orderedAscending
        notificationsButton.isHidden = systemVersion.compare("10", options: .numeric) == .orderedAscending
        speechRecognitionButton.isHidden = systemVersion.compare("10", options: .numeric) == .orderedAscending
    }
    
    // MARK: - User Interaction
    
    @IBAction func buttonDidPress(_ sender: UIButton) {
        var permission: Unifiable.Type?
        
        switch sender {
            case bluetoothButton:
                if #available(iOS 13.1, *) {
                    permission = Permission.bluetooth.self
                }
            case calendarsButton:
                permission = Permission.calendars.self
            case cameraButton:
                permission = Permission.camera.self
            case contactsButton:
                permission = Permission.contacts.self
            case faceIDButton:
                if #available(iOS 11, *) {
                    permission = Permission.faceID.self
                }
            case healthButton:
                permission = Permission.health.self
            case homeButton:
                if #available(iOS 13, *) {
                    permission = Permission.home.self
                }
            case localNetworkButton:
                if #available(iOS 14, *) {
                    permission = Permission.localNetwork.self
                }
            case locationButton:
                permission = Permission.location.self
            case microphoneButton:
                permission = Permission.microphone.self
            case motionButton:
                if #available(iOS 11, *) {
                    permission = Permission.motion.self
                }
            case musicButton:
                permission = Permission.music.self
            case notificationsButton:
                if #available(iOS 10, *) {
                    permission = Permission.notifications.self
                }
            case photosButton:
                permission = Permission.photos.self
            case remindersButton:
                permission = Permission.reminders.self
            case speechRecognitionButton:
                if #available(iOS 10, *) {
                    permission = Permission.speechRecognition.self
                }
            
            default:
                break
        }
        
        if let permission = permission {
            showMenu(for: permission, customer: sender)
        }
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
        
        let alertController = UIAlertController(title: title, message: nil, preferredStyle: .alert)
        
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
