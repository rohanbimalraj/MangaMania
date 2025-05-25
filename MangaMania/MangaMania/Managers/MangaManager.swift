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

    // MARK: - Remote config values for Top Manga Screen
    private let tmUrl = RemoteConfigManager.value(forKey: RCKey.TM_URL)
    private let tmParamKey = RemoteConfigManager.value(forKey: RCKey.TM_PARAM_KEY)
    private let tmListQuery = RemoteConfigManager.value(forKey: RCKey.TM_LIST_QUERY)
    
    private let tmDetailQuery = RemoteConfigManager.value(forKey: RCKey.TM_DETAIL_QUERY)
    private let tmTitleQuery = RemoteConfigManager.value(forKey: RCKey.TM_TITLE_QUERY)
    private let tmImageQuery = RemoteConfigManager.value(forKey: RCKey.TM_IMAGE_QUERY)
    
    private let tmDetailAttr = RemoteConfigManager.value(forKey: RCKey.TM_DETAIL_ATTR)
    private let tmTitleAttr = RemoteConfigManager.value(forKey: RCKey.TM_TITLE_ATTR)
    private let tmImageAttr = RemoteConfigManager.value(forKey: RCKey.TM_IMAGE_ATTR)

    // MARK: - Remote config values for Search Screen
    private let searchMangaUrl = RemoteConfigManager.value(forKey: RCKey.SEARCH_MANGA_URL)
    
    static let shared = MangaManager()
    
    let chapterRequestModifier = AnyModifier { request in
        var r = request
        r.setValue("\"Not.A/Brand\";v=\"8\", \"Chromium\";v=\"114\", \"Google Chrome\";v=\"114\"", forHTTPHeaderField: "sec-ch-ua")
        r.setValue("https://www.nelomanga.net/", forHTTPHeaderField: "Referer")
        r.setValue("?0", forHTTPHeaderField: "sec-ch-ua-mobile")
        r.setValue("Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/114.0.0.0 Safari/537.36", forHTTPHeaderField: "User-Agent")
        r.setValue("sec-ch-ua-platform", forHTTPHeaderField: "\"macOS\"")
        return r
    }
    
    private init() {}
        
    func getTopMangas(in page: Int) async -> Result<[Manga], Error> {
        
        let fetchTask = Task { () -> [Manga] in
            
            guard var url = URL(string: tmUrl) else {
                throw AppErrors.internalError
            }

            if page != 1 {
                url.append(queryItems:
                            [
                                URLQueryItem(name: tmParamKey, value: String(page))
                            ]
                )
            }

            let (data, _) = try await URLSession.shared.data(from: url)
            guard let html = String(data: data, encoding: .utf8) else {
                throw AppErrors.internalError
            }

            let doc: Document = try SwiftSoup.parse(html)
            
            let mangas = try doc.select(tmListQuery)
            var topMangas: [Manga] = []
            
            try mangas.forEach { manga in
                let detailUrl = try manga.select(tmDetailQuery).attr(tmDetailAttr)
                let title = try manga.select(tmTitleQuery).attr(tmTitleAttr)
                let coverUrl = try manga.select(tmImageQuery).attr(tmImageAttr)
                topMangas.append(Manga(title: title, coverUrl: coverUrl, detailsUrl: detailUrl))
            }
            
            return topMangas
            
        }
        
        let result = await fetchTask.result
        return result
    }
    
    func getMangaDetail(from url: String) async -> Result<MangaDetail, Error> {
        
        let fetchTask = Task { () -> MangaDetail in
            
            guard let url = URL(string: url) else {
                throw AppErrors.internalError
            }
            
            let (data, _) = try await URLSession.shared.data(from: url)
            
            guard let html = String(data: data, encoding: .utf8) else {
                throw AppErrors.internalError
            }
            
            let doc: Document = try SwiftSoup.parse(html) // div.info-wrap > div
            
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
            
            var totalChapters = tempChapters.count
            
            try tempChapters.forEach { chapter in
                let chapTitle = try chapter.select("> a").text()
                let chapUrl = try chapter.select("> a").attr("href")
                let chapDate = try chapter.select("span.chapter-time.text-nowrap").text()
                chapters.append(MangaDetail.Chapter(chapUrl: chapUrl, chapTitle: chapTitle, chapDate: chapDate, chapNum: totalChapters))
                totalChapters -= 1

            }
            
                        
            return MangaDetail(coverUrl: mangaCover, title: title, authors: authors, status: status, updatedDate: updatedDate, rating: getRequiredRating(from: rating), description: description, chapters: chapters)
        }
        
        let result = await fetchTask.result
        return result
        
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
    
    func getMangas(with title: String) async -> Result<[Manga], Error> {
        
        let fetchTask = Task { () -> [Manga] in
            
            guard var url = URL(string: searchMangaUrl) else {
                throw AppErrors.internalError
            }
            
            url.append(path: RemoteConfigManager.value(forKey: RCKey.SEARCH_MANGA_PC_ONE))
            url.append(path: RemoteConfigManager.value(forKey: RCKey.SEARCH_MANGA_PC_TWO))
            url.append(path: title.lowercased().replacingOccurrences(of: " ", with: "_"))
            
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
        }
        let result = await fetchTask.result
        return result
        
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
