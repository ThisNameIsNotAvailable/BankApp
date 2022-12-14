//
//  AccountSummaryHeaderView.swift
//  BankApp
//
//  Created by Alex on 30/11/2022.
//

import UIKit

class AccountSummaryHeaderView: UIView {
    @IBOutlet var contentView: UIView!
    private let shakeyBell = ShakeyBellView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: UIView.noIntrinsicMetric, height: 144)
    }
    
    private func commonInit() {
        let bundle = Bundle(for: AccountSummaryHeaderView.self)
        bundle.loadNibNamed("AccountSummaryHeaderView", owner: self)
        addSubview(contentView)
        contentView.backgroundColor = appColor
        
        contentView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: topAnchor),
            contentView.bottomAnchor.constraint(equalTo: bottomAnchor),
            contentView.leadingAnchor.constraint(equalTo: leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
        setUpShakeyBell()
    }
    
    private func setUpShakeyBell() {
        shakeyBell.translatesAutoresizingMaskIntoConstraints = false
        addSubview(shakeyBell)
        
        NSLayoutConstraint.activate([
            shakeyBell.trailingAnchor.constraint(equalTo: trailingAnchor),
            shakeyBell.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}

