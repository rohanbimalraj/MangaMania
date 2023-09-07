//
//  ContentView.swift
//  MangaMania
//
//  Created by Rohan Bimal Raj on 23/07/23.
//

import SwiftUI

struct ContentView: View {
    
    @State private var selectedTab: Tab = .topMangas
    @State private var showTabBar = true
    
    @StateObject private var topMangaRouter = TopMangasRouter()
    @StateObject private var myMangasRouter = MyMangasRouter()
    @StateObject private var searchMangaRouter = SearchMangaRouter()
    @StateObject private var settingsRouter = SettingsRouter()
    
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

                    }
                    .tag(Tab.topMangas)
                    
                    NavigationStack(path: $myMangasRouter.router.path) {
                        myMangasRouter.router.build(page: .myMangas)
                            .navigationDestination(for: Page.self) { page in
                                myMangasRouter.router.build(page: page)
                            }

                    }
                    .tag(Tab.myMangas)
                    
                    NavigationStack(path: $searchMangaRouter.router.path) {
                        searchMangaRouter.router.build(page: .searchManga)
                            .navigationDestination(for: Page.self) { page in
                                searchMangaRouter.router.build(page: page)
                            }
                    }
                    .tag(Tab.searchMangas)
                    
                }
            }
            
            VStack {
                Spacer()
                if showTabBar {
                    TabBarView(selectedTab: $selectedTab)
                }
            }
            .animation(.default, value: showTabBar)
        }
        .onAppear(perform: setNavBarAppearance)
        .environmentObject(topMangaRouter)
        .environmentObject(myMangasRouter)
        .environmentObject(searchMangaRouter)
        .environmentObject(settingsRouter)
        .environment(\.isTabBarVisible, $showTabBar)
        .ignoresSafeArea(.keyboard)
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
