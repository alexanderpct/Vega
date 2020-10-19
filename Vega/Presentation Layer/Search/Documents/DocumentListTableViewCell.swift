//
//  DocumentListTableViewCell.swift
//  Vega
//
//  Created by Alexander on 15.11.2019.
//  Copyright © 2019 Alexander. All rights reserved.
//

import UIKit


class DocumentListTableViewCell: UITableViewCell {

    // TODO: envelope
    private let headerLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20)
        label.numberOfLines = 2
        label.textAlignment = .natural
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17)
        label.numberOfLines = 2
        label.textColor = .gray
        return label
    }()
    
    private let ratingLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17)
        label.textColor = .gray
        return label
    }()
    
    private let thumbsupIcon: UIImageView = {
        let thumbs = UIImage(systemName: "envelope")
        let thumbsup = UIImageView(image: thumbs)
        thumbsup.image = thumbsup.image?.withRenderingMode(.alwaysTemplate)
        thumbsup.tintColor = UIColor.gray
        return thumbsup
    }()
    
    private let commentsIcon: UIImageView = {
        let comment = UIImage(systemName: "envelope")
        let commentImage = UIImageView(image: comment)
        commentImage.image = commentImage.image?.withRenderingMode(.alwaysTemplate)
        commentImage.tintColor = UIColor.gray
        return commentImage
    }()
    
    private let descriptionIcon: UIImageView = {
        let description = UIImage(systemName: "envelope")
        let descriptionImage = UIImageView(image: description)
        return descriptionImage
    }()
    
    private let commentsLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17)
        label.textColor = .gray
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        let bottomStackView = UIStackView(arrangedSubviews: [thumbsupIcon, ratingLabel, commentsIcon, commentsLabel])
        bottomStackView.distribution = .fillProportionally

        let stackView = UIStackView(arrangedSubviews: [headerLabel, descriptionLabel, bottomStackView])
        stackView.axis = .vertical
        stackView.distribution = .fillEqually

        stackView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -36),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor),

            thumbsupIcon.widthAnchor.constraint(equalToConstant: 30),
            commentsIcon.widthAnchor.constraint(equalToConstant: 30)
        ])

        accessoryType = .disclosureIndicator
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with header: String, description: String, rating: String, comments: String) {
        headerLabel.text = header
        descriptionLabel.text = description
        ratingLabel.text = rating
        commentsLabel.text = comments
    }

}
