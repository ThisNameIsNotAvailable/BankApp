//
//  AccountSummaryViewController.swift
//  BankApp
//
//  Created by Alex on 29/11/2022.
//

import UIKit

import UIKit

class AccountSummaryViewController: UIViewController {
    
    private let tableView = UITableView()
    private let headerView = AccountSummaryHeaderView(frame: .zero)
    private var accountCellViewModels = [AccountSummaryCell.ViewModel]()
    lazy var logoutButton: UIBarButtonItem = {
        let button = UIBarButtonItem(title: "Log Out", style: .plain, target: self, action: #selector(didTapLogOut))
        button.tintColor = .label
        return button
    }()
    var profile: Profile?
    var accounts = [Account]()
    
    var headerViewModel = AccountSummaryHeaderView.ViewModel(welcomeMessage: "Welcome", name: "", date: Date())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        setup()
        setupTableHeaderView()
        fetchDataAndLoadViews()
    }
    
    @objc private func didTapLogOut() {
        NotificationCenter.default.post(Notification(name: .logout))
    }
}

extension AccountSummaryViewController {
    private func setup() {
        setUpTableView()
        navigationItem.rightBarButtonItem = logoutButton
    }
    
    private func setUpTableView() {
        view.addSubview(tableView)
        tableView.backgroundColor = appColor
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(AccountSummaryCell.self, forCellReuseIdentifier: "AccountSummaryCell")
        tableView.rowHeight = AccountSummaryCell.height
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
    }
    
    private func setupTableHeaderView() {
        var size = headerView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
        size.width = UIScreen.main.bounds.width
        headerView.frame.size = size
        
        tableView.tableHeaderView = headerView
    }
}

extension AccountSummaryViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        accountCellViewModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: AccountSummaryCell.identifier, for: indexPath) as? AccountSummaryCell else {
            return UITableViewCell()
        }
        
        cell.configure(accountCellViewModels[indexPath.row])
        
        return cell
    }
}

// MARK: - Networking
extension AccountSummaryViewController {
    private func fetchDataAndLoadViews() {
        
        fetchProfile(forUserId: "1") { result in
            switch result {
            case .success(let profile):
                self.profile = profile
                DispatchQueue.main.async {
                    self.configureTableHeaderView(with: profile)
                    self.tableView.reloadData()
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }

        fetchAccounts(forUserId: "1") { result in
            switch result {
            case .success(let accounts):
                self.accounts = accounts
                DispatchQueue.main.async {
                    self.configureTableViewCells(with: accounts)
                    self.tableView.reloadData()
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    private func configureTableHeaderView(with profile: Profile) {
        let vm = AccountSummaryHeaderView.ViewModel(welcomeMessage: "Good morning,",
                                                    name: profile.firstName,
                                                    date: Date())
        headerView.configure(viewModel: vm)
    }
    
    private func configureTableViewCells(with accounts: [Account]) {
        accountCellViewModels = accounts.compactMap({ account in
            return AccountSummaryCell.ViewModel(accountType: account.type, accountName: account.name, balance: account.amount)
        })
    }
}
