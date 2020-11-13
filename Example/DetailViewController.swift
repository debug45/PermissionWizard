//
//  DetailViewController.swift
//  PermissionWizard
//
//  Created by Sergey Moskvin on 09.11.2020.
//

import PermissionWizard
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
        let header = PWHeader()
        header.permission = permission
        
        navigationItem.titleView = header
        
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
                guard #available(iOS 11, *) else {
                    break
                }
                
                switch permission {
                    case is Permission.faceID.Type:
                        panel = FaceIDPanel()
                    case is Permission.motion.Type:
                        panel = MotionPanel()
                    
                    default:
                        if #available(iOS 13.1, *) {
                            if permission is Permission.bluetooth.Type {
                                panel = BluetoothPanel()
                            } else {
                                if #available(iOS 14, *), permission is Permission.localNetwork.Type {
                                    panel = LocalNetworkPanel()
                                }
                            }
                        }
                        
                        if #available(iOS 13, macCatalyst 14, *), permission is Permission.home.Type {
                            panel = HomePanel()
                        }
                }
        }
        
        if let panel = panel {
            panel.translatesAutoresizingMaskIntoConstraints = false
            scrollView.addSubview(panel)
            
            NSLayoutConstraint.activate([
                panel.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
                panel.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
                
                panel.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 32),
                panel.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -32),
                
                panel.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
            ])
        }
    }
    
}
