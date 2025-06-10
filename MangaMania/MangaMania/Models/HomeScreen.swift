//
//  HomeScreen.swift
//  MangaMania
//
//  Created by Rohan Bimal Raj on 08/06/25.
//

import Foundation

struct HomeScreen: Codable {
    let url: String
    let paramKey: String
    let listQuery: String
    let detailQuery: String
    let detailAttr: String
    let titleQuery: String
    let titleAttr: String
    let imageQuery: String
    let imageAttr: String
    
    enum CodingKeys: String, CodingKey {
        case url
        case paramKey = "param_key"
        case listQuery = "list_query"
        case detailQuery = "detail_query"
        case detailAttr = "detail_attr"
        case titleQuery = "title_query"
        case titleAttr = "title_attr"
        case imageQuery = "image_query"
        case imageAttr = "image_attr"
    }
}

extension HomeScreen {
    static let `default` = HomeScreen(
        url: "",
        paramKey: "",
        listQuery: "",
        detailQuery: "",
        detailAttr: "",
        titleQuery: "",
        titleAttr: "",
        imageQuery: "",
        imageAttr: ""
    )
}
