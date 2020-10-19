//
//  SearchModels.swift
//  Vega
//
//  Created by Alexander on 22.11.2019.
//  Copyright © 2019 Alexander. All rights reserved.
//

import Foundation

// MARK: - Doctypes
struct AllDocTypes: Codable {
    let doctypes: [Doctype]
    let count: String
}

struct Doctype: Codable {
    let id, title: String
}

// MARK: - Users
struct AllUsers: Codable {
    let users: [User]
    let count: String
}

struct User: Codable {
    let id, name: String
}

// MARK: - Theme
struct AllThemes: Codable {
    let themes: [Theme]
    let count: String
}

struct Theme: Codable {
    let id, index: String
    let title: String?
}
