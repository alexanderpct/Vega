//
//  CommentDTO.swift
//  Vega
//
//  Created by Alexander Parnev on 25.09.2020.
//  Copyright © 2020 Alexander. All rights reserved.
//

import Foundation

struct CommentDTO: Decodable {
    let userID, userName, comment, updated: String

    enum CodingKeys: String, CodingKey {
        case userID = "user-id"
        case userName = "user-name"
        case comment, updated
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        userID = try container.decode(String.self, forKey: .userID)
        userName = try container.decode(String.self, forKey: .userName)
        comment = try container.decode(String.self, forKey: .comment)
        updated = try container.decode(String.self, forKey: .updated)
        
    }
}
