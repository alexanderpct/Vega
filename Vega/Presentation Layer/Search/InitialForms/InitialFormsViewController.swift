//
//  IFViewController.swift
//  Vega
//
//  Created by Peter Kvasnikov on 27.12.2020.
//

import UIKit

class InitialFormsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    private let tableView: UITableView = {
        let tableView = UITableView(frame: CGRect.zero, style: .grouped)
        return tableView
    }()
    
    private let cellId = "cellId"
    
    var search: [String]
    var initialFroms: [String]
    
    var initialFormsDataArray: [[String]]
    
    
    init(search: [String], initialFroms: [String], initialFormsDataArray: [[String]]) {
        self.search = search
        self.initialFroms = initialFroms
        self.initialFormsDataArray = initialFormsDataArray
        super.init(nibName: nil, bundle: nil)

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.topItem?.title = "Начальные формы"
        setupTableView()
        

    }
    
    private func setupTableView() {
        view.addSubview(tableView)
        tableView.frame = view.frame
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(InitialFormsTableViewCell.self, forCellReuseIdentifier: cellId)
    
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if search.count == 0 {
            return 1
        } else {
            if section == 0 {
                return 1
            } else {
            return initialFormsDataArray.count
            }
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if search.count == 0 {
            return 1
        } else {
            return 2
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if search.count == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! InitialFormsTableViewCell
            cell.textLabel!.text = "Поисковой запрос не задан"
            cell.isUserInteractionEnabled = false
            cell.textLabel!.textAlignment = .center
            return cell
        } else {
            if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! InitialFormsTableViewCell
                cell.isUserInteractionEnabled = false
            cell.configure(search: search.joined(separator:", "), initialForms: initialFroms.joined(separator:", "))
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! InitialFormsTableViewCell
                cell.isUserInteractionEnabled = false
                let temp = Array(initialFormsDataArray[indexPath.row].dropFirst(1))
                cell.configure(search: initialFormsDataArray[indexPath.row][0], initialForms: temp.joined(separator:", "))
                return cell
            }
            

        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
            case 0: return "Общий вид"
            case 1: return "По частям"
        default: return ""
        }
    }
    


}
