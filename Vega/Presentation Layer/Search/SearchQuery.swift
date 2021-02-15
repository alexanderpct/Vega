//
//  SearchQuery.swift
//  Vega
//
//  Created by Peter Kvasnikov on 10.02.2021.
//

import Foundation
// - задается пользователем

struct SearchQuery {
    var keywords: [String] = [] //
    var disciplinesIDs: [Int] = [] //
    var disciplinesTitles: [String] = []
    var themesIDs: [Int] = [] //
    var themesTitles: [String] = []
    var docTypesIDs: [Int] = [] //
    var docTypesTitles: [String] = []
    var usersIDs: [Int] = [] //
    var usersTitles: [String] = []
    var uploadTimeCond: Int = 0
    var uploadTimeParam: String = ""
    var authors : [String] = []
    var title: String = ""
    var publicationDateCond: Int = 0
    var publicationDateParam: String = ""
    var comments: String = ""
    var ratingCond: Int = 0
    var ratingParam: Int = 0
    var sortOrder: Int = 1
    var code: String = ""
}
