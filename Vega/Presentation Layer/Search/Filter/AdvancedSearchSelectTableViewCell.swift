//
//  AdvancedSearchTableViewCell.swift
//  Vega
//
//  Created by Peter Kvasnikov on 29.10.2020.
//

import UIKit

class AdvancedSearchSelectTableViewCell: UITableViewCell {
    
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
    
    func configure(title: String, searchQuery: SearchQuery, section: Int, row: Int){
        self.title.text = title
        self.selectedFilters.text = "Не выбрано"
        self.selectedFilters.textColor = .lightGray
        if row == 7 {
            let selectedFilters = searchQuery.usersTitles.joined(separator: ", ")
            if selectedFilters != "" {
                self.selectedFilters.text = selectedFilters
                self.selectedFilters.textColor = .darkGray
            }
            
        } else if row == 4 {
            let selectedFilters = searchQuery.docTypesTitles.joined(separator: ", ")
            if selectedFilters != "" {
                self.selectedFilters.text = selectedFilters
                self.selectedFilters.textColor = .darkGray
            }
            
        } else if row == 6 {
            let selectedFilters = searchQuery.disciplinesTitles.joined(separator: ", ")
            if selectedFilters != "" {
                self.selectedFilters.text = selectedFilters
                self.selectedFilters.textColor = .darkGray
            }
        } else if row == 5 {
            let selectedFilters = searchQuery.themesTitles.joined(separator: ", ")
            if selectedFilters != "" {
                self.selectedFilters.text = selectedFilters
                self.selectedFilters.textColor = .darkGray
            }
        } else if row == 3 {
            let conditionTimeTitles = ["не выбрано", "до", "после", "равно"]
            
            let selectedFilters = conditionTimeTitles[searchQuery.publicationDateCond] + " " + searchQuery.publicationDateParam
            if selectedFilters != "" {
                self.selectedFilters.text = selectedFilters
                self.selectedFilters.textColor = .darkGray
            }
            
            if conditionTimeTitles[searchQuery.publicationDateCond] == "не выбрано" {
                self.selectedFilters.textColor = .lightGray
                self.selectedFilters.text = conditionTimeTitles[searchQuery.publicationDateCond]
            }
            
        } else if row == 8 {
            let conditionTimeTitles = ["не выбрано", "до", "после", "равно"]
            
            let selectedFilters = conditionTimeTitles[searchQuery.uploadTimeCond] + " " + searchQuery.uploadTimeParam
            if selectedFilters != "" {
                self.selectedFilters.text = selectedFilters
                self.selectedFilters.textColor = .darkGray
            }
            
            if conditionTimeTitles[searchQuery.uploadTimeCond] == "не выбрано" {
                self.selectedFilters.textColor = .lightGray
                self.selectedFilters.text = conditionTimeTitles[searchQuery.uploadTimeCond]
            }
        } else if row == 10 {
            let conditionRatingTitles = ["не выбрано", "меньше", "больше", "равно"]
            
            let selectedFilters = conditionRatingTitles[searchQuery.ratingCond] + " " + searchQuery.ratingParam
            if selectedFilters != "" {
                self.selectedFilters.text = selectedFilters
                self.selectedFilters.textColor = .darkGray
            }
            
            if conditionRatingTitles[searchQuery.ratingCond] == "не выбрано" {
                self.selectedFilters.textColor = .lightGray
                self.selectedFilters.text = conditionRatingTitles[searchQuery.ratingCond]
            }
        }
    }
}
