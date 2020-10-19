//
//  DisciplinesDTO.swift
//  Vega
//
//  Created by Alexander Parnev on 04.10.2020.
//  Copyright © 2020 Alexander. All rights reserved.
//

import Foundation

// MARK: - All Disciplines
struct AllDisciplines    {
    let disciplines: [Discipline]
    let count: String

    init(from dto: AllDisciplinesDTO) {
        disciplines = dto.disciplines.map { Discipline(from: $0) }
        count = dto.count
    }
}


// MARK: - Subscribed Disciplines
struct SubscribedDisciplines {
    let count: String
    let subscribedDisciplines: [Discipline]
    let delivery: String

    init(from dto: SubscribedDisciplinesDTO) {
        count = dto.count
        subscribedDisciplines = dto.subscribedDisciplines.map { Discipline(from: $0) }
        delivery = dto.delivery
    }
}


// MARK: - Discipline
struct Discipline {
    let id, title: String

    init(from dto: DisciplineDTO) {
        id = dto.id
        title = dto.title
    }
}
