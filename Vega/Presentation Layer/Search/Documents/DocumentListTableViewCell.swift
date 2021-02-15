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
        let thumbs = UIImage(named: "thumbup")
        let thumbsup = UIImageView(image: thumbs)
        thumbsup.image = thumbsup.image?.withRenderingMode(.alwaysTemplate)
        thumbsup.tintColor = UIColor.gray
        return thumbsup
    }()
    
    private let commentsIcon: UIImageView = {
        let comment = UIImage(named: "comment")
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
        
        bottomStackView.setCustomSpacing(3, after: thumbsupIcon)
        bottomStackView.setCustomSpacing(15, after: ratingLabel)
        bottomStackView.setCustomSpacing(3, after: commentsIcon)
   
    
        

        let stackView = UIStackView(arrangedSubviews: [headerLabel, descriptionLabel, bottomStackView])
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        
        thumbsupIcon.contentMode = .scaleAspectFit
        commentsIcon.contentMode = .scaleAspectFit

        stackView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -36),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor),

            thumbsupIcon.widthAnchor.constraint(equalToConstant: 20),
            commentsIcon.widthAnchor.constraint(equalToConstant: 24),
            ratingLabel.widthAnchor.constraint(equalToConstant: 15)
            
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


extension UIImageView {
    func load(url: URL) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
}
