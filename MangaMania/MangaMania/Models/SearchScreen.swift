//
//  SearchScreen.swift
//  MangaMania
//
//  Created by Rohan Bimal Raj on 08/06/25.
//

import Foundation

struct SearchScreen: Codable {
    let url: String
    let resultsQuery: String
    let titleQuery: String
    let detailQuery: String
    let detailAttr: String
    let imageQuery: String
    let imageAttr: String

    enum CodingKeys: String, CodingKey {
        case url
        case resultsQuery = "results_query"
        case titleQuery = "title_query"
        case detailQuery = "detail_query"
        case detailAttr = "detail_attr"
        case imageQuery = "image_query"
        case imageAttr = "image_attr"
    }
}

extension SearchScreen {
    static let `default` = SearchScreen(
        url: "",
        resultsQuery: "",
        titleQuery: "",
        detailQuery: "",
        detailAttr: "",
        imageQuery: "",
        imageAttr: ""
    )
}
