//
//  DisciplinesTableViewCell.swift
//  Vega
//
//  Created by Alexander on 15.11.2019.
//  Copyright © 2019 Alexander. All rights reserved.
//

import UIKit

class DisciplinesTableViewCell: UITableViewCell {
    
    let label: UILabel = {
        let label = UILabel()
        label.backgroundColor = .red
        label.text = "Some text"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubview(label)
        label.topAnchor.constraint(equalTo: topAnchor, constant: 4).isActive = true
        label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8).isActive = true
        label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8).isActive = true
        label.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8).isActive = true
        label.heightAnchor.constraint(greaterThanOrEqualToConstant: 80).isActive = true
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
