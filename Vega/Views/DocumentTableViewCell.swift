//
//  DocumentTableViewCell.swift
//  Vega
//
//  Created by Alexander on 07.06.2020.
//  Copyright © 2020 Alexander. All rights reserved.
//

import UIKit

class DocumentTableViewCell: UITableViewCell {
    
    let commentLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let authorLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .right
        label.textColor = .lightGray
        label.font = .systemFont(ofSize: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubview(authorLabel)
        authorLabel.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        authorLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12).isActive = true
        authorLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12).isActive = true
        authorLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
                
        addSubview(commentLabel)
        commentLabel.topAnchor.constraint(equalTo: topAnchor).isActive = true
        commentLabel.leadingAnchor.constraint(equalTo: authorLabel.leadingAnchor).isActive = true
        commentLabel.trailingAnchor.constraint(equalTo: authorLabel.trailingAnchor).isActive = true
        commentLabel.bottomAnchor.constraint(equalTo: authorLabel.topAnchor).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
