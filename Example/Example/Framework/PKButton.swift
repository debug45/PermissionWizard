//
//  PKButton.swift
//  PermissionKit.Example
//
//  Created by Sergey Moskvin on 09.11.2020.
//

import UIKit

final class PKButton: UIButton {
    
    private var primaryAction: () -> Void = { }
    
    // MARK: - Life Cycle
    
    convenience init(title: String, primaryAction: @escaping () -> Void) {
        self.init(type: .system)
        
        setTitle(title, for: .normal)
        self.primaryAction = primaryAction
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configure()
    }
    
    // MARK: - Private Functions
    
    private func configure() {
        let selector = #selector(primaryActionDidTrigger)
        addTarget(self, action: selector, for: .primaryActionTriggered)
    }
    
    @objc private func primaryActionDidTrigger() {
        primaryAction()
    }
    
}
