//
//  SearchVC.swift
//  Activation
//
//  Created by Mattias Törnqvist on 2020-06-28.
//  Copyright © 2020 Mattias Törnqvist. All rights reserved.
//

import UIKit
import SVProgressHUD
import Firebase

class SearchUserTVC: UITableViewController {
    
    var dataSourceAndDelegate: SearchUserDelegateAndDataSource?
    
    override init(style: UITableView.Style) {
        super.init(style: .plain)
        
        configureTableView()
    }
    
    func configureTableView() {
        tableView.register(SearchUserCell.self, forCellReuseIdentifier: SearchUserCell.idenitifer)
        
        dataSourceAndDelegate = SearchUserDelegateAndDataSource(tableView)
        tableView.delegate = dataSourceAndDelegate
        tableView.dataSource = dataSourceAndDelegate
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class SearchUserDelegateAndDataSource: NSObject, UITableViewDelegate, UITableViewDataSource {
    
    let tableView: UITableView
    let service = UserService.shared
    var users = [User]()
    var currentUserUid: String?
    
    init(_ tableView: UITableView) {
        self.tableView = tableView
        
        super.init()
        
        fetchUsers()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: SearchUserCell.idenitifer, for: indexPath) as! SearchUserCell
        cell.user = users[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func fetchUsers() {
        
        guard let currentUserUid = Auth.auth().currentUser?.uid else { return }
        
        self.currentUserUid = currentUserUid
        
        service.fetchUsers { (result) in

            switch result {
            case .success(let user):
                if currentUserUid != user.uid {
                    self.updateTableView(with: user)
                }
            case .failure(let error):
                SVProgressHUD.showError(withStatus: error.localizedDescription)
            }
        }
    }
    
    func updateTableView(with user: User) {
        if currentUserUid != user.uid {
            self.users.append(user)
            self.tableView.reloadData()
        }
    }
}
