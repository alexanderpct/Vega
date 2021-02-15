//
//  AdvancedSearchViewController.swift
//  Vega
//
//  Created by Alexander on 08.11.2019.
//  Copyright © 2019 Alexander. All rights reserved.
//

import UIKit

protocol RefreshDocumentsListDelegate: AnyObject {
    func refreshDocuments(searchQuery: SearchQuery)
    func searchTextUpdate()
    
}

enum PickType {
    case users
    case docTypes
    case disciplines
    case themes
    case none
}

class AdvancedSearchViewController: UITableViewController {
    
    var searchQuery = SearchQuery()
    weak var refreshDocumentsDelegate: RefreshDocumentsListDelegate?
    
    private let cellId = "cellId"
    private let networkService: NetworkService
    
    let titles = [["Выбрать пользователей", "Выбрать типы документов", "Выбрать дисциплины", "Выбрать темы"], ["Дата публикации документа", "Рейтинг документа", "Дата загрузки документа"]]
    
    
    init(networkService: NetworkService, style: UITableView.Style) {
        self.networkService = networkService
        super.init(style: style)
    }
    
    
    
    convenience init(networkService: NetworkService, style: UITableView.Style, searchQuery: SearchQuery) {
        self.init(networkService: networkService, style: style)
        self.searchQuery = searchQuery
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
                
        tableView.register(AdvancedSearchTableViewCell.self, forCellReuseIdentifier: cellId)
        
        tableView.rowHeight = 80
        
    }
    
    private func setupNavigationBar() {
        self.navigationController?.navigationBar.topItem?.title = "Фильтры"
        let leftButton = UIBarButtonItem(image: UIImage(systemName: "chevron.left"), style: .plain, target: self, action: #selector(handleBackButtonTapped))
        let refreshCurrentDocumentsList = UIBarButtonItem(image: UIImage(systemName: "magnifyingglass"), style: .plain, target: self, action: #selector(handleSearchButtonTapped))
        
        self.navigationItem.rightBarButtonItem = refreshCurrentDocumentsList
        self.navigationItem.leftBarButtonItem = leftButton
    }
    
}

extension AdvancedSearchViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
            case 0: return "Основные"
            case 1: return " "
        default: return " "
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
            case 0: return 4
            case 1: return 3
        default: return 100
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! AdvancedSearchTableViewCell
        cell.configure(title: titles[indexPath.section][indexPath.row], searchQuery: searchQuery, section: indexPath.section, row: indexPath.row)
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        var pickType: PickType = .none
        if indexPath.section == 0 {
            switch indexPath.row {
            case 0: pickType = .users
            case 1: pickType = .docTypes
            case 2: pickType = .disciplines
            case 3: pickType = .themes
            default: pickType = .none
            }
        }
        
        var pickedValues: [String] = []
        switch pickType {
        case .users: pickedValues = searchQuery.usersTitles
        case .docTypes: pickedValues = searchQuery.docTypesTitles
        case .disciplines: pickedValues = searchQuery.disciplinesTitles
        case .themes: pickedValues = searchQuery.themesTitles
        case .none: pickedValues = []
        }
        
        var pickedIDs: [Int] = []
        switch pickType {
        case .users: pickedIDs = searchQuery.usersIDs
        case .docTypes: pickedIDs = searchQuery.docTypesIDs
        case .disciplines: pickedIDs = searchQuery.disciplinesIDs
        case .themes: pickedIDs = searchQuery.themesIDs
        case .none: pickedIDs = []
        }
        
        let controller = GenericCategorySearchTableViewController(networkService: networkService, type: pickType, pickedValues: pickedValues, pickedIDs: pickedIDs)
        let navigationController = UINavigationController(rootViewController: controller)
        
        controller.optionsDelegate = self
        present(navigationController, animated: true, completion: {self.tableView.deselectRow(at: indexPath, animated: false)})
    }
    
}

extension AdvancedSearchViewController {
    
    @objc private func handleBackButtonTapped() {
        refreshDocumentsDelegate?.searchTextUpdate()
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func handleSearchButtonTapped() {
        refreshDocumentsDelegate?.searchTextUpdate()
        refreshDocumentsDelegate?.refreshDocuments(searchQuery: searchQuery)
        
        dismiss(animated: true, completion: nil)
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
    func didPick(options: [String], pickedIDs: [Int], with type: PickType?) {

        if type == PickType.themes {
            self.searchQuery.themesIDs = pickedIDs
            self.searchQuery.themesTitles = options
        }

        else if type == PickType.users {
            self.searchQuery.usersIDs = pickedIDs
            self.searchQuery.usersTitles = options

        } else if type == PickType.docTypes {
            self.searchQuery.docTypesIDs = pickedIDs
            self.searchQuery.docTypesTitles = options
            
        } else if type == PickType.disciplines {
            self.searchQuery.disciplinesIDs = pickedIDs
            self.searchQuery.disciplinesTitles = options
        }
        self.tableView.reloadData()



    }
}
