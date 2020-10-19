//
//  AdvancedSearchViewController.swift
//  Vega
//
//  Created by Alexander on 08.11.2019.
//  Copyright © 2019 Alexander. All rights reserved.
//

import UIKit

enum PickType {
    case users
    case documents
    case disciplines
    case themes
    case none
}

class AdvancedSearchViewController: UITableViewController {
    
    var selectedUserIDs = [Int]()
    
    private let cellId = "cellId"
    private let networkService: NetworkService
    
    let titles = ["Выбрать пользователей", "Выбрать типы документов", "Выбрать дисциплины", "Выбрать темы", "Дата публикации документа", "Рейтинг документа", "Дата загрузки документа"]
    
    init(networkService: NetworkService, style: UITableView.Style) {
        self.networkService = networkService
        super.init(style: style)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let inputTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.backgroundColor = .red
        return textField;
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBar()
                
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
        
        tableView.rowHeight = 60
        
    }
    
    private func setupNavigationBar() {
        self.navigationController?.navigationBar.topItem?.title = "Фильтры"
        let leftButton = UIBarButtonItem(image: UIImage(systemName: "chevron.left"), style: .plain, target: self, action: #selector(handleBackButtonTapped))
        let rightButton = UIBarButtonItem(image: UIImage(systemName: "magnifyingglass"), style: .plain, target: self, action: #selector(handleSearchButtonTapped))
        self.navigationItem.rightBarButtonItem = rightButton
        self.navigationItem.leftBarButtonItem = leftButton
    }
    
}

extension AdvancedSearchViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return titles.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
            case 0: return "Пользователи"
            case 1: return "Документы"
            case 2: return "Дисциплины"
            case 3: return "Темы"
        default: return " "
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        cell.textLabel?.text = titles[indexPath.section]
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        var pickType: PickType
        switch indexPath.section {
            case 0: pickType = .users
            case 1: pickType = .documents
            case 2: pickType = .disciplines
            case 3: pickType = .themes
            default: pickType = .none
        }
        let controller = GenericCategorySearchTableViewController(networkService: networkService, type: pickType)
        let navigationController = UINavigationController(rootViewController: controller)
        
        controller.optionsDelegate = self
        present(navigationController, animated: true, completion: {self.tableView.deselectRow(at: indexPath, animated: false)})
    }
    
}

extension AdvancedSearchViewController {
    
    @objc private func handleBackButtonTapped() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func handleSearchButtonTapped() {
        let controller = FilterViewController(networkService: networkService, users: selectedUserIDs)
        let navigationController = UINavigationController(rootViewController: controller)
        present(navigationController, animated: true, completion: nil)
    }
    
    @objc private func handleTapGesture(gestureRecognizer: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
}

extension AdvancedSearchViewController: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return true
    }
}

extension AdvancedSearchViewController: PickOptionsDelegate {
    func didPick(options: [String], with type: PickType?) {
        if type == PickType.themes {
            networkService.fetchDocuments(keywords: "язык", themes: options) { (documents) in
            }
        }
        
        else if type == PickType.users {
            selectedUserIDs = []
            if options.contains("admin"){selectedUserIDs.append(1)}
            if options.contains("testprep"){selectedUserIDs.append(2)}
            if options.contains("teststud"){selectedUserIDs.append(3)}
            
        }
        
        
        
    }
}
