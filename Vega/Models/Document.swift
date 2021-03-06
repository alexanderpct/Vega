//
//  Document.swift
//  Vega
//
//  Created by Alexander Parnev on 25.09.2020.
//  Copyright © 2020 Alexander. All rights reserved.
//

import Foundation

struct Document {
    let id: String
    let title: String
    let descriptionHeader: String
    let descriptionBody: String?
    let comments: [Comment]
    let rating: String
    let url: String?

    init(from dto: DocumentDTO) {
        id = dto.id
        title = dto.title
        descriptionHeader = dto.descriptionHeader
        descriptionBody = dto.descriptionBody
        comments = dto.comments.map() { Comment(from: $0) }
        rating = dto.rating
        url = dto.url
    }
}
