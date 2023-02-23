//
//  Panel.swift
//  PermissionWizard
//
//  Created by Sergei Moskvin on 09.11.2020.
//

import PermissionWizard
import UIKit

class Panel<T: Permission.SupportedType>: UIStackView {
    
    // MARK: Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
        configure()
    }
    
    // MARK: Internal Properties
    
    let permission = T.self
    
    // MARK: Internal Functions
    
    func configure() {
        axis = .vertical
        
        alignment = .center
        spacing = 12
    }
    
    func addDefaultButtons(checkStatusAction: @escaping () -> Void, requestAccessAction: @escaping () -> Void) {
        addButton(title: "Check Status", action: checkStatusAction)
        addButton(title: "Request Access", action: requestAccessAction)
    }
    
    func addButton(title: String, action: @escaping () -> Void) {
        let button = PWButton()
        
        button.title = title
        button.action = action
        
        addArrangedSubview(button)
    }
    
    func addSwitch(title: String, isOn: Bool = false, withIncreasedOffset: Bool = true) -> UISwitch {
        let switchView = UISwitch()
        switchView.isOn = isOn
        
        addArrangedSubview(switchView)
        setCustomSpacing(8, after: switchView)
        
        let titleLabel = UILabel()
        titleLabel.font = .systemFont(ofSize: 15)
        titleLabel.text = title
        
        addArrangedSubview(titleLabel)
        
        if withIncreasedOffset {
            addSeparatingOffset()
        }
        
        return switchView
    }
    
    func addSeparatingOffset() {
        guard let lastView = arrangedSubviews.last else {
            return
        }
        
        setCustomSpacing(36, after: lastView)
    }
    
    func notifyAboutRequestInferiority() {
        notify("⚠️ The ”requestAccess“ does not support returning of a result, use the status check method if necessary")
    }
    
    func notify(_ message: String) {
        let sender = String(describing: permission)
        print("\(sender): \(message)")
    }
    
}
