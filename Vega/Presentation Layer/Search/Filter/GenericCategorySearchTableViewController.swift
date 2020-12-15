//
//  GenericCategorySearchTableViewController.swift
//  Vega
//
//  Created by Alexander on 22.11.2019.
//  Copyright © 2019 Alexander. All rights reserved.
//

import UIKit

protocol PickOptionsDelegate: AnyObject {
    func didPick(options: [String], with type: PickType?)
}

class GenericCategorySearchTableViewController: UITableViewController {

    lazy var checked = [Bool].init(repeating: false, count: values.count)
    
    weak var optionsDelegate: PickOptionsDelegate?
    
    private let networkService: NetworkService

    private var values: [String] = []
    private var pickedValues: [String] = []
    private var pickType: PickType
    
    private let cellId = "cellId"
    
    private let spinner = UIActivityIndicatorView(style: .medium)
    
    init(networkService: NetworkService, type: PickType, pickedValues: [String]) {
        self.networkService = networkService
        self.pickType = type
        self.pickedValues = pickedValues
        super.init(style: .plain)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.backgroundColor = .white
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
        configureController()
        
        spinner.startAnimating()
        tableView.backgroundView = spinner
  
        let leftButton = UIBarButtonItem(image: UIImage(systemName: "chevron.left"), style: .plain, target: self, action: #selector(handleBackButtonTapped))
        let rightButton = UIBarButtonItem(title: "Выбрать", style: .plain, target: self, action: #selector(handleConfirmButtonTapped))
        self.navigationItem.leftBarButtonItem = leftButton
        self.navigationItem.rightBarButtonItem = rightButton

    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return values.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        cell.textLabel?.text = values[indexPath.row]
        cell.textLabel?.numberOfLines = 0
        cell.sizeToFit()
        cell.selectionStyle = .none
        
        if pickedValues.contains(values[indexPath.row]) {
            cell.accessoryType = .checkmark
        }

        return cell
    }

    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }

    private func configureController() {
        switch pickType {
            case .users:
                fetchUsers()
                title = "Пользователи"
            case .documents:
                fetchDocTypes()
                title = "Документы"
            case .disciplines:
                fetchDisciplines()
                title = "Дисциплины"
            case .themes:
                fetchThemes()
                title = "Темы"
        case .none:
            break
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    

}

extension GenericCategorySearchTableViewController {

    private func fetchDocTypes() {
        networkService.fetchDocTypes { (response) in
            self.values = response?.compactMap { $0.title } ?? []
            self.reloadTableView()
        }
    }

    private func fetchUsers() {
        networkService.fetchUsers { (response) in
            self.values = response?.compactMap { $0.name } ?? []
            self.reloadTableView()
        }
    }

    private func fetchDisciplines() {
        networkService.fetchDisciplines { (response) in
            self.values = response?.compactMap { $0.title } ?? []
            self.reloadTableView()
        }
    }

    private func fetchThemes() {
        networkService.fetchThemes { (response) in
            self.values = response?.compactMap { $0.title } ?? []
            self.reloadTableView()
        }
    }
    
    private func reloadTableView() {
        DispatchQueue.main.async {
            self.spinner.stopAnimating()
            self.spinner.removeFromSuperview()
            self.tableView.reloadData()
        }
    }
    
}

extension GenericCategorySearchTableViewController {

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) {
            if cell.accessoryType == .checkmark {
                cell.accessoryType = .none
                checked[indexPath.row] = false
            } else {
                cell.accessoryType = .checkmark
                checked[indexPath.row] = true
            }
        }
        
        let value = values[indexPath.row]
        if pickedValues.contains(value) {
            if let index = pickedValues.firstIndex(of: value) {
                pickedValues.remove(at: index)
            }
        } else {
            pickedValues.append(value)
        }
    }

}

extension GenericCategorySearchTableViewController {
    @objc private func handleBackButtonTapped() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func handleConfirmButtonTapped() {
        optionsDelegate?.didPick(options: pickedValues, with: pickType)
        dismiss(animated: true, completion: nil)
    }
}
