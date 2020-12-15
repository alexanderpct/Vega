//
//  DocumentsListViewController.swift
//  Vega
//
//  Created by Alexander on 01.11.2019.
//  Copyright © 2019 Alexander. All rights reserved.
//

import UIKit

class DocumentsListViewController: UIViewController {

    private let tableView: UITableView = {
        let tableView = UITableView()
        return tableView
    }()
    
    private let imageView: UIImageView = {
        let iv = UIImageView()
        iv.backgroundColor = .red
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.image = UIImage(systemName: "person.circle.fill")
        return iv
    }()
    
    private let headerLabel: UILabel = {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 300, height: 150))
        label.font = .boldSystemFont(ofSize: 40)
        label.numberOfLines = 2
        label.textAlignment = .center
        label.text = "Вы офлайн"
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 300, height: 150))
        label.font = .systemFont(ofSize: 20)
        label.textAlignment = .center
        label.numberOfLines = 3
        label.text = "Используйте мобильный интернет или подключитесь к сети Wi-Fi."
        return label
    }()
    
    private let refreshButton: UIButton = {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 150, height: 50))
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 25
        button.setTitle("Обновить", for: .normal)
        button.addTarget(self, action:#selector(buttonClicked), for: .touchUpInside)
        return button
    }()
    
    private var timer: Timer?
    private let cellId = "cellId"
    private let tableviewloadingcellid = "tableviewloadingcellid"
    private let searchController = UISearchController(searchResultsController: nil)
    private let networkService: VegaNetworkProtocol
    private var documents: [Document] = []
    private var users: [Int] = []
    private var options: [String] = []
    private var isLoading: Bool = false
    private var totalCount: String = "0"
    
    init(networkService: VegaNetworkProtocol) {
        self.networkService = networkService
        super.init(nibName: nil, bundle: nil)
    }
    

    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        networkService.authorizationAs { (code) in
            DispatchQueue.main.async{
                self.getDocuments()
            }
        }

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = false
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.sizeToFit()
    }

    private func setupTableView() {
        view.addSubview(tableView)
        tableView.frame = view.frame
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 120
        tableView.register(DocumentListTableViewCell.self, forCellReuseIdentifier: cellId)
        tableView.register(LoadingTableViewCell.self, forCellReuseIdentifier: tableviewloadingcellid)
        
    }
    
    // MARK: - Private methods
    private func setupSearchBar() {
        definesPresentationContext = true
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = true
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.delegate = self
        searchController.searchBar.showsSearchResultsButton = true;
        searchController.searchBar.showsCancelButton = false
        searchController.searchBar.setValue("Отменить", forKey: "cancelButtonText")
        
    }
    
    private func setupNetworkErrorLabels() {
        headerLabel.center.x = self.view.center.x
        headerLabel.center.y = self.view.center.y - 80
        
        descriptionLabel.center.x = self.view.center.x
        descriptionLabel.center.y = self.view.center.y - 10
        
        refreshButton.center.x = self.view.center.x
        refreshButton.center.y = self.view.center.y + 70
        
        self.view.addSubview(headerLabel)
        self.view.addSubview(descriptionLabel)
        self.view.addSubview(refreshButton)
        
    }
    

    private func getDocuments() {
        
        
        networkService.fetchDocuments(keywords: "ЯЗЫК", users: users, batchStart: "1", batchSize: "20") { (result) in
            switch result {
            case .success(let documents):
                self.totalCount =  documents.totalCount
                self.documents = documents.documents.compactMap { Document(from: $0) }
                DispatchQueue.main.async {
                    
                    for view in self.view.subviews {
                        view.removeFromSuperview()
                    }
                    
                    self.setupSearchBar()
                    self.setupTableView()
                    self.navigationItem.title = "Документов: \(self.totalCount)"
                    self.tableView.reloadData()
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    print("🥳😎❤️\(error)")
                    self.setupNetworkErrorLabels()
                }
            }
        }
    }
    
    @objc func buttonClicked(sender : UIButton) {
        getDocuments()
    }


}

// MARK: - UITableView
extension DocumentsListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if isLoading == true{
            return 2
        } else{
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0 {
            
            return documents.count
            
        } else if section == 1 {
            
            return 1
            
        } else {
            
            return 0
            
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! DocumentListTableViewCell
            let document = documents[indexPath.row]
            
            cell.configure(with: document.title, description: document.descriptionBody ?? "", rating: document.rating, comments: "\(document.comments.count)")
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "tableviewloadingcellid", for: indexPath) as! LoadingTableViewCell
            return cell
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let controller = DocumentViewController(with: documents[indexPath.row])
        navigationController?.pushViewController(controller, animated: true)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        
        if (offsetY > contentHeight - scrollView.frame.height * 4) && !isLoading {
            loadMoreData()
        }
    }
    
    func loadMoreData() {
        
        if documents.count < Int(totalCount)! {
            if !self.isLoading {
                self.isLoading = true
                
                networkService.fetchDocuments(keywords: "ЯЗЫК", users: users, batchStart: String(documents.count + 1), batchSize: "20") { (result) in
                    switch result {
                    case .success(let documents):
                        self.documents += documents.documents.compactMap { Document(from: $0) }
                        DispatchQueue.main.async {
                            self.isLoading = false
                            self.tableView.reloadData()
                            
                        }
                    case .failure(let error):
                        DispatchQueue.main.async {
                            print("🥳😎❤️\(error)")
                        }
                    }
                }
                
            }
            
        }
    }
    
}

// MARK: - UISearchBarDelegate
extension DocumentsListViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { _ in
            
            if searchText == "" {
                return
            }
            
            self.networkService.fetchDocuments(keywords: searchText, batchStart: "1", batchSize: "20", completion: { (result) in
                switch result {
                case .success(let documents):
                    self.totalCount =  documents.totalCount
                    self.documents = documents.documents.compactMap { Document(from: $0) }
                    DispatchQueue.main.async {
                        self.navigationItem.title = "Документов: \(self.totalCount)"
                        self.tableView.reloadData()
                    }
                case .failure(let error):
                    print(error)
                }
            })
        }
    }
        
    func searchBarResultsListButtonClicked(_ searchBar: UISearchBar) {
        let controller = AdvancedSearchViewController(networkService: networkService as! NetworkService, style: .grouped, options: options)
        controller.refreshDocumentsDelegate = self
        let navigationController = UINavigationController(rootViewController: controller)
        present(navigationController, animated: true, completion: nil)
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchController.searchBar.showsCancelButton = true
    }

    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchController.searchBar.showsCancelButton = false
    }

}

// MARK: - Selectors
extension DocumentsListViewController {
    @objc private func hideKeyboard() {
        searchController.dismiss(animated: true, completion: nil)
    }
}

extension DocumentsListViewController: RefreshDocumentsListDelegate{
    func refreshDocuments(selectedUserIDs: [Int], options: [String]) {
        self.options = options
        self.users = selectedUserIDs
        self.networkService.fetchDocuments(keywords: "ЯЗЫК", users: selectedUserIDs, batchStart: "1", batchSize: "20", completion: { (result) in
            switch result {
            case .success(let documents):
                self.totalCount =  documents.totalCount
                self.documents = documents.documents.compactMap { Document(from: $0) }
                DispatchQueue.main.async {
                    self.navigationItem.title = "Документов: \(self.totalCount)"
                    self.tableView.reloadData()
                }
            case .failure(let error):
                print(error)
            }
        })
    }

    
    
}


