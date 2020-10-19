//
//  History.swift
//  Vega
//
//  Created by Alexander on 29.11.2019.
//  Copyright © 2019 Alexander. All rights reserved.
//

import Foundation

// MARK: - Welcome
struct AllHistories: Codable {
    let history: [History]
    let count: String
}

// MARK: - History
struct History: Codable {
    let id, timestamp: String
    let request: Request
}

// MARK: - Request
struct Request: Codable {
    let keywords: [Bool]
    let disciplines, themes, doctypes, users: [Int]
    let uploadTimeCond, uploadTimeParam: String
    let authors: [Bool]
    let title, publicationDateCond, publicationDateParam, comments: String
    let ratingCond, ratingParam, sortOrder: String
    
    enum CodingKeys: String, CodingKey {
        case keywords, disciplines, themes, doctypes, users
        case uploadTimeCond = "upload-time-cond"
        case uploadTimeParam = "upload-time-param"
        case authors, title
        case publicationDateCond = "publication-date-cond"
        case publicationDateParam = "publication-date-param"
        case comments
        case ratingCond = "rating-cond"
        case ratingParam = "rating-param"
        case sortOrder = "sort-order"
    }
}
