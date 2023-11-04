//
//  DetailViewController.swift
//  PermissionWizard
//
//  Created by Sergei Moskvin on 09.11.2020.
//

import PermissionWizard
import UIKit

final class DetailViewController: UIViewController {
    
    @IBOutlet private weak var scrollView: UIScrollView!
    
    // MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    // MARK: Internal Properties
    
    var permission: Permission.SupportedType.Type?
    
    // MARK: Private Functions
    
    private func configure() {
        let isMacCatalystApp = ProcessInfo.processInfo.isMacCatalystApp
        
        if !isMacCatalystApp {
            let header = PWHeader()
            header.title = permission?.getLocalizedName()
            
            if let screen = UIApplication.shared.windows.last?.screen {
                header.icon = permission?.getIcon(for: screen)
            }
            
            navigationItem.titleView = header
        } else {
            navigationItem.title = permission?.getLocalizedName()
        }
        
        var panel: UIStackView?
        
        switch permission {
            case is Permission.calendars.Type:
                panel = CalendarsPanel()
            case is Permission.contacts.Type:
                panel = ContactsPanel()
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
            
#if !targetEnvironment(macCatalyst)
            case is Permission.faceID.Type where !isMacCatalystApp:
                panel = FaceIDPanel()
            case is Permission.health.Type where !isMacCatalystApp:
                panel = HealthPanel()
            case is Permission.motion.Type where !isMacCatalystApp:
                panel = MotionPanel()
            case is Permission.siri.Type where !isMacCatalystApp:
                panel = SiriPanel()
#endif
            
            default:
                if permission is Permission.bluetooth.Type {
                    panel = BluetoothPanel()
                }
                
                if permission is Permission.camera.Type {
                    panel = CameraPanel()
                }
                
                if permission is Permission.home.Type {
                    panel = HomePanel()
                }
                
#if !targetEnvironment(macCatalyst)
                if !isMacCatalystApp {
                    if permission is Permission.localNetwork.Type {
                        panel = LocalNetworkPanel()
                    }
                    
                    if permission is Permission.tracking.Type {
                        panel = TrackingPanel()
                    }
                }
#endif
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
