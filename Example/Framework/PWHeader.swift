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
    
    var icon: UIImage? {
        get {
            return iconView.image
        } set {
            iconView.image = newValue
        }
    }
    
    var title: String? {
        get {
            return titleLabel.text
        } set {
            titleLabel.text = newValue
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
