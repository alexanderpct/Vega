//
//  InitialForms.swift
//  Vega
//
//  Created by Peter Kvasnikov on 18.12.2020.
//

import Foundation

struct InitialForms: Codable {
    let terms: [Term]
    let shingles2, shingles3: [Shingles]
    let termsSum, shingles2Sum, shingles3Sum: String

    enum CodingKeys: String, CodingKey {
        case terms, shingles2, shingles3
        case termsSum = "terms_sum"
        case shingles2Sum = "shingles2_sum"
        case shingles3Sum = "shingles3_sum"
    }
}

// MARK: - Shingles
struct Shingles: Codable {
    let origNum, orig, norm: String
    let part1, part2, occurences: Int
    let part3: Int?

    enum CodingKeys: String, CodingKey {
        case origNum = "orig_num"
        case orig, norm, part1, part2, occurences, part3
    }
}

// MARK: - Term
struct Term: Codable {
    let norm, part, occurences: String
    let forms: [String]
}

