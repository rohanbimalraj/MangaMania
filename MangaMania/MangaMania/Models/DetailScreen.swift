//
//  DetailScreen.swift
//  MangaMania
//
//  Created by Rohan Bimal Raj on 08/06/25.
//

import Foundation

struct DetailScreen: Codable {
    let imageQuery: String
    let imageAttr: String
    let titleQuery: String
    let infoQuery: String
    let infoLabelQuery: String
    let authorsQuery: String
    let statusQuery: String
    let updatedDateQuery: String
    let ratingQuery: String
    let descriptionQuery: String
    let descriptionReplacementText: String
    let chaptersQuery: String
    let chapTitleQuery: String
    let chapUrlQuery: String
    let chapUrlAttr: String
    let chapDateQuery: String

    enum CodingKeys: String, CodingKey {
        case imageQuery = "image_query"
        case imageAttr = "image_attr"
        case titleQuery = "title_query"
        case infoQuery = "info_query"
        case infoLabelQuery = "info_label_query"
        case authorsQuery = "authors_query"
        case statusQuery = "status_query"
        case updatedDateQuery = "updatedDate_query"
        case ratingQuery = "rating_query"
        case descriptionQuery = "description_query"
        case descriptionReplacementText = "d_replacement_text"
        case chaptersQuery = "chapters_query"
        case chapTitleQuery = "chap_title_query"
        case chapUrlQuery = "chap_url_query"
        case chapUrlAttr = "chap_url_attr"
        case chapDateQuery = "chap_date_query"
    }
}

extension DetailScreen {
    static let `default` = DetailScreen(
        imageQuery: "",
        imageAttr: "",
        titleQuery: "",
        infoQuery: "",
        infoLabelQuery: "",
        authorsQuery: "",
        statusQuery: "",
        updatedDateQuery: "",
        ratingQuery: "",
        descriptionQuery: "",
        descriptionReplacementText: "",
        chaptersQuery: "",
        chapTitleQuery: "",
        chapUrlQuery: "",
        chapUrlAttr: "",
        chapDateQuery: ""
    )
}
