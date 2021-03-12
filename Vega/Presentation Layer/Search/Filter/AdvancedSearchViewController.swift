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
    func searchTextUpdate(searchQuery: SearchQuery)
}


enum PickType {
    // CheckFilterVC
    case users
    case docTypes
    case disciplines
    case themes
    case none
}

enum CheckType {
    case publicationDate
    case uploadTime
    case rating
    case none
}

class AdvancedSearchViewController: UITableViewController {
    
    var searchQuery = SearchQuery()
    weak var refreshDocumentsDelegate: RefreshDocumentsListDelegate?
    
    private let cellId1 = "cellId1"
    private let cellId2 = "cellId2"
    private let cellId3 = "cellId3"
    private let networkService: NetworkService
    
    let titles = ["Ключевые слова:", "Автор:", "Заглавие:","Дата издания", "Тип документа",  "Тема", "Дисциплина", "Пользователь", "Дата добавления", "Комментарий:", "Рейтинг", "Код:"]
    
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBar()
        
        tableView.keyboardDismissMode = .onDrag
         
        tableView.register(AdvancedSearchTypeTableViewCell.self, forCellReuseIdentifier: cellId1)
        tableView.register(AdvancedSearchSelectTableViewCell.self, forCellReuseIdentifier: cellId2)
        
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
        return 1
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
            case 0: return "Основные"
        default: return " "
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titles.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 || indexPath.row == 1 || indexPath.row == 2 || indexPath.row == 9 || indexPath.row == 11  {
            let cell = tableView.dequeueReusableCell(withIdentifier: cellId1, for: indexPath) as! AdvancedSearchTypeTableViewCell
            cell.typeOptionsDelegate = self
            cell.configure(title: titles[indexPath.row], row: indexPath.row, searchQuery: searchQuery)
            cell.selectionStyle = .none
            
            return cell
            
        } else if indexPath.row == 4 || indexPath.row == 5 || indexPath.row == 6 || indexPath.row == 7 {
            let cell = tableView.dequeueReusableCell(withIdentifier: cellId2, for: indexPath) as! AdvancedSearchSelectTableViewCell
            cell.configure(title: titles[indexPath.row], searchQuery: searchQuery, section: indexPath.section, row: indexPath.row)
            return cell
        } else { //indexpath.row == 3, 8, 10
            let cell = tableView.dequeueReusableCell(withIdentifier: cellId2, for: indexPath) as! AdvancedSearchSelectTableViewCell
            cell.configure(title: titles[indexPath.row], searchQuery: searchQuery, section: indexPath.section, row: indexPath.row)
            return cell
        }
        
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //     navigationController?.pushViewController(PickFilterViewController(), animated: true)
        
        var pickType: PickType = .none
        var checkType: CheckType = .none
        
        switch indexPath.row {
        //        case 0: keywords
        //        case 1: author
        //        case 2: title
        case 3: checkType = .publicationDate
        case 4: pickType = .docTypes
        case 5: pickType = .themes
        case 6: pickType = .disciplines
        case 7: pickType = .users
        case 8: checkType = .uploadTime
        //        case 9: комментарий
        default: pickType = .none
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
        
        switch indexPath.row {
        //        case 0: keywords
        //        case 1: author
        //        case 2: title
        case 3: checkType = .publicationDate
        case 4: pickType = .docTypes
        case 5: pickType = .themes
        case 6: pickType = .disciplines
        case 7: pickType = .users
        case 8: checkType = .uploadTime
        //        case 9: комментарий
        case 10: checkType = .rating
        //        case 11: code
        default: pickType = .none
        }
        
        var checkedParametrs: String = ""
        switch checkType {
        case .publicationDate: checkedParametrs = searchQuery.publicationDateParam
        case .rating: checkedParametrs = searchQuery.ratingParam
        case .uploadTime: checkedParametrs = searchQuery.uploadTimeParam
        case .none: checkedParametrs = ""
        }
        
        var checkedCond: Int = 0
        switch checkType {
        case .publicationDate: checkedCond = searchQuery.publicationDateCond
        case .rating: checkedCond = searchQuery.ratingCond
        case .uploadTime: checkedCond = searchQuery.uploadTimeCond
        case .none: checkedCond = 0
        }
        
        
        if indexPath.row == 0 || indexPath.row == 1 || indexPath.row == 2 || indexPath.row == 9 || indexPath.row == 11 {
            
            let cell = tableView.cellForRow(at: indexPath) as? AdvancedSearchTypeTableViewCell
            cell?.textField.becomeFirstResponder()
            
        } else if indexPath.row == 4 || indexPath.row == 5 || indexPath.row == 6 || indexPath.row == 7 {
            let controller = CheckFilterTableViewController(networkService: networkService, type: pickType, pickedValues: pickedValues, pickedIDs: pickedIDs)
            let navigationController = UINavigationController(rootViewController: controller)
            
            controller.optionsDelegate = self
            present(navigationController, animated: true, completion: {self.tableView.deselectRow(at: indexPath, animated: false)})
            
        } else { //indexpath.row == 3, 8, 10
            let controller = PickFilterViewController(type: checkType, checkedParametrs: checkedParametrs, checkedCond: checkedCond)
            controller.pickerFilterVCtoAdvansedSearchVCDelegate = self
            let navigationController = UINavigationController(rootViewController: controller)
            present(navigationController, animated: true, completion: {self.tableView.deselectRow(at: indexPath, animated: false)})
        }
    }
}

extension AdvancedSearchViewController {
    
    @objc private func handleBackButtonTapped() {
        refreshDocumentsDelegate?.searchTextUpdate(searchQuery: searchQuery)
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func handleSearchButtonTapped() {
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

extension AdvancedSearchViewController: PickerFilterVCtoAdvansedSearchVCDelegate {
    func transfer(checkType: CheckType, checkedParametrs: String, checkedCond: Int){
        if checkType == .publicationDate {
            self.searchQuery.publicationDateParam = checkedParametrs
            self.searchQuery.publicationDateCond = checkedCond
        } else if checkType == .uploadTime {
            self.searchQuery.uploadTimeParam = checkedParametrs
            self.searchQuery.uploadTimeCond = checkedCond
        } else if checkType == .rating {
            self.searchQuery.ratingParam = checkedParametrs
            self.searchQuery.ratingCond = checkedCond
        }
        
        self.tableView.reloadData()
    }
}


extension AdvancedSearchViewController: TypeOptionsDelegate {
    func didTyped(title: String, checkedParametrs: String) {
        switch title {
        case "Ключевые слова:": searchQuery.searchText = checkedParametrs
        case "Автор:": let authors = checkedParametrs.split(separator: ",")
            var authorsWithoutSpacesAfterComma = [String]()
            for author in authors {
                if author.first == " " {
                    var temp = author
                    temp.removeFirst()
                    authorsWithoutSpacesAfterComma.append(String(temp))
                } else {
                    authorsWithoutSpacesAfterComma.append(String(author))
                }
            }
            searchQuery.authors = authorsWithoutSpacesAfterComma
        case "Заглавие:": searchQuery.title = checkedParametrs
        case "Комментарий:": searchQuery.comments = checkedParametrs
        case "Код:": searchQuery.code = checkedParametrs
        default:
            break
        }
    }
}
