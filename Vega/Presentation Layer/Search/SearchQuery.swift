//
//  SearchQuery.swift
//  Vega
//
//  Created by Peter Kvasnikov on 10.02.2021.
//

import Foundation

struct SearchQuery {
    var keywords: [String] = []
    var disciplinesIDs: [Int] = []
    var disciplinesTitles: [String] = []
    var themesIDs: [Int] = []
    var themesTitles: [String] = []
    var docTypesIDs: [Int] = []
    var docTypesTitles: [String] = []
    var usersIDs: [Int] = []
    var usersTitles: [String] = []
    var uploadTimeCond: Int = 0 // before|after|equal|null
    var uploadTimeParam: String = ""
    var authors : [String] = []
    var title: String = ""
    var publicationDateCond: Int = 0 // before|after|equal|null
    var publicationDateParam: String = ""
    var comments: String = ""
    var ratingCond: Int = 0 // less|more|equal|null
    var ratingParam: String = ""
    var sortOrder: Int = 1 // relevance|title|novelty|null
    var code: String = "" //
    var searchText: String = ""
}
