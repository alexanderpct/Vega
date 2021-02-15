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
    private let networkService: VegaNetworkProtocol
    
    lazy var checked = [Bool].init(repeating: false, count: allDisciplines.count)
    
    var tableView: UITableView!
    
    private let segmentedControl: UISegmentedControl = {
        let control = UISegmentedControl(items: ["Мои дисциплины", "Все дисциплины"])
        control.translatesAutoresizingMaskIntoConstraints = false
        return control
    }()
    

    init(networkService: VegaNetworkProtocol) {
        self.networkService = networkService
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupUI()
        fetchDisciplines()
        segmentedControl.addTarget(self, action: #selector(handleControl(_:)), for: .valueChanged)

        let rightButton = UIBarButtonItem(title: "Подписаться", style: .plain, target: self, action: #selector(handleConfirmButtonTapped))
        self.navigationItem.rightBarButtonItem = rightButton
        self.navigationItem.rightBarButtonItem?.isEnabled = false
        
        segmentedControl.selectedSegmentIndex = 0
        disciplines = myDisciplines
        
        
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
        let picked = pickedDisciplines.compactMap { Int($0.id) }
        var string = "\(picked)"
        string.removeFirst()
        string.removeLast()
        self.networkService.subscribeTo(disciplines: string) { (good) in
            DispatchQueue.main.async{
                self.fetchDisciplines()
            }
        }

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
        
        if segmentedControl.selectedSegmentIndex == 0 {
            cell.accessoryType = .none
        } else {
            if pickedDisciplines.contains(where: { $0.title == disciplines[indexPath.row].title }){
                cell.accessoryType = .checkmark
                checked[indexPath.row] = true
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) {
            if segmentedControl.selectedSegmentIndex != 0 {
                if cell.accessoryType == .checkmark {
                    cell.accessoryType = .none
                    checked[indexPath.row] = false
                    if pickedDisciplines.contains(where: { $0.title == disciplines[indexPath.row].title }){
                        if let indexToRemove = pickedDisciplines.firstIndex(where: { $0.title == disciplines[indexPath.row].title }){
                            pickedDisciplines.remove(at: indexToRemove)
                        }
                    }
                } else {
                    cell.accessoryType = .checkmark
                    checked[indexPath.row] = true
                    pickedDisciplines.append(disciplines[indexPath.row])
                }
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
        fetchSubscribedDisciplines()
        fetchAllDisciplines()
    }
    
    private func fetchSubscribedDisciplines() {
        self.networkService.fetchSubscribedDisciplines { (disciplinesresult) in
            self.myDisciplines = disciplinesresult?.subscribedDisciplines.compactMap { Discipline(from: $0) } ?? []
            DispatchQueue.main.async{
                self.pickedDisciplines = self.myDisciplines
            }
        }
    }

    private func fetchAllDisciplines() {
        self.networkService.fetchDisciplines { (disciplines) in
            self.allDisciplines = disciplines?.compactMap { Discipline(from: $0) } ?? []
            DispatchQueue.main.async{
                self.segmentedControl.selectedSegmentIndex = 0
                self.disciplines = self.myDisciplines
                self.tableView.reloadData()
            }
        }
    }
 
}
