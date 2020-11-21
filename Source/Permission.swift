//
//  Permission.swift
//  PermissionWizard
//
//  Created by Sergey Moskvin on 03.10.2020.
//

import UIKit

public class Permission {
    
    private static let iconCornerRadius: CGFloat = 7
    
    private static let iconBorderWidth: CGFloat = 1
    private static let iconBorderColor = UIColor.black.withAlphaComponent(0.1)
    
    // MARK: - Global Settings
    
    /**
     The dispatch queue used to invoke all completion blocks

     In some cases default system API may return a result in a different dispatch queue. Instead of risking a crash and manual queue management, you can ask to always invoke completion blocks in a preferred queue.

     # By Default
     `DispatchQueue.main`
    */
    public static var preferredQueue: DispatchQueue? = .main
    
    // MARK: - Base Properties
    
    /**
     Returns a string that can be used in your UI as the permission type title name

     # Examples
     `Bluetooth, Face ID, Microphone, Speech Recognition`
    */
    public class var titleName: String {
        return String(describing: self).capitalized
    }
    
    /**
     Returns a string that can be used in your UI as the permission type context name

     # Examples
     `Bluetooth, Face ID, microphone, speech recognition`
    */
    public class var contextName: String { .init(describing: self) }
    
    class var shouldBorderIcon: Bool { false }
    
    // MARK: - Public Functions
    
#if ICONS || !CUSTOM_SETTINGS
    /**
     Returns an image representing the permission type for your UI

     All provided icons are native, the same as displayed in the system preferences

     - Parameter squircle: A flag indicating whether the image must be styled like in the system preferences
     - Parameter screen: A screen where the image will be displayed. It used to ensure proper scaling.
    */
    public class func getIcon(squircle: Bool = true, for screen: UIScreen = .main) -> UIImage? {
        var bundle = Bundle(for: self)
        
#if !EXAMPLE
        guard let url = bundle.url(forResource: "Icons", withExtension: "bundle") else {
            return nil
        }
        
        bundle = Bundle(url: url) ?? bundle
#endif
        
        guard var icon = UIImage(named: titleName, in: bundle, compatibleWith: nil) else {
            return nil
        }
        
        if squircle {
            var frame = CGRect(origin: .zero, size: icon.size)
            UIGraphicsBeginImageContextWithOptions(frame.size, false, screen.scale)
            
            var path = UIBezierPath(roundedRect: frame, cornerRadius: iconCornerRadius)
            path.addClip()
            
            icon.draw(in: frame)
            
            if #available(iOS 11, *), shouldBorderIcon {
                let borderWidth = iconBorderWidth / screen.scale
                frame = frame.insetBy(dx: borderWidth / 2, dy: borderWidth / 2)
                
                path = UIBezierPath(roundedRect: frame, cornerRadius: iconCornerRadius)
                path.lineWidth = borderWidth
                
                iconBorderColor.setStroke()
                path.stroke()
            }
            
            icon = UIGraphicsGetImageFromCurrentImageContext() ?? icon
            UIGraphicsEndImageContext()
        }
        
        return icon
    }
#endif
    
}
