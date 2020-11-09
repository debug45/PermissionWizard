//
//  Panel.swift
//  PermissionKit.Example
//
//  Created by Sergey Moskvin on 09.11.2020.
//

import PermissionKit
import UIKit

class Panel<T: Permission>: UIStackView {
    
    let permission = T.self
    
    // MARK: - Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
        configure()
    }
    
    // MARK: - Internal Functions
    
    func configure() {
        axis = .vertical
        
        alignment = .center
        spacing = 4
    }
    
    func addDefaultButtons(checkStatusAction: @escaping () -> Void, requestAccessAction: @escaping () -> Void) {
        addButton(title: "Check Status", action: checkStatusAction)
        addButton(title: "Request Access", action: requestAccessAction)
    }
    
    func addButton(title: String, action: @escaping () -> Void) {
        let button = PKButton(title: title, primaryAction: action)
        addArrangedSubview(button)
    }
    
    func addSwitch(title: String, withIncreasedOffset: Bool = true) -> UISwitch {
        let switchView = UISwitch()
        addArrangedSubview(switchView)
        
        let titleLabel = UILabel()
        titleLabel.font = .systemFont(ofSize: 15)
        titleLabel.text = title
        
        addArrangedSubview(titleLabel)
        
        if withIncreasedOffset, #available(iOS 11, *) {
            increaseOffset(after: titleLabel)
        }
        
        return switchView
    }
    
    @available(iOS 11, *)
    func increaseOffset(after targetView: UIView) {
        setCustomSpacing(32, after: targetView)
    }
    
    func notify(_ message: String) {
        let sender = String(describing: permission)
        print("\(sender): \(message)")
    }
    
}
