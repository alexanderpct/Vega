//
//  DocumentViewController.swift
//  Vega
//
//  Created by Alexander on 23.05.2020.
//  Copyright © 2020 Alexander. All rights reserved.
//

import UIKit

class DocumentViewController: UIViewController {
    
    private let cellId = "cellId"
    private var commentsTableView: UITableView!
    private var url: URL?
    private var comments: [Comment] = []
    
    let descriptionHeader: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .boldSystemFont(ofSize: 24)
        return label
    }()
    
    let descriptionBody: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 18)
        return label
    }()
    
    let commentsTitle: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 20)
        label.text = "Комментарии"
        return label
    }()
    
    let ratingLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .right
        label.textColor = .orange
        label.font = .boldSystemFont(ofSize: 22)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    init(with document: Document) {
        descriptionHeader.text = document.descriptionHeader
        descriptionBody.text = document.descriptionBody
        ratingLabel.text = "Рейтинг: \(document.rating).0"

        comments = document.comments
        if comments.count == 0 {
            commentsTitle.isHidden = true
        }

        if let url = URL(string: document.url ?? "") {
            self.url = url
        }

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        setupTableView()
        setupUI()
    }
    
    //MARK: - Private methods
    private func setupUI() {
        
        let stackView = UIStackView(arrangedSubviews: [descriptionHeader, descriptionBody, ratingLabel, commentsTitle])
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.spacing = 24
        stackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stackView)
        
        stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        stackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 24).isActive = true
        stackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -24).isActive = true
        stackView.heightAnchor.constraint(greaterThanOrEqualToConstant: 100).isActive = true
                
        view.addSubview(commentsTableView)
        commentsTableView.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 24).isActive = true
        commentsTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 12).isActive = true
        commentsTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -12).isActive = true
        commentsTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        
    }
    
    private func setupTableView() {
        commentsTableView = UITableView()
        commentsTableView.delegate = self
        commentsTableView.dataSource = self
        commentsTableView.estimatedRowHeight = UITableView.automaticDimension
        commentsTableView.translatesAutoresizingMaskIntoConstraints = false
        commentsTableView.allowsSelection = false
        commentsTableView.register(DocumentTableViewCell.self, forCellReuseIdentifier: cellId)
    }
    
    private func setupNavigationBar() {
        self.navigationController?.navigationBar.topItem?.title = "Документ"
//        let leftButton = UIBarButtonItem(image: UIImage(systemName: "chevron.left"), style: .plain, target: self, action: #selector())
//        let rightButton = UIBarButtonItem(image: UIImage(systemName: "square.and.arrow.up"), style: .plain, target: self, action: #selector())
//        self.navigationItem.rightBarButtonItem = rightButton
//        self.navigationItem.leftBarButtonItem = leftButton
        
        if url == nil {
            self.navigationItem.rightBarButtonItem?.isEnabled = false
        }
        
    }
    
}

extension DocumentViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        comments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let comment = comments[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! DocumentTableViewCell
        cell.commentLabel.text = comment.comment
        cell.authorLabel.text = comment.username
        return cell
    }
    
    
}
