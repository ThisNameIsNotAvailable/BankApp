//
//  DummyViewController.swift
//  BankApp
//
//  Created by Alex on 27/11/2022.
//

import UIKit

class DummyViewController: UIViewController {
    
    private let stackView = UIStackView()
    private let label = UILabel()
    private let logoutButton = UIButton(type: .system)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        style()
        layout()
    }
}

extension DummyViewController {
    private func style() {
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 20
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Welcome"
        label.font = .preferredFont(forTextStyle: .title2)
        
        logoutButton.translatesAutoresizingMaskIntoConstraints = false
        logoutButton.setTitle("Log Out", for: [])
//        logoutButton.configuration = .filled()
//        logoutButton.addTarget(self, action: #selector(didTapLogOut), for: .touchUpInside)
    }
    
    private func layout() {
        view.addSubview(stackView)
        stackView.addArrangedSubview(label)
        stackView.addArrangedSubview(logoutButton)
        
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
}
