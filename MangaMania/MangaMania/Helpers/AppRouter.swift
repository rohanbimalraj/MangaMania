//
//  AppRouter.swift
//  MangaMania
//
//  Created by Rohan Bimal Raj on 20/07/23.
//

import Combine
import SwiftUI

enum Page: Hashable, Identifiable {
    case content, topMangas, myMangas, searchManga
    case mangaDetail(url: String, from: Tab)
    case mangaChapter(url: String, from: Tab)
    
    var id: Self {
        return self
    }
}

class AppRouter: ObservableObject {
    
    @Published var path = NavigationPath()
    
    func push(_ page: Page) {
        path.append(page)
    }
    
    func pop() {
        path.removeLast()
    }
    
    func popToRoot() {
        path.removeLast(path.count)
    }
    
    @ViewBuilder
    func build(page: Page) -> some View {
        switch page {
                                    
        case .content:
            ContentView()
            
        case .topMangas:
            TopMangasView()
            
        case .myMangas:
            MyMangasView()
            
        case .searchManga:
            MangaSearchView()
            
        case .mangaDetail(let url, let tab):
            MangaDetailView(detailUrl: url, tab: tab)

            
        case .mangaChapter(let url, let tab):
            MangaChapterView(chapterlUrl: url, tab: tab)

        }
    }
    
}


class TopMangasRouter: ObservableObject {
    
    var router: AppRouter
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        router = AppRouter()
        router.objectWillChange
            .sink { [self] _ in
                objectWillChange.send()
            }
            .store(in: &cancellables)
    }
}

class MyMangasRouter: ObservableObject {
    
    var router: AppRouter
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        router = AppRouter()
        router.objectWillChange
            .sink { [self] _ in
                objectWillChange.send()
            }
            .store(in: &cancellables)
    }
}

class SearchMangaRouter: ObservableObject {
    
    var router: AppRouter
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        router = AppRouter()
        router.objectWillChange
            .sink { [self] _ in
                objectWillChange.send()
            }
            .store(in: &cancellables)
    }
}

class SettingsRouter: ObservableObject {
    
    var router: AppRouter
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        router = AppRouter()
        router.objectWillChange
            .sink { [self] _ in
                objectWillChange.send()
            }
            .store(in: &cancellables)
    }
}
