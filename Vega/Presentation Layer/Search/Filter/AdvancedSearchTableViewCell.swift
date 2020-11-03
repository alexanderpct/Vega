//
//  AdvancedSearchTableViewCell.swift
//  Vega
//
//  Created by Peter Kvasnikov on 29.10.2020.
//

import UIKit

class AdvancedSearchTableViewCell: UITableViewCell {
    
    private let title: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20)
        label.numberOfLines = 1
        label.textAlignment = .natural
        return label
    }()
    
    private let selectedFilters: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17)
        label.numberOfLines = 2
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        let stackView = UIStackView(arrangedSubviews: [title,
                                                       selectedFilters])
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(stackView)
        
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -36),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10)
        ])
        
        accessoryType = .disclosureIndicator
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(title: String, selectedFilters: String, section: Int, row: Int){
        self.title.text = title
        self.selectedFilters.text = "Не выбрано"
        self.selectedFilters.textColor = .lightGray
        if section == 0 && row == 0 {
            if selectedFilters != "" {
                self.selectedFilters.text = selectedFilters
                self.selectedFilters.textColor = .darkGray
            }
            
        }

    }


}
