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

    init(from dto: AllDisciplinesDTO) {
        disciplines = dto.map { Discipline(from: $0) }
    }
}


// MARK: - Subscribed Disciplines
struct SubscribedDisciplines {
    let subscribedDisciplines: [Discipline]
    let delivery: String

    init(from dto: SubscribedDisciplinesDTO) {
        subscribedDisciplines = dto.subscribedDisciplines.map { Discipline(from: $0) }
        delivery = dto.delivery ?? "1" //когда отписываемся ото всех дисциплин приходит NULL
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
