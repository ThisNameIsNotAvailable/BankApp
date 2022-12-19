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
    let refreshControl = UIRefreshControl()
    private let headerView = AccountSummaryHeaderView(frame: .zero)
    private var accountCellViewModels = [AccountSummaryCell.ViewModel]()
    lazy var logoutButton: UIBarButtonItem = {
        let button = UIBarButtonItem(title: "Log Out", style: .plain, target: self, action: #selector(didTapLogOut))
        button.tintColor = .label
        return button
    }()
    var profile: Profile?
    var accounts = [Account]()
    var isLoaded = false
    
    var headerViewModel = AccountSummaryHeaderView.ViewModel(welcomeMessage: "Welcome", name: "", date: Date())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        setup()
        
    }
    
    @objc private func didTapLogOut() {
        NotificationCenter.default.post(Notification(name: .logout))
    }
    
    @objc private func refreshed() {
        isLoaded = false
        setupSkeletons()
        tableView.reloadData()
        fetchData()
    }
}

extension AccountSummaryViewController {
    private func setup() {
        setUpTableView()
        setupTableHeaderView()
        setupRefreshControl()
        setupSkeletons()
        fetchData()
        navigationItem.rightBarButtonItem = logoutButton
    }
    
    private func setupRefreshControl() {
        refreshControl.tintColor = appColor
        refreshControl.addTarget(self, action: #selector(refreshed), for: .valueChanged)
        tableView.refreshControl = refreshControl
    }
    
    private func setupSkeletons() {
        let row = Account.makeSkeleton()
        accounts = Array(repeating: row, count: 10)
        configureTableViewCells(with: accounts)
    }
    
    private func setUpTableView() {
        view.addSubview(tableView)
        tableView.backgroundColor = appColor
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(AccountSummaryCell.self, forCellReuseIdentifier: AccountSummaryCell.identifier)
        tableView.register(SkeletonCell.self, forCellReuseIdentifier: SkeletonCell.reuseID)
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
        if isLoaded {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: AccountSummaryCell.identifier, for: indexPath) as? AccountSummaryCell else {
                return UITableViewCell()
            }
            
            cell.configure(accountCellViewModels[indexPath.row])
            
            return cell
        }
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SkeletonCell.reuseID, for: indexPath) as? SkeletonCell else {
            return UITableViewCell()
        }
        
        return cell
        
    }
        
}

// MARK: - Networking
extension AccountSummaryViewController {
    private func fetchData() {
        let group = DispatchGroup()
        let userId = String(Int.random(in: 1...3))
        group.enter()
        fetchProfile(forUserId: userId) { result in
            switch result {
            case .success(let profile):
                self.profile = profile
            case .failure(let error):
                print(error.localizedDescription)
            }
            group.leave()
        }

        group.enter()
        fetchAccounts(forUserId: userId) { result in
            switch result {
            case .success(let accounts):
                self.accounts = accounts
            case .failure(let error):
                print(error.localizedDescription)
            }
            group.leave()
        }
        
        group.notify(queue: .main) {
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) { [weak self] in
                self?.isLoaded = true
                guard let profile = self?.profile, let accounts = self?.accounts else {
                    return
                }
                self?.configureTableHeaderView(with: profile)
                self?.configureTableViewCells(with: accounts)
                self?.tableView.reloadData()
                self?.tableView.refreshControl?.endRefreshing()
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
