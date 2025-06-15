//
//  TopMangasView.swift
//  MangaMania
//
//  Created by Rohan Bimal Raj on 23/07/23.
//
import Kingfisher
import SwiftUI

struct TopMangasView: View {
    
    @EnvironmentObject private var topMangaRouter: TopMangasRouter
    @EnvironmentObject private var notificationManager: NotificationManager
    @Environment(\.isTabBarVisible) var isTabBarVisible
    @State private var isVisible = false
    @StateObject private var vm = ViewModel()
    
    var columns: [GridItem] = [
        GridItem(.adaptive(minimum: 150))
    ]
    
    var body: some View {
        ZStack {
            backgroundView
            content
        }
        .navigationTitle("Trending")
        .preferredColorScheme(.dark)
        .onAppear(perform: onAppear)
        .onDisappear { isVisible = false }
        .onChange(of: notificationManager.mangaUrl) {
            handleNotificationNavigation()
        }
    }
}

struct TopMangasView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            TopMangasView()
        }
        .environmentObject(NotificationManager.shared)
    }
}

private extension TopMangasView {

    // MARK: - Background
    var backgroundView: some View {
        LinearGradient(
            gradient: Gradient(colors: [.themeTwo, .themeOne]),
            startPoint: .top,
            endPoint: .bottom
        )
        .ignoresSafeArea()
    }

    // MARK: - Content
    var content: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 10) {
                mangaGridItems
                
                Color.clear
                    .onAppear {
                        vm.getTopMangas()
                    }
            }
            
            if vm.state == .loading {
                ProgressView()
            }
        }
        .padding(.bottom, UIApplication.shared.hasBottomSafeArea ? 20 : 40)
        .clipped()
    }

    @ViewBuilder
    var mangaGridItems: some View {
        ForEach(vm.mangas) { manga in
            MangaGridItemView(manga: manga) {
                topMangaRouter.router.push(.mangaDetail(url: manga.detailsUrl ?? "", from: .topMangas))
            }
        }
    }

    // MARK: - Lifecycle
    func onAppear() {
        isVisible = true
        isTabBarVisible.wrappedValue = true
        
        if let mangaUrl = notificationManager.mangaUrl {
            topMangaRouter.router.push(.mangaDetail(url: mangaUrl, from: .topMangas))
        }
    }

    func handleNotificationNavigation() {
        guard let mangaUrl = notificationManager.mangaUrl, isVisible else { return }
        topMangaRouter.router.push(.mangaDetail(url: mangaUrl, from: .topMangas))
    }
}
