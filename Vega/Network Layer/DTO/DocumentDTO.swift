//
//  DocumentDTO.swift
//  Vega
//
//  Created by Alexander Parnev on 25.09.2020.
//  Copyright © 2020 Alexander. All rights reserved.
//

import Foundation

struct AllDocumentsDTO: Decodable {
    let batchSize: String
    let batchStart: String
    let documents: [DocumentDTO]
    let resultKeywords: [String]
    let totalCount: String
    let requestID: String

    enum CodingKeys: String, CodingKey {
        case batchSize = "batch-size"
        case batchStart = "batch-start"
        case documents = "result-docs"
        case resultKeywords = "result-keywords"
        case totalCount = "total-count"
        case requestID = "request_id"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        batchSize = try container.decode(String.self, forKey: .batchSize)
        batchStart = try container.decode(String.self, forKey: .batchStart)
        documents = try container.decode([DocumentDTO].self, forKey: .documents)
        resultKeywords = try container.decode([String].self, forKey: .resultKeywords)
        totalCount = try container.decode(String.self, forKey: .totalCount)
        requestID = try container.decode(String.self, forKey: .requestID)
    }


}

// MARK: - ResultDoc
struct DocumentDTO: Decodable {
    let id: String
    let title: String
    let descriptionHeader: String
    let descriptionBody: String?
    let keywords: [String]
    let comments: [CommentDTO]
    let rating: String
    let code: String?
    let url: String?

    enum CodingKeys: String, CodingKey {
        case id
        case title
        case descriptionHeader = "description_header"
        case descriptionBody = "description_body"
        case keywords
        case comments
        case rating
        case code
        case url
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        id = try container.decode(String.self, forKey: .id)
        title = try container.decode(String.self, forKey: .title)
        descriptionHeader = try container.decode(String.self, forKey: .descriptionHeader)
        descriptionBody = try? container.decode(String.self, forKey: .descriptionBody)
        keywords = try container.decode([String].self, forKey: .keywords)
        comments = try container.decode([CommentDTO].self, forKey: .comments)
        rating = try container.decode(String.self, forKey: .rating)
        code = try? container.decode(String.self, forKey: .code)
        url = try? container.decode(String.self, forKey: .url)
    }

}


