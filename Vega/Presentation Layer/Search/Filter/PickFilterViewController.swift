//
//  PickFilterViewController.swift
//  Vega
//
//  Created by Peter Kvasnikov on 20.02.2021.
//

import UIKit

protocol PickerFilterVCtoAdvansedSearchVCDelegate: AnyObject {
    func transfer(checkType: CheckType, checkedParametrs: String, checkedCond: Int)
}

class PickFilterViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    private let tableView: UITableView = {
        let tableView = UITableView(frame: CGRect.zero, style: .grouped)
        return tableView
    }()
    
    let cellId1 = "cellId1"
    let cellId2 = "cellId2"
    
    private var checkType: CheckType
    private var checkedParametrs: String
    private var checkedCond: Int
    
    let leftButton = UIBarButtonItem(image: UIImage(systemName: "chevron.left"), style: .plain, target: self, action: #selector(handleBackButtonTapped))
    let rightButton = UIBarButtonItem(title: "Выбрать", style: .plain, target: self, action: #selector(handleConfirmButtonTapped))
    
    weak var pickerFilterVCtoAdvansedSearchVCDelegate: PickerFilterVCtoAdvansedSearchVCDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        configureController()
        
        self.navigationItem.leftBarButtonItem = leftButton
        self.navigationItem.rightBarButtonItem = rightButton
        
        isConfirmButtonEnabled()
    }
    
    init(type: CheckType, checkedParametrs: String, checkedCond: Int) {
        self.checkType = type
        self.checkedParametrs = checkedParametrs
        self.checkedCond = checkedCond
        super.init(nibName: nil, bundle: nil)
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        let indexPath = IndexPath(row: 0, section: 0)
        tableView.selectRow(at: indexPath, animated: true, scrollPosition: .top)
        tableView.delegate?.tableView?(tableView, didSelectRowAt: indexPath)
    }
    
    private func setupTableView() {
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(PickTableViewCell.self, forCellReuseIdentifier: cellId1)
        tableView.register(AdvancedSearchTypeTableViewCell.self, forCellReuseIdentifier: cellId2)
        
    }
    
    private func configureController() {
        switch checkType {
        case .publicationDate:
            title = "Дата издания"
        case .rating:
            title = "Рейтинг"
        case .uploadTime:
            title = "Дата добавления"
        case .none:
            break
        }
    }
    
    private func isConfirmButtonEnabled() {
        if checkedParametrs == "" {
            rightButton.isEnabled = false
        } else {
            rightButton.isEnabled = true
        }
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        2
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0{
            return 100
        } else {
            return 70
        }
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: cellId1, for: indexPath) as! PickTableViewCell
            cell.isUserInteractionEnabled = true
            cell.checkOptionsDelegate = self
            cell.configure(checkType: checkType, checkedCond: checkedCond)
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: cellId2, for: indexPath) as! AdvancedSearchTypeTableViewCell
            cell.typeOptionsDelegate = self
            cell.configurefromPickFilterVC(checkedParametrs: checkedParametrs)
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            let cell = tableView.cellForRow(at: indexPath) as! PickTableViewCell
            cell.textField.becomeFirstResponder()
        } else {
            let cell = tableView.cellForRow(at: indexPath) as! AdvancedSearchTypeTableViewCell
            cell.textField.becomeFirstResponder()
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    
    
}

extension PickFilterViewController {
    @objc private func handleBackButtonTapped() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func handleConfirmButtonTapped() {
        pickerFilterVCtoAdvansedSearchVCDelegate?.transfer(checkType: checkType, checkedParametrs: checkedParametrs, checkedCond: checkedCond)
        dismiss(animated: true, completion: nil)
    }
}


extension PickFilterViewController: CheckOptionsDelegate {
    func didChecked(checkedCond: Int) {
        self.checkedCond = checkedCond
    }
    
}

extension PickFilterViewController: TypeOptionsDelegate {
    func didTyped(title: String, checkedParametrs: String) {
        self.checkedParametrs = checkedParametrs
        isConfirmButtonEnabled()
    }
    
}

