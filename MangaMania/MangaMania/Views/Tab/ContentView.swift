//
//  ContentView.swift
//  MangaMania
//
//  Created by Rohan Bimal Raj on 23/07/23.
//

import SwiftUI

struct ContentView: View {
    
    @State private var selectedTab: Tab = .topMangas
    @StateObject private var topMangaRouter = TopMangasRouter()
    
    init() {
        UITabBar.appearance().isHidden = true
    }
    
    var body: some View {
        ZStack {
            
            LinearGradient(gradient: Gradient(colors: [.themeTwo, .themeOne]), startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()
            
            VStack {
                TabView(selection: $selectedTab) {
                    
                    NavigationStack(path: $topMangaRouter.router.path) {
                        topMangaRouter.router.build(page: .topMangas)
                            .navigationDestination(for: Page.self) { page in
                                topMangaRouter.router.build(page: page)
                            }
                            .fullScreenCover(item: $topMangaRouter.router.fullScrrenCover) { fullScreenCover in
                                topMangaRouter.router.build(fullScreenCover: fullScreenCover)
                            }
                    }
                    .tag(Tab.topMangas)
                    
                    MyMangasView()
                        .tag(Tab.myMangas)
                    
                    MangaSearchView()
                        .tag(Tab.searchMangas)
                    
                    SettingsView()
                        .tag(Tab.settings)
                }
            }
            
            VStack {
                Spacer()
                TabBarView(selectedTab: $selectedTab)
            }
        }
        .onAppear(perform: setNavBarAppearance)
        .environmentObject(topMangaRouter)
    }
    
    private func setNavBarAppearance() {
        let appearance = UINavigationBarAppearance()
        let textColor = UIColor(.themeFour)
        appearance.backgroundEffect = .none
        
        appearance.backgroundColor = .clear
        appearance.shadowColor = .clear
        
        appearance.largeTitleTextAttributes = [
                        .font: UIFont(name: "Montserrat-Black", size: 32)!,
                        .foregroundColor: textColor,
                        .textEffect: NSAttributedString.TextEffectStyle.letterpressStyle
                    ]
                    appearance.titleTextAttributes = [
                        .font: UIFont(name: "Montserrat-Black", size: 24)!,
                        .foregroundColor: textColor,
                        .textEffect: NSAttributedString.TextEffectStyle.letterpressStyle
                    ]
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
