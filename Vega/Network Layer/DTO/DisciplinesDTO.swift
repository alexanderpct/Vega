//
//  DisciplinesDTO.swift
//  Vega
//
//  Created by Alexander Parnev on 19.10.2020.
//

import Foundation

// MARK: - All Disciplines
typealias AllDisciplinesDTO = [DisciplineDTO]


// MARK: - Subscribed Disciplines
struct SubscribedDisciplinesDTO: Codable {
    let subscribedDisciplines: [DisciplineDTO]
    let delivery: String

    enum CodingKeys: String, CodingKey {
        case subscribedDisciplines = "subscribed-disciplines"
        case delivery
    }
}


// MARK: - Discipline
struct DisciplineDTO: Codable, Equatable {
    let id: String
    let title: String
}
