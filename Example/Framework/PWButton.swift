//
//  PWButton.swift
//  PermissionWizard
//
//  Created by Sergey Moskvin on 09.11.2020.
//

import UIKit

final class PWButton: UIControl {
    
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
    
    var title: String? {
        didSet {
            titleLabel.text = title
        }
    }
    
    var contentView: UIView? {
        willSet {
            contentView?.removeFromSuperview()
        }
        
        didSet {
            guard let contentView = contentView else {
                return
            }
            
            contentView.translatesAutoresizingMaskIntoConstraints = false
            addSubview(contentView)
            
            NSLayoutConstraint.activate([
                contentView.leadingAnchor.constraint(equalTo: leadingAnchor),
                contentView.trailingAnchor.constraint(equalTo: trailingAnchor),
                
                contentView.topAnchor.constraint(equalTo: topAnchor),
                contentView.bottomAnchor.constraint(equalTo: bottomAnchor)
            ])
        }
    }
    
    var action: () -> Void = { }
    
    // MARK: - Overriding
    
    override var isHighlighted: Bool {
        didSet {
            let duration: TimeInterval = isHighlighted ? 0 : 0.25
            
            UIView.animate(withDuration: duration, delay: 0, options: [.allowUserInteraction, .beginFromCurrentState], animations: {
                self.titleLabel.alpha = self.isHighlighted ? 0.5 : 1
                self.contentView?.alpha = self.titleLabel.alpha
            }, completion: nil)
        }
    }
    
    // MARK: - Private Functions
    
    private func configure() {
        titleLabel.textColor = tintColor
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            titleLabel.topAnchor.constraint(equalTo: topAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        let selector = #selector(didTouchUpInside)
        addTarget(self, action: selector, for: .touchUpInside)
    }
    
    @objc private func didTouchUpInside() {
        action()
    }
    
}
