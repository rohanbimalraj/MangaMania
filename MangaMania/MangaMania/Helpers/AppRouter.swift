//
//  AppRouter.swift
//  MangaMania
//
//  Created by Rohan Bimal Raj on 20/07/23.
//

import Combine
import SwiftUI

enum Page: Hashable, Identifiable {
    case login, settings, content, topMangas, myMangas, searchManga
    case mangaDetail(url: String, from: Tab)
    
    var id: Self {
        return self
    }
}

enum FullScreenCover: Identifiable {
    case createAccount, forgotPassword
    
    var id: Self {
        return self
    }
    
}

class AppRouter: ObservableObject {
    
    @Published var path = NavigationPath()
    @Published var fullScrrenCover: FullScreenCover?
    
    func push(_ page: Page) {
        path.append(page)
    }
    
    func present(fullScreenCover: FullScreenCover) {
        self.fullScrrenCover = fullScreenCover
    }
    
    func pop() {
        path.removeLast()
    }
    
    func popToRoot() {
        path.removeLast(path.count)
    }
    
    func dismissFullScreenCover() {
        self.fullScrrenCover = nil
    }
    
    @ViewBuilder
    func build(page: Page) -> some View {
        switch page {
                        
        case .login:
            LoginView()
            
        case .settings:
            SettingsView()
            
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
        }
    }
    
    @ViewBuilder
    func build(fullScreenCover: FullScreenCover) -> some View {
        switch fullScreenCover {
            
        case .createAccount:
            NavigationStack {
                CreateAccountView()
            }
            
        case .forgotPassword:
            NavigationStack {
                ForgotPasswordView()
            }
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
