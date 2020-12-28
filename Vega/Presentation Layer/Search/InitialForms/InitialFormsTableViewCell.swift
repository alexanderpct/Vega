//
//  SummaryTableViewCell.swift
//  Vega
//
//  Created by Peter Kvasnikov on 27.12.2020.
//

import UIKit

class InitialFormsTableViewCell: UITableViewCell {
   
    private let searchLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13)
        label.numberOfLines = 3
        label.textAlignment = .center
        label.textColor = .systemRed
        return label
    }()
    
    private let initialFormsTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15)
        label.textAlignment = .center
        label.textColor = .systemBlue
        return label
    }()
    
    private let initialFormsLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12)
        label.numberOfLines = 3
        label.textAlignment = .center
        label.textColor = .systemGreen
        return label
    }()
    

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        let stackView = UIStackView(arrangedSubviews: [searchLabel, initialFormsTitleLabel, initialFormsLabel])
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10),

        ])

        
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(search: String, initialForms: String) {
        searchLabel.text = search
        initialFormsTitleLabel.text = "↓"
        initialFormsLabel.text = initialForms

    }
    
    

}
