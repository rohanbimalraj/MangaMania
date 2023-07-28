//
//  AppRouter.swift
//  MangaMania
//
//  Created by Rohan Bimal Raj on 20/07/23.
//

import Combine
import SwiftUI

enum Page: String, Identifiable {
    case login, settings, content, topMangas
    
    var id: String {
        self.rawValue
    }
}

enum FullScreenCover: String, Identifiable {
    case createAccount, forgotPassword
    
    var id: String {
        self.rawValue
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
