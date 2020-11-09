//
//  DetailViewController.swift
//  PermissionKit.Example
//
//  Created by Sergey Moskvin on 09.11.2020.
//

import PermissionKit
import UIKit

final class DetailViewController: UIViewController {
    
    @IBOutlet private weak var scrollView: UIScrollView!
    
    var permission: Permission.Type?
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    // MARK: - Private Functions
    
    private func configure() {
        title = permission?.titleName
        
        var panel: UIStackView?
        
        switch permission {
            case is Permission.calendars.Type:
                panel = CalendarsPanel()
            case is Permission.camera.Type:
                panel = CameraPanel()
            case is Permission.contacts.Type:
                panel = ContactsPanel()
            
#if !targetEnvironment(macCatalyst)
            case is Permission.health.Type:
                panel = HealthPanel()
#endif
            
            case is Permission.location.Type:
                panel = LocationPanel()
            case is Permission.microphone.Type:
                panel = MicrophonePanel()
            case is Permission.music.Type:
                panel = MusicPanel()
            case is Permission.notifications.Type:
                panel = NotificationsPanel()
            case is Permission.photos.Type:
                panel = PhotosPanel()
            case is Permission.reminders.Type:
                panel = RemindersPanel()
            case is Permission.speechRecognition.Type:
                panel = SpeechRecognitionPanel()
            
            default:
                if #available(iOS 11, *) {
                    switch permission {
                        case is Permission.faceID.Type:
                            panel = FaceIDPanel()
                        case is Permission.motion.Type:
                            panel = MotionPanel()
                        
                        default:
                            if #available(iOS 13, *) {
#if !targetEnvironment(macCatalyst)
                                if permission is Permission.home.Type {
                                    panel = HomePanel()
                                }
#endif
                                
                                if panel == nil, #available(iOS 13.1, *) {
                                    if permission is Permission.bluetooth.Type {
                                        panel = BluetoothPanel()
                                    } else {
                                        if #available(iOS 14, *), permission is Permission.localNetwork.Type {
                                            panel = LocalNetworkPanel()
                                        }
                                    }
                                }
                            }
                    }
                }
        }
        
        if let panel = panel {
            panel.translatesAutoresizingMaskIntoConstraints = false
            scrollView.addSubview(panel)
            
            NSLayoutConstraint.activate([
                panel.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
                panel.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
                
                panel.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 16),
                panel.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -32),
                
                panel.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
            ])
        }
    }
    
}
