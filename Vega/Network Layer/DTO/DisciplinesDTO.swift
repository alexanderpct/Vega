//
//  DisciplinesDTO.swift
//  Vega
//
//  Created by Alexander Parnev on 19.10.2020.
//

import Foundation

// MARK: - All Disciplines
struct AllDisciplinesDTO: Codable {
    let disciplines: [DisciplineDTO]
    let count: String
}


// MARK: - Subscribed Disciplines
struct SubscribedDisciplinesDTO: Codable {
    let count: String
    let subscribedDisciplines: [DisciplineDTO]
    let delivery: String

    enum CodingKeys: String, CodingKey {
        case count
        case subscribedDisciplines = "subscribed-disciplines"
        case delivery
    }
}


// MARK: - Discipline
struct DisciplineDTO: Codable, Equatable {
    let id, title: String
}
