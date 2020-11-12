//
//  PWHeader.swift
//  PermissionWizard
//
//  Created by Sergey Moskvin on 11.11.2020.
//

import PermissionWizard
import UIKit

final class PWHeader: UIView {
    
    private let iconView = UIImageView()
    private let titleLabel = UILabel()
    
    // MARK: - Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configure()
    }
    
    // MARK: - Properties
    
    var permission: Permission.Type? {
        didSet {
            guard let permission = permission else {
                return
            }
            
            iconView.image = permission.icon
            
            if permission.shouldBorderIcon, #available(iOS 11, *) {
                iconView.layer.borderWidth = 1 / (window?.screen.scale ?? 1)
                iconView.layer.borderColor = UIColor(named: "Border Color")?.cgColor
            }
            
            titleLabel.text = permission.titleName
        }
    }
    
    var titleColor: UIColor {
        get {
            return titleLabel.textColor
        } set {
            titleLabel.textColor = newValue
        }
    }
    
    // MARK: - Private Functions
    
    private func configure() {
        iconView.layer.cornerRadius = 6
        iconView.clipsToBounds = true
        
        iconView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(iconView)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            iconView.leadingAnchor.constraint(equalTo: leadingAnchor),
            
            iconView.topAnchor.constraint(equalTo: topAnchor),
            iconView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            titleLabel.leadingAnchor.constraint(equalTo: iconView.trailingAnchor, constant: 8),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
        
        isUserInteractionEnabled = false
    }
    
}
