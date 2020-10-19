//
//  Updates.swift
//  Vega
//
//  Created by Alexander on 01.06.2020.
//  Copyright © 2020 Alexander. All rights reserved.
//

import Foundation

struct AllUpdates: Codable {
    internal init(updates: [Update], count: String) {
        self.updates = updates
        self.count = count
    }
    
    let updates: [Update]
    let count: String
}

// MARK: - Update
struct Update: Codable {
    let id, title, descriptionHeader, descriptionBody: String
    let disciplines: [Int]
    let mark: String

    enum CodingKeys: String, CodingKey {
        case id, title
        case descriptionHeader = "description_header"
        case descriptionBody = "description_body"
        case disciplines
        case mark
    }
}
