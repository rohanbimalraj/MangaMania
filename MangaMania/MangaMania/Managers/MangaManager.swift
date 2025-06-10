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
    
    struct Chapter: Identifiable, Comparable {
        let id: UUID = UUID()
        let chapUrl: String?
        let chapTitle: String?
        let chapDate: String?
        let chapNum: Int
        
        static func <(lhs: Chapter, rhs: Chapter) -> Bool {
            lhs.chapNum < rhs.chapNum
        }
        
        static func >(lhs: Chapter, rhs: Chapter) -> Bool {
            lhs.chapNum > rhs.chapNum
        }
    }
    
    let coverUrl: String?
    let title: String?
    let authors: String?
    let status: String?
    let updatedDate: String?
    let rating: Int?
    let description: String?
    let chapters: [Chapter]?
    
    static var dummyChapters: [Chapter] {
        Array(repeating: (), count: 20).map { Chapter(chapUrl: "", chapTitle: .placeholder(length: 80), chapDate: .placeholder(length: 10), chapNum: 1000) }
    }
    
}

final class MangaManager {
    
    static let shared = MangaManager()
    
    private let remoteConfig = RemoteConfigManager.shared
    
    private static let defaultRequestHeaders: [String: String] = [
        "sec-ch-ua": "\"Not.A/Brand\";v=\"8\", \"Chromium\";v=\"114\", \"Google Chrome\";v=\"114\"",
        "Referer": "https://www.nelomanga.net/",
        "sec-ch-ua-mobile": "?0",
        "User-Agent": "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/114.0.0.0 Safari/537.36",
        "sec-ch-ua-platform": "\"macOS\""
    ]
    
    let kfRequestModifier = AnyModifier { request in
        var r = request
        defaultRequestHeaders.forEach { key, value in
            r.setValue(value, forHTTPHeaderField: key)
        }
        return r
    }
    
    private init() {}
        
    func getTopMangas(in page: Int) async -> Result<[Manga], Error> {
        
        let homeScreen = remoteConfig.homeScreen
        let fetchTask = Task { () -> [Manga] in
            
            guard var url = URL(string: homeScreen.url) else {
                throw AppErrors.internalError
            }

            if page != 1 {
                url.append(queryItems:
                            [
                                URLQueryItem(name: homeScreen.paramKey, value: String(page))
                            ]
                )
            }

            let (data, _) = try await URLSession.shared.data(from: url)
            guard let html = String(data: data, encoding: .utf8) else {
                throw AppErrors.internalError
            }

            let doc: Document = try SwiftSoup.parse(html)
            
            let mangas = try doc.select(homeScreen.listQuery)
            var topMangas: [Manga] = []
            
            try mangas.forEach { manga in
                let detailUrl = try manga.select(homeScreen.detailQuery).attr(homeScreen.detailAttr)
                let title = try manga.select(homeScreen.titleQuery).attr(homeScreen.titleAttr)
                let coverUrl = try manga.select(homeScreen.imageQuery).attr(homeScreen.imageAttr)
                topMangas.append(Manga(title: title, coverUrl: coverUrl, detailsUrl: detailUrl))
            }
            
            return topMangas
            
        }
        
        let result = await fetchTask.result
        return result
    }
    
