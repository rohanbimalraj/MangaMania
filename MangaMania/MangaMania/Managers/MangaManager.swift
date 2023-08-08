//
//  MangaManager.swift
//  MangaMania
//
//  Created by Rohan Bimal Raj on 24/07/23.
//

import SwiftUI
import SwiftSoup

struct TopManga: Identifiable {
    let id = UUID()
    let title: String?
    let coverUrl: String?
    let detailsUrl: String?
}

final class MangaManager: ObservableObject{
    
        
    func getTopMangas() async throws -> [TopManga] {
        
        guard let url = URL(string: "https://m.manganelo.com/genre-all?type=topview") else {
            throw AppErrors.internalError
        }
        
        do {
            
            let (data, _) = try await URLSession.shared.data(from: url)
            guard let html = String(data: data, encoding: .utf8) else {
                throw AppErrors.internalError
            }
            let doc: Document = try SwiftSoup.parse(html)
            
            let mangas = try doc.getElementsByClass("content-genres-item").select("> a")
            var topMangas: [TopManga] = []
            
            try mangas.forEach { manga in
                let detailUrl = try manga.attr("href")
                let title = try manga.select("img").attr("alt")
                let coverUrl = try manga.select("img").attr("src")
                topMangas.append(TopManga(title: title, coverUrl: coverUrl, detailsUrl: detailUrl))
            }
            
            return topMangas
            
        }catch {
            throw error
        }
    }
}
