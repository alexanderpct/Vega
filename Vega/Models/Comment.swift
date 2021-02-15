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
    let userName: String
    let comment: String
    let updated: String

    init(from dto: CommentDTO) {
        id = dto.userID
        userName = dto.userName
        comment = dto.comment
        updated = dto.updated
    }
}
