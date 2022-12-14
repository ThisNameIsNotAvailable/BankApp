//
//  UITextFieldSecureToggle.swift
//  BankApp
//
//  Created by Alex on 14/12/2022.
//

import UIKit

let passwordToggleButton = UIButton(type: .custom)

extension UITextField {
    func enableToggleView() {
        passwordToggleButton.setImage(UIImage(systemName: "eye.fill"), for: .normal)
        passwordToggleButton.setImage(UIImage(systemName: "eye.slash.fill"), for: .selected)
        passwordToggleButton.addTarget(self, action: #selector(didToggle), for: .touchUpInside)
        passwordToggleButton.tintColor = .secondaryLabel
        rightView = passwordToggleButton
        rightViewMode = .always
    }
    
    @objc private func didToggle() {
        isSecureTextEntry.toggle()
        passwordToggleButton.isSelected.toggle()
    }
}
