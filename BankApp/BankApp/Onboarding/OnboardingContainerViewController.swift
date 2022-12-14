//
//  OnboardingContainerViewController.swift
//  BankApp
//
//  Created by Alex on 27/11/2022.
//

import UIKit

protocol OnboardingContainerViewControllerDelegate: AnyObject {
    func didFinishOnboarding()
}
class OnboardingContainerViewController: UIViewController {
    private let scrollView = UIScrollView()
    private let stackViewContainer = UIStackView()
    var pages = [UIView]()
    
    private let closeButton = UIButton(type: .system)
    private let pageControl = UIPageControl()
    
    weak var delegate: OnboardingContainerViewControllerDelegate?
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        
        let page1 = OnboardingView(titleText: "Bankey is faster, easier to use, and has a brand new look and feel that will make you feel like you are back in 1989.", imageName: "delorean")
        let page2 = OnboardingView(titleText: "Move your money around the world quickly and securely.", imageName: "world")
        let page3 = OnboardingView(titleText: "Learn more at www.bankey.com.", imageName: "thumbs", isDoneButtonPresent: true)
        
        pages.append(page1)
        pages.append(page2)
        pages.append(page3)
        
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        style()
        setup()
        layout()
        
        guard let page = pages[2] as? OnboardingView else{
            return
        }
        
        page.delegate = delegate
    }
}

extension OnboardingContainerViewController {
    private func style() {
        
        scrollView.delaysContentTouches = false
        scrollView.delegate = self
        scrollView.isPagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        view.addSubview(scrollView)
        
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        pageControl.currentPage = 0
        pageControl.numberOfPages = pages.count
        pageControl.backgroundStyle = .prominent
        pageControl.currentPageIndicatorTintColor = .label
        pageControl.allowsContinuousInteraction = true
        
        pageControl.addTarget(self, action: #selector(changePage), for: .valueChanged)
        view.addSubview(pageControl)
        
        stackViewContainer.translatesAutoresizingMaskIntoConstraints = false
        stackViewContainer.distribution = .equalSpacing
        stackViewContainer.axis = .horizontal
        scrollView.addSubview(stackViewContainer)
        
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        closeButton.setTitle("Close", for: [])
        closeButton.addTarget(self, action: #selector(didTapClose), for: .primaryActionTriggered)
        closeButton.tintColor = .label
        closeButton.setTitleColor(.systemBackground, for: [])
        closeButton.configuration = .filled()
        view.addSubview(closeButton)
    }
    
    private func setup() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
          scrollView.topAnchor.constraint(equalTo: self.view.topAnchor),
          scrollView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
          scrollView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
          scrollView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            stackViewContainer.topAnchor.constraint(equalTo: scrollView.topAnchor),
            stackViewContainer.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            stackViewContainer.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            stackViewContainer.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor)
        ])
        
        pages.forEach { [weak self] myView in
            guard let strongSelf = self else {
                return
            }
            strongSelf.stackViewContainer.addArrangedSubview(myView)
            myView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                myView.widthAnchor.constraint(equalTo: strongSelf.view.widthAnchor),
                myView.heightAnchor.constraint(equalTo: strongSelf.view.heightAnchor)
            ])
        }
    }
    
    private func layout() {
        NSLayoutConstraint.activate([
            // Close button
            closeButton.topAnchor.constraint(equalToSystemSpacingBelow: view.safeAreaLayoutGuide.topAnchor, multiplier: 2),
            closeButton.leadingAnchor.constraint(equalToSystemSpacingAfter: view.leadingAnchor, multiplier: 2),
            
            pageControl.heightAnchor.constraint(equalToConstant: 30),
            pageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            view.safeAreaLayoutGuide.bottomAnchor.constraint(equalToSystemSpacingBelow: pageControl.bottomAnchor, multiplier: 2)
        ])
    }
    
    @objc private func changePage() {
        scrollView.setContentOffset(CGPoint(x: pageControl.currentPage * Int(view.frame.width), y: 0), animated: true)
    }
}

//MARK: - Actions
extension OnboardingContainerViewController {
    @objc private func didTapClose() {
        delegate?.didFinishOnboarding()
        
    }
}

extension OnboardingContainerViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        pageControl.currentPage = Int(scrollView.contentOffset.x) / Int(scrollView.frame.width)
        if scrollView.contentOffset.x == 0{
            pageControl.currentPage = 0
        }else if scrollView.contentOffset.x == view.frame.width {
            pageControl.currentPage = 1
        } else if scrollView.contentOffset.x == 2 * view.frame.width {
            pageControl.currentPage = 2
        }
    }
}
