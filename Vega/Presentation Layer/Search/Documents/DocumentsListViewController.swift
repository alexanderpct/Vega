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
    
    private var timer: Timer?
    private let cellId = "cellId"
    private let searchController = UISearchController(searchResultsController: nil)
    private let networkService: VegaNetworkProtocol
    private var documents: [Document] = []
    private var users: [Int] = []
    private var options: [String] = []
    
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
        getDocuments()
        setupSearchBar()
        setupTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = false
        navigationController?.navigationBar.prefersLargeTitles = true
    }

    private func setupTableView() {
        view.addSubview(tableView)
        tableView.frame = view.frame
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 120
        tableView.register(DocumentListTableViewCell.self, forCellReuseIdentifier: cellId)
    }
    
    // MARK: - Private methods
    private func setupSearchBar() {
        definesPresentationContext = true
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = true
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.delegate = self
        searchController.searchBar.showsSearchResultsButton = true;
        searchController.searchBar.showsCancelButton = false
        searchController.searchBar.setValue("Отменить", forKey: "cancelButtonText")
        
    }

    private func getDocuments() {
        networkService.fetchDocuments(keywords: "язык", users: users) { (documents) in
            self.documents = documents?.documents.compactMap { Document(from: $0) } ?? []
            DispatchQueue.main.async {
                self.navigationItem.title = "Документов: \(self.documents.count)"
                self.tableView.reloadData()
            }
        }
    }


}

// MARK: - UITableView
extension DocumentsListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return documents.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! DocumentListTableViewCell
        let document = documents[indexPath.row]

        cell.configure(with: document.title, description: document.descriptionBody ?? "", rating: document.rating, comments: "\(document.comments.count)")

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let controller = DocumentViewController(with: documents[indexPath.row])
        navigationController?.pushViewController(controller, animated: true)
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
            
            self.networkService.fetchDocuments(keywords: searchText, completion: { (documents) in
                self.documents = documents?.documents.compactMap { Document(from: $0) } ?? []
                DispatchQueue.main.async {
                    self.navigationItem.title = "Документов: \(self.documents.count)"
                    self.tableView.reloadData()
                }
            })
        }
    }
        
    func searchBarResultsListButtonClicked(_ searchBar: UISearchBar) {
        let controller = AdvancedSearchViewController(networkService: networkService as! NetworkService, style: .grouped, options: options)
        controller.RefreshDocumentsDelegate = self
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
        self.networkService.fetchDocuments(keywords: "язык", users: selectedUserIDs, completion: { (documents) in
            self.documents = documents?.documents.compactMap { Document(from: $0) } ?? []
            DispatchQueue.main.async {
                self.navigationItem.title = "Документов: \(self.documents.count)"
                self.tableView.reloadData()
            }
        })
    }

    
    
}


