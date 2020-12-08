//
//  DocumentDTO.swift
//  Vega
//
//  Created by Alexander Parnev on 25.09.2020.
//  Copyright © 2020 Alexander. All rights reserved.
//

import Foundation

struct AllDocumentsDTO: Decodable {
    let totalCount, requestID, batchStart, batchSize: String
        let documents: [DocumentDTO]
        let resultKeywords: [String]

    enum CodingKeys: String, CodingKey {
        case totalCount = "total-count"
        case requestID = "request-id"
        case batchStart = "batch-start"
        case batchSize = "batch-size"
        case documents = "result-docs"
        case resultKeywords = "result-keywords"
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
    let id, title, descriptionHeader: String
        let descriptionBody, code: String?
        let url: String?
        let reqRel: String
        let keywords: [String]
        let comments: [CommentDTO]
        let rating: String?

    enum CodingKeys: String, CodingKey {
        case id, title
        case descriptionHeader = "description-header"
        case descriptionBody = "description-body"
        case code, url
        case reqRel = "req-rel"
        case keywords, comments, rating
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        id = try container.decode(String.self, forKey: .id)
        title = try container.decode(String.self, forKey: .title)
        descriptionHeader = try container.decode(String.self, forKey: .descriptionHeader)
        descriptionBody = try? container.decode(String.self, forKey: .descriptionBody)
        keywords = try container.decode([String].self, forKey: .keywords)
        comments = try container.decode([CommentDTO].self, forKey: .comments)
        rating = try? container.decode(String.self, forKey: .rating)
        code = try? container.decode(String.self, forKey: .code)
        url = try? container.decode(String.self, forKey: .url)
        reqRel = try container.decode(String.self, forKey: .reqRel)
    }

}


