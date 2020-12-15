//
//  SearchModels.swift
//  Vega
//
//  Created by Alexander on 22.11.2019.
//  Copyright © 2019 Alexander. All rights reserved.
//

import Foundation

// MARK: - Doctypes

typealias AllDocTypes = [DocType]


struct DocType: Codable {
    let id, title: String
}

// MARK: - Users
typealias AllUsers = [User]

struct User: Codable {
    let id, name: String
}

// MARK: - Theme
typealias AllThemes = [Theme]


struct Theme: Codable {
    let id, index: String
    let title: String?
}