    func getMangaDetail(from url: String) async -> Result<MangaDetail, Error> {
        
        let detailScreen = remoteConfig.detailScreen
        let fetchTask = Task { () -> MangaDetail in
            
            guard let url = URL(string: url) else {
                throw AppErrors.internalError
            }
            
            let (data, _) = try await URLSession.shared.data(from: url)
            
            guard let html = String(data: data, encoding: .utf8) else {
                throw AppErrors.internalError
            }
            
            let doc: Document = try SwiftSoup.parse(html)
            
            let mangaCover = try doc.select(detailScreen.imageQuery).attr(detailScreen.imageAttr)
            let title = try doc.select(detailScreen.titleQuery).text()
            let elementArray = try doc.select(detailScreen.infoQuery)
            
            var authors = ""
            var status = ""
            var updatedDate = ""
            var rating = ""
            
            try elementArray.forEach { element in
                let label = try element.select(detailScreen.infoLabelQuery).text()
                switch label {
                case "Author(s):":
                    authors = try element.select(detailScreen.authorsQuery).text()
                case "Status:":
                    status = try element.select(detailScreen.statusQuery).text()
                case "Last updated:":
                    updatedDate = try element.select(detailScreen.updatedDateQuery).text()
                case "Rating:":
                    rating = try element.select(detailScreen.ratingQuery).text()
                default:
                    break
                }
            }

            
            var description = try doc.select(detailScreen.descriptionQuery).text()
            description = description.replacingOccurrences(of: "\(title) summary: ", with: "")
            
            let tempChapters = try doc.select(detailScreen.chaptersQuery)
            var chapters: [MangaDetail.Chapter] = []
            
            var totalChapters = tempChapters.count
            
            try tempChapters.forEach { chapter in
                let chapTitle = try chapter.select(detailScreen.chapTitleQuery).text()
                let chapUrl = try chapter.select(detailScreen.chapUrlQuery).attr(detailScreen.chapUrlAttr)
                let chapDate = try chapter.select(detailScreen.chapDateQuery).text()
                chapters.append(MangaDetail.Chapter(chapUrl: chapUrl, chapTitle: chapTitle, chapDate: chapDate, chapNum: totalChapters))
                totalChapters -= 1

            }
            
                        
            return MangaDetail(coverUrl: mangaCover, title: title, authors: authors, status: status, updatedDate: updatedDate, rating: getRequiredRating(from: rating), description: description, chapters: chapters)
        }
        
        let result = await fetchTask.result
        return result
        
    }
    
    func getMangaChapterPages(from url: String) async throws -> [String] {
        
        let chapterScreen = remoteConfig.chapterScreen
        guard let url = URL(string: url) else {
            throw AppErrors.internalError
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            
            guard let html = String(data: data, encoding: .utf8) else {
                throw AppErrors.internalError
            }
            
            let doc: Document = try SwiftSoup.parse(html)
            let pages = try doc.select(chapterScreen.pagesQuery)
            var pageUrls: [String] = []
           try pages.forEach { page in
               let url = try page.attr(chapterScreen.pageAttr)
                pageUrls.append(url)
            }
            return pageUrls
            
        }catch {
            throw error
        }
    }
    
    func getMangas(with title: String) async -> Result<[Manga], Error> {
        
        let searchScreen = remoteConfig.searchScreen
        let fetchTask = Task { () -> [Manga] in
            guard var url = URL(string: searchScreen.url) else {
                throw AppErrors.internalError
            }

            url.append(path: title.lowercased().replacingOccurrences(of: " ", with: "_"))

            var request = URLRequest(url: url)

            MangaManager.defaultRequestHeaders.forEach { key, value in
                request.setValue(value, forHTTPHeaderField: key)
            }

            let (data, _) = try await URLSession.shared.data(for: request)
            guard let html = String(data: data, encoding: .utf8) else {
                throw AppErrors.internalError
            }

            let doc: Document = try SwiftSoup.parse(html)
            let searchResults = try doc.select(searchScreen.resultsQuery)
            var mangas: [Manga] = []
            try searchResults.forEach { item in
                let title = try item.select(searchScreen.titleQuery).text()
                let detailUrl = try item.select(searchScreen.detailQuery).attr(searchScreen.detailAttr)
                let coverUrl = try item.select(searchScreen.imageQuery).attr(searchScreen.imageAttr)
                mangas.append(Manga(title: title, coverUrl: coverUrl, detailsUrl: detailUrl))
            }

            return mangas
        }

        let result = await fetchTask.result
        return result
    }
    
    private func getRequiredRating(from rating: String) -> Int? {
        let wordsToRemove = ["nelomanga.net", "rate", ":", "/", "-", "votes"]
        var stringArray = rating.components(separatedBy: " ")
        stringArray = stringArray.filter{ !wordsToRemove.contains($0) }
        if let ratingString = stringArray.first {
            return Int(Double(ratingString)?.rounded() ?? 0.0)
        }
        return nil
    }
}
