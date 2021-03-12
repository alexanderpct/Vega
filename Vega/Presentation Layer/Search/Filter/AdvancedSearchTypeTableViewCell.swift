//
//  AdvancedSearchTextFieldTableViewCell.swift
//  Vega
//
//  Created by Peter Kvasnikov on 17.02.2021.
//

import UIKit

protocol TypeOptionsDelegate: AnyObject {
    func didTyped(title: String, checkedParametrs: String)
}

class AdvancedSearchTypeTableViewCell: UITableViewCell {
    
    weak var typeOptionsDelegate: TypeOptionsDelegate?
    
    let label: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18)
        label.numberOfLines = 1
        label.textAlignment = .natural
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = ""
        return label
    }()
    
    let textField: UITextField = {
        let tf = UITextField()
        tf.textAlignment = .left
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.isUserInteractionEnabled = true
        return tf
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubview(label)
        label.topAnchor.constraint(equalTo: topAnchor, constant: 8).isActive = true
        label.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8).isActive = true
        label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16).isActive = true
        label.widthAnchor.constraint(equalToConstant: 150).isActive = true
        
        addSubview(textField)
        textField.topAnchor.constraint(equalTo: label.topAnchor).isActive = true
        textField.bottomAnchor.constraint(equalTo: label.bottomAnchor).isActive = true
        textField.leadingAnchor.constraint(equalTo: label.trailingAnchor, constant: 8).isActive = true
        textField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8).isActive = true
        
        textField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        typeOptionsDelegate?.didTyped(title: label.text!, checkedParametrs: textField.text ?? "")
        
    }
    
    
    func configure(title: String, row: Int, searchQuery: SearchQuery) {
        label.text = title
        textField.placeholder = "Введите текст"
        
        if row == 2 {
            textField.text = searchQuery.title
        } else if row == 9 {
            textField.text = searchQuery.comments
        } else if row == 11 {
            textField.text = searchQuery.code
        } else if row == 1 {
            textField.text = searchQuery.authors.joined(separator: ", ")
        } else if row == 0 {
            textField.text = searchQuery.searchText
        }
        
        
    }
    
    func configurefromPickFilterVC(checkedParametrs: String) {
        label.text = "Значение:"
        textField.placeholder = "Введите текст"
        textField.text = checkedParametrs
    }
    
}
