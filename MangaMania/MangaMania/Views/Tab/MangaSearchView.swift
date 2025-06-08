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
            LinearGradient(gradient: Gradient(colors: [.themeTwo, .themeOne]), startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()
            VStack {
                SearchBarView(searchText: $vm.searchText)
                switch vm.loadingState {
                case .idle:
                    ScrollView {
                        LazyVGrid(columns: columns, spacing: 10) {
                            ForEach(vm.mangas) { manga in
                                
                                Button {
                                    
                                    searchMangaRouter.router.push(.mangaDetail(url: manga.detailsUrl ?? "", from: .searchMangas))
                                    
                                }label: {
                                    KFImage(URL(string: manga.coverUrl ?? ""))
                                        .requestModifier(MangaManager.shared.kfRequestModifier)
                                        .memoryCacheExpiration(.expired)
                                        .resizable()
                                        .fade(duration: 0.5)
                                        .placeholder({
                                            Image("book-cover-placeholder")
                                                .resizable()
                                        })
                                        .overlay {
                                            LinearGradient(gradient: Gradient(colors: [.black, .clear]), startPoint: .bottom, endPoint: .top)
                                            VStack {
                                                Spacer()
                                                Text(manga.title ?? "")
                                                    .foregroundColor(.themeFour)
                                                    .font(.custom(.medium, size: 17))
                                                    .padding([.horizontal, .bottom])
                                            }
                                        }
                                        .frame(height: 250)
                                        .cornerRadius(10)
                                        .padding(.horizontal, 20)
                                        .padding(.top, 20)
                                    
                                }
                            }
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
                    Text(message)
                        .foregroundColor(.themeFour)
                        .font(.custom(.bold, size: 25))
                        .transition(.opacity)
                }
                Spacer()
            }
        }
        .animation(.easeInOut(duration: 0.5), value: vm.loadingState)
        .navigationTitle("Search")
        .ignoresSafeArea(.keyboard)
        .preferredColorScheme(.dark)
        .onAppear {
            isVisible = true
            isTabBarVisible.wrappedValue = true
        }
        .onChange(of: notificationManager.mangaUrl) { mangaUrl in
            guard let mangaUrl = mangaUrl, isVisible else {return}
            searchMangaRouter.router.push(.mangaDetail(url: mangaUrl, from: .searchMangas))
        }
        .onDisappear {
            isVisible = false
        }
    }
}

struct MangaSearchView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            MangaSearchView()
        }
    }
}
