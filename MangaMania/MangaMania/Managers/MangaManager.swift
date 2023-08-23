//
//  MangaManager.swift
//  MangaMania
//
//  Created by Rohan Bimal Raj on 24/07/23.
//
import Kingfisher
import SwiftUI
import SwiftSoup

struct Manga: Identifiable {
    let id = UUID()
    let title: String?
    let coverUrl: String?
    let detailsUrl: String?
}

struct MangaDetail {
    
    struct Chapter: Identifiable {
        let id: UUID = UUID()
        let chapUrl: String?
        let chapTitle: String?
        let chapDate: String?
    }
    
    let coverUrl: String?
    let title: String?
    let authors: String?
    let status: String?
    let updatedDate: String?
    let rating: Int?
    let description: String?
    let chapters: [Chapter]?
    
}

final class MangaManager {
    
    private let baseUrl = "https://m.manganelo.com"
    
    static let shared = MangaManager()
    
    let chapterRequestModifier = AnyModifier { request in
        var r = request
        r.setValue("\"Not.A/Brand\";v=\"8\", \"Chromium\";v=\"114\", \"Google Chrome\";v=\"114\"", forHTTPHeaderField: "sec-ch-ua")
        r.setValue("https://chapmanganelo.com/", forHTTPHeaderField: "Referer")
        r.setValue("?0", forHTTPHeaderField: "sec-ch-ua-mobile")
        r.setValue("Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/114.0.0.0 Safari/537.36", forHTTPHeaderField: "User-Agent")
        r.setValue("sec-ch-ua-platform", forHTTPHeaderField: "\"macOS\"")
        return r
    }
    
    private init() {}
        
    func getTopMangas(in page: Int) async throws -> [Manga] {
        
        guard var url = URL(string: baseUrl) else {
            throw AppErrors.internalError
        }
        url.append(path: "genre-all")
        if page != 1 {
            url.append(path: String(page))
        }
        url.append(queryItems:
                    [
                        URLQueryItem(name: "type", value: "topview")
                    ]
        )
        
        do {
            
            let (data, _) = try await URLSession.shared.data(from: url)
            guard let html = String(data: data, encoding: .utf8) else {
                throw AppErrors.internalError
            }
            let doc: Document = try SwiftSoup.parse(html)
            
            let mangas = try doc.getElementsByClass("content-genres-item").select("> a")
            var topMangas: [Manga] = []
            
            try mangas.forEach { manga in
                let detailUrl = try manga.attr("href")
                let title = try manga.select("img").attr("alt")
                let coverUrl = try manga.select("img").attr("src")
                topMangas.append(Manga(title: title, coverUrl: coverUrl, detailsUrl: detailUrl))
            }
            
            return topMangas
            
        }catch {
            throw error
        }
    }
    
    func getMangaDetail(from url: String) async throws -> MangaDetail {
        
        guard let url = URL(string: url) else {
            throw AppErrors.internalError
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            
            guard let html = String(data: data, encoding: .utf8) else {
                throw AppErrors.internalError
            }
            
            let doc: Document = try SwiftSoup.parse(html)
            
            let mangaCover = try doc.getElementsByClass("info-image").select("> img").attr("src")
            let title = try doc.getElementsByClass("story-info-right").select("> h1").text()
            let elementArray = try doc.getElementsByClass("variations-tableInfo").select("> tbody").select("> tr")
            var authors = ""
            var status = ""
            
            try elementArray.forEach { element in
                let label = try element.select("td.table-label").text()
                switch label {
                case "Author(s) :":
                    authors = try element.select("td.table-value").text()
                case "Status :":
                    status = try element.select("td.table-value").text()
                default:
                    break
                }
            }
            
            let tempDateAndRating = try doc.getElementsByClass("story-info-right-extent").select("> p")
            let updatedDate = try tempDateAndRating[0].select("span.stre-value").text()
            let rating = try tempDateAndRating[3].select("> em").text()
            
            var description = try doc.getElementsByClass("panel-story-info-description").text()
            description = description.replacingOccurrences(of: "Description :", with: "")
            let tempChapters = try doc.getElementsByClass("row-content-chapter").select("> li")
            var chapters: [MangaDetail.Chapter] = []
            
            try tempChapters.forEach { chapter in
                let chapTitle = try chapter.select("> a").text()
                let chapUrl = try chapter.select("> a").attr("href")
                let chapDate = try chapter.select("span.chapter-time.text-nowrap").text()
                chapters.append(MangaDetail.Chapter(chapUrl: chapUrl, chapTitle: chapTitle, chapDate: chapDate))
            }
            
                        
            return MangaDetail(coverUrl: mangaCover, title: title, authors: authors, status: status, updatedDate: updatedDate, rating: getRequiredRating(from: rating), description: description, chapters: chapters)
            
        }catch {
            throw error
        }
    }
    
    func getMangaChapterPages(from url: String) async throws -> [String] {
        
        guard let url = URL(string: url) else {
            throw AppErrors.internalError
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            
            guard let html = String(data: data, encoding: .utf8) else {
                throw AppErrors.internalError
            }
            
            let doc: Document = try SwiftSoup.parse(html)
            let pages = try doc.getElementsByClass("container-chapter-reader").select("> img.reader-content")
            var pageUrls: [String] = []
           try pages.forEach { page in
               let url = try page.attr("src")
                pageUrls.append(url)
            }
            return pageUrls
            
        }catch {
            throw error
        }
    }
    
    func getMangas(with title: String) async throws -> [Manga] {
        
        guard var url = URL(string: baseUrl) else {
            throw AppErrors.internalError
        }
        
        url.append(path: "search")
        url.append(path: "story")
        url.append(path: title.lowercased().replacingOccurrences(of: " ", with: "_"))
        
        do {
            
            let (data, _) = try await URLSession.shared.data(from: url)
            guard let html = String(data: data, encoding: .utf8) else {
                throw AppErrors.internalError
            }
            
            let doc: Document = try SwiftSoup.parse(html)
            let searchResults = try doc.getElementsByClass("search-story-item")
            var mangas: [Manga] = []
            try searchResults.forEach({ item in
                let t = try item.select("> a")
                let title = try t.attr("title")
                let detailUrl = try t.attr("href")
                let coverUrl = try item.select("img.img-loading").attr("src")
                mangas.append(Manga(title: title, coverUrl: coverUrl, detailsUrl: detailUrl))
            })
            return mangas
            
        }catch {
            throw error
        }
    }
    
    private func getRequiredRating(from rating: String) -> Int? {
        let wordsToRemove = ["MangaNelo.com", "rate", ":", "/", "5", "-", "votes"]
        var stringArray = rating.components(separatedBy: " ")
        stringArray = stringArray.filter{ !wordsToRemove.contains($0) }
        if let ratingString = stringArray.first {
            return Int(Double(ratingString)?.rounded() ?? 0.0)
        }
        return nil
    }
}
