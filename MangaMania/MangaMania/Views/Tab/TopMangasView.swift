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
    @State private var topMangas: [Manga] = []
    @State private var isVisible = false
    @StateObject private var vm = ViewModel()
    
    var columns: [GridItem] = [
        GridItem(.adaptive(minimum: 150))
    ]
        
    var body: some View {
        
        ZStack {
            LinearGradient(gradient: Gradient(colors: [.themeTwo, .themeOne]), startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()
            
            ScrollView {
                LazyVGrid(columns: columns, spacing: 10) {
                    ForEach(vm.mangas) { manga in
                        
                        Button {
                            
                            topMangaRouter.router.push(.mangaDetail(url: manga.detailsUrl ?? "", from: .topMangas))
                            
                        }label: {
                            KFImage(URL(string: manga.coverUrl ?? ""))
                                .requestModifier(MangaManager.shared.kfRequestModifier)
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
                    
                    Color.clear
                        .onAppear{
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
        .navigationTitle("Trending")
        .preferredColorScheme(.dark)
        .onAppear {
            isVisible = true
            isTabBarVisible.wrappedValue = true
            guard let mangaUrl = notificationManager.mangaUrl else {return}
            topMangaRouter.router.push(.mangaDetail(url: mangaUrl, from: .topMangas))
        }
        .onChange(of: notificationManager.mangaUrl) { mangaUrl in
            guard let mangaUrl = mangaUrl, isVisible else {return}
            topMangaRouter.router.push(.mangaDetail(url: mangaUrl, from: .topMangas))
        }
        .onDisappear {
            isVisible = false
        }
    }
}

struct TopMangasView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            TopMangasView()
        }
    }
}
