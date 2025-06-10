//
//  ChapterScreen.swift
//  MangaMania
//
//  Created by Rohan Bimal Raj on 08/06/25.
//

import Foundation

struct ChapterScreen: Codable {
    let pagesQuery: String
    let pageAttr: String

    enum CodingKeys: String, CodingKey {
        case pagesQuery = "pages_query"
        case pageAttr = "page_attr"
    }
}

extension ChapterScreen {
    static let `default` = ChapterScreen(
        pagesQuery: "",
        pageAttr: ""
    )
}
