//
//  ProfileViewController.swift
//  Vega
//
//  Created by Alexander on 01.11.2019.
//  Copyright © 2019 Alexander. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {
    
    var tableView: UITableView!
    
    private let cellId = "cellId"
    
    private let titles = ["Подписки", "Настройки", "Загрузить", "История", "Выйти"]

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.largeTitleDisplayMode = .always
        setupTableView()
        tableView.backgroundColor = .white
        
    }
    
    private func setupTableView() {
        tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 60
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
        view.addSubview(tableView)
        tableView.frame = view.frame
    }
    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        self.navigationController?.setNavigationBarHidden(true, animated: animated)
//    }

}

// MARK: - UITableView
extension ProfileViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        cell.textLabel?.text = titles[indexPath.row]
        cell.tintColor = .black
        
        switch indexPath.row {
            case 0: cell.imageView?.image = UIImage(systemName: "pencil")
            case 1: cell.imageView?.image = UIImage(systemName: "gear")
            case 2: cell.imageView?.image = UIImage(systemName: "icloud.and.arrow.up")
            case 3: cell.imageView?.image = UIImage(systemName: "folder")
            case 4: cell.imageView?.image = UIImage(systemName: "multiply")
            default: break
        }
        
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch indexPath.row {
        case 0:
            navigationController?.pushViewController(SubscriptionsViewController(), animated: true)
        case 1:
            navigationController?.pushViewController(SettingsViewController(), animated: true)
        case 2:
            navigationController?.pushViewController(UploadViewController(), animated: true)
        case 4:
            navigationController?.parent?.navigationController?.popToRootViewController(animated: true)
        default: break
        }
        self.tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
}
