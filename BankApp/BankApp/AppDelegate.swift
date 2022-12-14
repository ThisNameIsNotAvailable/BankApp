//
//  AppDelegate.swift
//  BankApp
//
//  Created by Alex on 26/11/2022.
//

import UIKit

let appColor: UIColor = .systemTeal
@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    let loginVC = LoginViewController()
    let onboardingVC = OnboardingContainerViewController()
    let mainVC = MainViewController()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        
        let pageControl = UIPageControl.appearance()
        pageControl.currentPageIndicatorTintColor = .label
        pageControl.pageIndicatorTintColor = .tertiaryLabel
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        window?.backgroundColor = .systemBackground
        loginVC.delegate = self
        onboardingVC.delegate = self
        mainVC.setStatusBar()
        UINavigationBar.appearance().isTranslucent = false
        UINavigationBar.appearance().backgroundColor = appColor
        window?.rootViewController = loginVC
        return true
    }
}

extension AppDelegate: LoginViewControllerDelegate {
    func didLogin() {
        if !LocalState.hasOnboarded {
            setRootViewController(vc: onboardingVC)
        } else {
            setRootViewController(vc: mainVC)
        }
    }
}

extension AppDelegate: OnboardingContainerViewControllerDelegate {
    func didFinishOnboarding() {
        LocalState.hasOnboarded = true
        setRootViewController(vc: mainVC)
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
