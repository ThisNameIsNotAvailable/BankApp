//
//  AppDelegate.swift
//  BankApp
//
//  Created by Alex on 26/11/2022.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    let loginVC = LoginViewController()
    let onboardingVC = OnboardingContainerViewController()
    let dummyVC = DummyViewController()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        window?.backgroundColor = .systemBackground
        loginVC.delegate = self
        onboardingVC.delegate = self
        dummyVC.delegate = self
        window?.rootViewController = loginVC
        return true
    }
}

extension AppDelegate: LoginViewControllerDelegate {
    func didLogin() {
        if !LocalState.hasOnboarded {
            setRootViewController(vc: onboardingVC)
        } else {
            setRootViewController(vc: dummyVC)
        }
    }
}

extension AppDelegate: OnboardingContainerViewControllerDelegate {
    func didFinishOnboarding() {
        LocalState.hasOnboarded = true
        setRootViewController(vc: dummyVC)
    }
}

extension AppDelegate: LogoutDelegate {
    func didLogout() {
        setRootViewController(vc: loginVC)
    }
}

extension AppDelegate {
    func setRootViewController(vc: UIViewController, animated: Bool = true) {
        guard animated, let window = window else {
            self.window?.makeKeyAndVisible()
            self.window?.rootViewController = vc
            return
        }
        
        window.rootViewController = vc
        window.makeKeyAndVisible()
        UIView.transition(with: window, duration: 0.3, options: .transitionCrossDissolve, animations: nil)
    }
}
