//
//  MyMangasView.swift
//  MangaMania
//
//  Created by Rohan Bimal Raj on 23/07/23.
//
import Kingfisher
import SwiftUI

struct MyMangasView: View {
    
    @EnvironmentObject private var notificationManager: NotificationManager
    @EnvironmentObject private var myMangasRouter: MyMangasRouter
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
        .navigationTitle("Your Library")
        .onAppear {
            isVisible = true
            isTabBarVisible.wrappedValue = true
            vm.getMyMangas()
        }
        .onDisappear {
            isVisible = false
            vm.showEmptyMessage = false
        }
        .preferredColorScheme(.dark)
        .animation(.easeInOut(duration: 1), value: vm.showEmptyMessage)
        .onChange(of: notificationManager.mangaUrl) {
            guard let mangaUrl = notificationManager.mangaUrl, isVisible else { return }
            myMangasRouter.router.push(.mangaDetail(url: mangaUrl, from: .myMangas))
        }
    }
}

struct MyMangasView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            MyMangasView()
        }
        .environmentObject(NotificationManager.shared)
    }
}

private extension MyMangasView {
    
    // MARK: - Background
    var backgroundView: some View {
        LinearGradient(
            gradient: Gradient(colors: [.themeTwo, .themeOne]),
            startPoint: .top,
            endPoint: .bottom
        )
        .ignoresSafeArea()
        .animation(.none, value: vm.showEmptyMessage)
    }

    // MARK: - Content
    @ViewBuilder
    var content: some View {
        if vm.showEmptyMessage {
            emptyStateMessage
        } else {
            mangaGridScrollView
        }
    }

    // MARK: - Empty State
    var emptyStateMessage: some View {
        Text("\"You have not added any manga to library yet\"")
            .foregroundColor(.themeFour)
            .font(.custom(.bold, size: 17))
            .padding(.bottom, 90)
            .padding(.horizontal)
            .transition(.scale)
    }

    // MARK: - Manga Grid
    var mangaGridScrollView: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 10) {
                mangaGridItems
            }
        }
        .scrollBounceBehavior(.basedOnSize)
        .padding(.bottom, 90)
        .padding(.top, 1)
        .clipped()
    }
    
    // MARK: - Manga Grid Item
    @ViewBuilder
    var mangaGridItems: some View {
        ForEach(vm.myMangas) { myManga in
            let manga = Manga(title: myManga.title, coverUrl: myManga.coverUrl, detailsUrl: myManga.detailUrl)
            MangaGridItemView(manga: manga) {
                myMangasRouter.router.push(.mangaDetail(url: manga.detailsUrl ?? "", from: .myMangas))
            } contextMenu: {
                Button {
                    vm.deleteFromLib(myManga)
                } label: {
                    Label("Remove from library", systemImage: "trash.fill")
                }
            }
        }
    }
}
