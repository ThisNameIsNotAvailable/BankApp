//
//  OnboardingViewController.swift
//  BankApp
//
//  Created by Alex on 27/11/2022.
//

import UIKit

class OnboardingView: UIView {

    private let stackView = UIStackView()
    private let label = UILabel()
    private let imageView = UIImageView()
    private let doneButton = UIButton(type: .system)
    
    private let titleText: String
    private let imageName: String
    private let isDoneButtonPresent: Bool
    
    weak var delegate: OnboardingContainerViewControllerDelegate?
    
    init(titleText: String, imageName: String, isDoneButtonPresent: Bool = false) {
        self.titleText = titleText
        self.imageName = imageName
        self.isDoneButtonPresent = isDoneButtonPresent
        super.init(frame: .zero)
        backgroundColor = .systemBackground
        addSubview(stackView)
        style()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension OnboardingView {
    private func style() {
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = 20
        stackView.axis = .vertical
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: imageName)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .preferredFont(forTextStyle: .title3)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.text = titleText
        
        if isDoneButtonPresent {
            doneButton.translatesAutoresizingMaskIntoConstraints = false
            doneButton.setTitle("Done", for: [])
            doneButton.addTarget(self, action: #selector(didTapDone), for: .primaryActionTriggered)
            doneButton.tintColor = .label
            doneButton.setTitleColor(.systemBackground, for: [])
            doneButton.configuration = .filled()
            addSubview(doneButton)
        }
    }
    
    private func layout() {
        stackView.addArrangedSubview(imageView)
        stackView.addArrangedSubview(label)
        
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: centerYAnchor),
            stackView.leadingAnchor.constraint(equalToSystemSpacingAfter: leadingAnchor, multiplier: 1),
            trailingAnchor.constraint(equalToSystemSpacingAfter: stackView.trailingAnchor, multiplier: 1)
        ])
        
        if isDoneButtonPresent {
            NSLayoutConstraint.activate([
                trailingAnchor.constraint(equalToSystemSpacingAfter: doneButton.trailingAnchor, multiplier: 2),
                safeAreaLayoutGuide.bottomAnchor.constraint(equalToSystemSpacingBelow: doneButton.bottomAnchor, multiplier: 2)
            ])
        }
    }
}

extension OnboardingView {
    @objc private func didTapDone() {
        delegate?.didFinishOnboarding()
    }
}
