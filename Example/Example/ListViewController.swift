//
//  ListViewController.swift
//  Permission Wizard
//
//  Created by Sergey Moskvin on 03.10.2020.
//

import PermissionWizard
import UIKit

final class ListViewController: UIViewController {
    
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
        configure()
    }
    
    // MARK: - User Interaction
    
    @IBAction func buttonDidPress(_ sender: UIButton) {
        var permission: Permission.Type?
        
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
            
#if !targetEnvironment(macCatalyst)
            case healthButton:
                permission = Permission.health.self
            case homeButton:
                if #available(iOS 13, *) {
                    permission = Permission.home.self
                }
#endif
            
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
                permission = Permission.notifications.self
            case photosButton:
                permission = Permission.photos.self
            case remindersButton:
                permission = Permission.reminders.self
            case speechRecognitionButton:
                permission = Permission.speechRecognition.self
            
            default:
                break
        }
        
        if let permission = permission, let detailViewController = storyboard?.instantiateViewController(withIdentifier: "Selection") as? DetailViewController {
            detailViewController.permission = permission
            navigationController?.pushViewController(detailViewController, animated: true)
        }
    }
    
    // MARK: - Private Functions
    
    private func configure() {
        let systemVersion = UIDevice.current.systemVersion
        
        bluetoothButton.isHidden = systemVersion.compare("13.1", options: .numeric) == .orderedAscending
        faceIDButton.isHidden = systemVersion.compare("11", options: .numeric) == .orderedAscending
        
#if !targetEnvironment(macCatalyst)
        healthButton.isHidden = false
        homeButton.isHidden = systemVersion.compare("13", options: .numeric) == .orderedAscending
#else
        healthButton.isHidden = true
        homeButton.isHidden = true
#endif
        
        localNetworkButton.isHidden = systemVersion.compare("14", options: .numeric) == .orderedAscending
        motionButton.isHidden = systemVersion.compare("11", options: .numeric) == .orderedAscending
        musicButton.isHidden = systemVersion.compare("9.3", options: .numeric) == .orderedAscending
        notificationsButton.isHidden = systemVersion.compare("10", options: .numeric) == .orderedAscending
        speechRecognitionButton.isHidden = systemVersion.compare("10", options: .numeric) == .orderedAscending
    }
    
}
