//
//  UpdatesViewController.swift
//  Vega
//
//  Created by Alexander on 01.06.2020.
//  Copyright © 2020 Alexander. All rights reserved.
//

import UIKit

class UpdatesViewController: UIViewController {
    
    private var tableView: UITableView!
    
    private let cellId = "cellId"
    
    private var updates: [Update]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupUI()
        fetchUpdates()
    }
    
    private func setupTableView() {
        tableView = UITableView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.estimatedRowHeight = UITableView.automaticDimension
    }
    
    private func setupUI() {
        
        view.backgroundColor = .white
        title = "Уведомления"
        
        view.addSubview(tableView)
        tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
    }
    
}

extension UpdatesViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return updates?.count ?? 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if updates == nil || updates?.count == 0{
            
            let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
            cell.textLabel?.text = "Уведомлений нет."
            return cell
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
            cell.textLabel?.text = updates?[indexPath.row].title
            cell.textLabel?.numberOfLines = 0
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
}

extension UpdatesViewController {
    
    private func fetchUpdates() {
         NetworkService().fetchUpdates { (updates) in
            self.updates = updates?.updates ?? []
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
}
