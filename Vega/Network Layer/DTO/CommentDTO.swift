//
//  CommentDTO.swift
//  Vega
//
//  Created by Alexander Parnev on 25.09.2020.
//  Copyright © 2020 Alexander. All rights reserved.
//

import Foundation

struct CommentDTO: Decodable {
    let userId: String
    let username: String
    let comment: String

    enum CodingKeys: String, CodingKey {
        case userId = "userid"
        case username
        case comment
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        userId = try container.decode(String.self, forKey: .userId)
        username = try container.decode(String.self, forKey: .username)
        comment = try container.decode(String.self, forKey: .comment)
    }
}
