//
//  ViewController.swift
//  BankApp
//
//  Created by Alex on 26/11/2022.
//

import UIKit

protocol LoginViewControllerDelegate: AnyObject {
    func didLogin()
}

class LoginViewController: UIViewController {

    private let loginView = LoginView()
    private let signInButton = UIButton(type: .system)
    private let errorMessageLabel = UILabel()
    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()
    
    weak var delegate: LoginViewControllerDelegate?
    
    private var username: String? {
        return loginView.usernameTextField.text
    }
    
    private var password: String? {
        return loginView.passwordTextField.text
    }
    
    var leadingEdgeOnScreen: CGFloat = 16
    var leadingEdgeOffScreen: CGFloat = -1000
    
    var titleLeadingAnchor: NSLayoutConstraint?
    var subtitleLeadingAnchor: NSLayoutConstraint?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        style()
        layout()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        animate()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        signInButton.configuration?.showsActivityIndicator = false
        loginView.usernameTextField.text = ""
        loginView.passwordTextField.text = ""
    }
}

extension LoginViewController {
    private func style() {
        signInButton.translatesAutoresizingMaskIntoConstraints = false
        signInButton.configuration = .filled()
        signInButton.configuration?.imagePadding = 8
        signInButton.setTitle("Sign In", for: [])
        signInButton.addTarget(self, action: #selector(didTapSignIn), for: .touchUpInside)
        
        errorMessageLabel.translatesAutoresizingMaskIntoConstraints = false
        errorMessageLabel.textAlignment = .center
        errorMessageLabel.textColor = .systemRed
        errorMessageLabel.numberOfLines = 0
        errorMessageLabel.isHidden = true
        errorMessageLabel.text = "Error Failure"
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.textAlignment = .center
        titleLabel.font = .systemFont(ofSize: 40, weight: .bold)
        titleLabel.text = "Bankey"
        titleLabel.alpha = 0
        
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        subtitleLabel.textAlignment = .center
        subtitleLabel.numberOfLines = 0
        subtitleLabel.font = .systemFont(ofSize: 24, weight: .regular)
        subtitleLabel.text = "Your premium source for all things banking!"
        subtitleLabel.alpha = 0
    }
    
    private func layout() {
        view.addSubview(titleLabel)
        view.addSubview(subtitleLabel)
        view.addSubview(loginView)
        view.addSubview(signInButton)
        view.addSubview(errorMessageLabel)
        
        NSLayoutConstraint.activate([
            // Login View
            loginView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            loginView.leadingAnchor.constraint(equalToSystemSpacingAfter: view.leadingAnchor, multiplier: 1),
            view.trailingAnchor.constraint(equalToSystemSpacingAfter: loginView.trailingAnchor, multiplier: 1),
            
            // Sign In Button
            signInButton.topAnchor.constraint(equalToSystemSpacingBelow: loginView.bottomAnchor, multiplier: 2),
            signInButton.leadingAnchor.constraint(equalToSystemSpacingAfter: view.leadingAnchor, multiplier: 1),
            view.trailingAnchor.constraint(equalToSystemSpacingAfter: signInButton.trailingAnchor, multiplier: 1),
            
            // Error Label
            errorMessageLabel.topAnchor.constraint(equalToSystemSpacingBelow: signInButton.bottomAnchor, multiplier: 2),
            errorMessageLabel.leadingAnchor.constraint(equalTo: signInButton.leadingAnchor),
            errorMessageLabel.trailingAnchor.constraint(equalTo: signInButton.trailingAnchor),
            
            // Subtitle label
            loginView.topAnchor.constraint(equalToSystemSpacingBelow: subtitleLabel.bottomAnchor, multiplier: 3),
            loginView.trailingAnchor.constraint(equalToSystemSpacingAfter: subtitleLabel.trailingAnchor, multiplier: 1),
            
            // Title Label
            subtitleLabel.topAnchor.constraint(equalToSystemSpacingBelow: titleLabel.bottomAnchor, multiplier: 3),
            titleLabel.trailingAnchor.constraint(equalTo: loginView.trailingAnchor)
            
        ])
        titleLeadingAnchor = titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: leadingEdgeOffScreen)
        titleLeadingAnchor?.isActive = true
        
        subtitleLeadingAnchor = subtitleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: leadingEdgeOffScreen)
        subtitleLeadingAnchor?.isActive = true
    }
}

//MARK: - Actions

extension LoginViewController {
    @objc private func didTapSignIn() {
        errorMessageLabel.isHidden = true
        login()
    }
    
    private func login() {
        guard let username = username, let password = password else {
            assertionFailure("Username or password is nil.")
            return
        }
        
//        if username.isEmpty || password.isEmpty {
//            configureView(with: "Username/password cannot be blank.")
//            return
//        }
        
        if username == "" && password == "" {
            signInButton.configuration?.showsActivityIndicator = true
            delegate?.didLogin()
        } else {
            configureView(with: "Incorrect username/password.")
        }
    }
    
    private func configureView(with message: String) {
        errorMessageLabel.isHidden = false
        errorMessageLabel.text = message
        shakeButton()
    }
    
    private func shakeButton() {
        let animation = CAKeyframeAnimation()
        animation.keyPath = "position.x"
        animation.values = [0, 10, -10, 10, 0]
        animation.keyTimes = [0, 0.16, 0.5, 0.8, 1]
        animation.duration = 0.5
        animation.isAdditive = true
        
        signInButton.layer.add(animation, forKey: "shake")
    }
}

extension LoginViewController {
    private func animate() {
        let animator1 = UIViewPropertyAnimator(duration: 1.5, dampingRatio: 0.75) { [weak self] in
            guard let strongSelf = self else {
                return
            }
            strongSelf.titleLeadingAnchor?.constant = strongSelf.leadingEdgeOnScreen
            strongSelf.view.layoutIfNeeded()
        }
        animator1.startAnimation()
        
        let animator2 = UIViewPropertyAnimator(duration: 1.5, dampingRatio: 0.75) { [weak self] in
            guard let strongSelf = self else {
                return
            }
            strongSelf.subtitleLeadingAnchor?.constant = strongSelf.leadingEdgeOnScreen
            strongSelf.view.layoutIfNeeded()
        }
        animator2.startAnimation(afterDelay: 0.5)
        
        let animator3 = UIViewPropertyAnimator(duration: 1.5, curve: .easeOut) { [weak self] in
            guard let strongSelf = self else {
                return
            }
            strongSelf.titleLabel.alpha = 1
            strongSelf.subtitleLabel.alpha = 1
            strongSelf.view.layoutIfNeeded()
        }
        animator3.startAnimation(afterDelay: 0.5)
    }
}
