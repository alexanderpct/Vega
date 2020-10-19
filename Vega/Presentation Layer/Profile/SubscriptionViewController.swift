//
//  SubscriptionsViewController.swift
//  Vega
//
//  Created by Alexander on 30.05.2020.
//  Copyright © 2020 Alexander. All rights reserved.
//

import UIKit

class SubscriptionsViewController: UIViewController {
    
    private let cellId = "cellId"
    
    private var allDisciplines: [Discipline] = []
    private var myDisciplines: [Discipline] = []
    private var disciplines: [Discipline] = []
    private var pickedDisciplines: [Discipline] = []
    
    lazy var checked = [Bool].init(repeating: false, count: allDisciplines.count)
    
    var tableView: UITableView!
    
    private let segmentedControl: UISegmentedControl = {
        let control = UISegmentedControl(items: ["Мои дисциплины", "Все дисциплины"])
        control.translatesAutoresizingMaskIntoConstraints = false
        return control
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupUI()
        fetchDisciplines()
        segmentedControl.addTarget(self, action: #selector(handleControl(_:)), for: .valueChanged)

        let rightButton = UIBarButtonItem(title: "Подписаться", style: .plain, target: self, action: #selector(handleConfirmButtonTapped))
        self.navigationItem.rightBarButtonItem = rightButton
        self.navigationItem.rightBarButtonItem?.isEnabled = false
        
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
        navigationItem.largeTitleDisplayMode = .never
        
        view.addSubview(segmentedControl)
        segmentedControl.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        segmentedControl.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        segmentedControl.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        segmentedControl.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        view.addSubview(tableView)
        tableView.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor, constant: 8).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
    }
    
    @objc private func handleControl(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            disciplines = myDisciplines
            self.navigationItem.rightBarButtonItem?.isEnabled = false
        } else {
            disciplines = allDisciplines
            self.navigationItem.rightBarButtonItem?.isEnabled = true
        }
        tableView.reloadData()
    }
    
    @objc private func handleConfirmButtonTapped() {
//        let picked = pickedDisciplines.compactMap { Int($0.id) }
//        print(picked)
//        NetworkManager.shared.subscribeTo(disciplines: "119, 120") { (good) in
//            print(good)
//        }
    }
    
}

extension SubscriptionsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return disciplines.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        cell.textLabel?.text = disciplines[indexPath.row].title
        cell.selectionStyle = .none
        cell.textLabel?.numberOfLines = 0
        
        if !checked[indexPath.row] {
            cell.accessoryType = .none
        } else if checked[indexPath.row] {
            cell.accessoryType = .checkmark
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) {
            if cell.accessoryType == .checkmark {
                cell.accessoryType = .none
                checked[indexPath.row] = false
            } else {
                cell.accessoryType = .checkmark
                checked[indexPath.row] = true
            }
        }
        
//        let discipline = disciplines[indexPath.row]
//        if pickedDisciplines.contains(discipline) {
//            if let index = pickedDisciplines.firstIndex(of: discipline) {
//                pickedDisciplines.remove(at: index)
//            }
//        } else {
//            pickedDisciplines.append(discipline)
//        }
    }
    
}

extension SubscriptionsViewController {
    
    private func fetchDisciplines() {
//        fetchSubscribedDisciplines()
//        fetchAllDisciplines()
    }
    
//    private func fetchSubscribedDisciplines() {
//        NetworkManager.shared.fetchSubscribedDisciplines { (response) in
//            self.myDisciplines = response?.subscribedDisciplines ?? []
//        }
//    }
//
//    private func fetchAllDisciplines() {
//        NetworkManager.shared.fetchDisciplines { (response) in
//            self.allDisciplines = response?.disciplines ?? []
//        }
//    }
    
}
