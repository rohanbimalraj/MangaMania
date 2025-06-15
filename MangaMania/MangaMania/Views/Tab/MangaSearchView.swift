//
//  MangaSearchView.swift
//  MangaMania
//
//  Created by Rohan Bimal Raj on 23/07/23.
//
import Kingfisher
import SwiftUI

struct MangaSearchView: View {
    
    @StateObject private var vm = ViewModel()
    @State private var isVisible = false
    @EnvironmentObject private var notificationManager: NotificationManager
    @EnvironmentObject private var searchMangaRouter: SearchMangaRouter
    @Environment(\.isTabBarVisible) var isTabBarVisible
    var columns: [GridItem] = [
        GridItem(.adaptive(minimum: 150))
    ]
    
    var body: some View {
        ZStack {
            background
            VStack {
                SearchBarView(searchText: $vm.searchText)
                switch vm.loadingState {
                case .idle:
                    ScrollView {
                        LazyVGrid(columns: columns, spacing: 10) {
                            mangaGridItems
                        }
                    }
                    .padding(.bottom, 90)
                    .padding(.top, 1)
                    .clipped()
                    .transition(.opacity)
                    
                case .loading:
                    CustomLoaderView(bottomPadding: 0)
                        .transition(.opacity)
                case .error(let message):
                    errorText(message)
                }
                Spacer()
            }
        }
        .animation(.easeInOut(duration: 0.5), value: vm.loadingState)
        .navigationTitle("Search")
        .ignoresSafeArea(.keyboard)
        .preferredColorScheme(.dark)
        .onAppear(perform: onAppear)
        .onChange(of: notificationManager.mangaUrl) {
            guard let mangaUrl = notificationManager.mangaUrl, isVisible else {return}
            searchMangaRouter.router.push(.mangaDetail(url: mangaUrl, from: .searchMangas))
        }
        .onDisappear(perform: onDisappear)
    }
}

struct MangaSearchView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            MangaSearchView()
        }
        .environmentObject(NotificationManager.shared)
    }
}

private extension MangaSearchView {
    
    var background: some View {
        LinearGradient(gradient: Gradient(colors: [.themeTwo, .themeOne]), startPoint: .top, endPoint: .bottom)
            .ignoresSafeArea()
    }

    @ViewBuilder
    var mangaGridItems: some View {
        ForEach(vm.mangas) { manga in
            MangaGridItemView(manga: manga) {
                searchMangaRouter.router.push(.mangaDetail(url: manga.detailsUrl ?? "", from: .searchMangas))
            }
        }
    }

    func errorText(_ message: String) -> some View {
        Text(message)
            .foregroundColor(.themeFour)
            .font(.custom(.bold, size: 25))
            .transition(.opacity)
    }

    func onAppear() {
        isVisible = true
        isTabBarVisible.wrappedValue = true
    }

    func onDisappear() {
        isVisible = false
    }
}
