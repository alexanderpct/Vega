//
//  Comment.swift
//  Vega
//
//  Created by Alexander Parnev on 25.09.2020.
//  Copyright © 2020 Alexander. All rights reserved.
//

import Foundation

struct Comment {
    let id: String
    let username: String
    let comment: String

    init(from dto: CommentDTO) {
        id = dto.userId
        username = dto.username
        comment = dto.comment
    }
}
