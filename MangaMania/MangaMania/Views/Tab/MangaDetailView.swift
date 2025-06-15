//
//  MangaDetailView.swift
//  MangaMania
//
//  Created by Rohan Bimal Raj on 07/08/23.
//

import SwiftUI
import Kingfisher
import ExpandableText

struct MangaDetailView: View {
    
    
    @EnvironmentObject private var notificationManager: NotificationManager
    @EnvironmentObject private var topMangasRouter: TopMangasRouter
    @EnvironmentObject private var searchMangaRouter: SearchMangaRouter
    @EnvironmentObject private var myMangaRouter: MyMangasRouter
    
    @StateObject private var vm = ViewModel()
    
    @Environment(\.isTabBarVisible) private var isTabBarVisible
    @Namespace private var chapterSectionId
    
    @State private var showSearchBar = false
    @State private var searchText = ""
    @State private var isVisible = false
    @FocusState private var isSearchFieldActive
    
    let detailUrl: String
    let tab: Tab
    
    var body: some View {
        ZStack {
            background
            scrollContent
        }
        .onDisappear { isVisible = false }
        .onAppear(perform: onAppear)
        .navigationBarBackButtonHidden()
        .toolbar { navigationBackButton }
        .animation(.easeInOut(duration: 0.5), value: vm.showDetails)
        .alert("Message", isPresented: $vm.showAlert) {
            Button("Ok") {
                NotificationCenter.default.post(name: .libraryUpdated, object: nil)
            }
        } message: {
            Text(vm.message)
        }
        .preferredColorScheme(.dark)
        .ignoresSafeArea(.keyboard)
        .onChange(of: notificationManager.mangaUrl) {
            handleNotification()
        }
    }
}

struct MangaDetailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            MangaDetailView(detailUrl: "", tab: .topMangas)
                .environmentObject(NotificationManager.shared)
        }
    }
}

private extension MangaDetailView {

    // MARK: - Background View
    var background: some View {
        LinearGradient(gradient: Gradient(colors: [.themeTwo, .themeOne]), startPoint: .top, endPoint: .bottom)
            .ignoresSafeArea()
    }

    // MARK: - Scroll View Content
    var scrollContent: some View {
        ScrollViewReader { proxy in
            ScrollView {
                VStack {
                    mangaHeader
                    divider
                    mangaDescription
                    divider
                    chapterSection(proxy: proxy)
                }
                .padding(.horizontal)
            }
            .clipped()
            .navigationBarTitleDisplayMode(.inline)
            .transition(.opacity)
        }
    }

    // MARK: - Info View
    var mangaHeader: some View {
            HStack(alignment: .top) {
                KFImage(URL(string: vm.mangaDetail?.coverUrl ?? ""))
                    .resizable()
                    .fade(duration: 0.5)
                    .placeholder {
                        Image("book-cover-placeholder")
                            .resizable()
                            .redacted(if: vm.mangaDetail == nil)
                    }
                    .frame(width: 150, height: 250)
                    .cornerRadius(10)

                VStack(alignment: .leading, spacing: 20) {
                    Text(vm.mangaDetail?.title ?? .placeholder(length: 10))
                        .redacted(if: vm.mangaDetail == nil)
                        .foregroundColor(.themeFour)
                        .font(.custom(.bold, size: 24))

                    mangaDetailsText

                    if vm.showDetails {
                        RatingView(rating: .constant(vm.mangaDetail?.rating ?? 0))

                        Button {
                            vm.isAddedToLib ? vm.deleteFromLib() : vm.saveToLib()
                        } label: {
                            HStack {
                                Text(vm.isAddedToLib ? "Remove" : "Save")
                                Image(systemName: vm.isAddedToLib ? "bookmark.slash.fill" : "bookmark.fill")
                            }
                            .foregroundStyle(.themeFour)
                            .font(.custom(.semiBold, size: 15))
                            .frame(maxWidth: .infinity)
                            .padding(10)
                            .background(Color.themeThree)
                            .clipShape(Capsule())
                        }
                    }
                }
            }
        }

    // MARK: - Detail Text
    var mangaDetailsText: some View {
        VStack(alignment: .leading, spacing: 5) {
            mangaDetailRow(title: "Author(s): ", value: vm.mangaDetail?.authors)
            mangaDetailRow(title: "Updated: ", value: vm.mangaDetail?.updatedDate)
            mangaDetailRow(title: "Status: ", value: vm.mangaDetail?.status)
        }
    }

    func mangaDetailRow(title: String, value: String?) -> some View {
        HStack(alignment: .top, spacing: 5) {
            Text(title)
                .foregroundColor(.themeFour)
                .font(.custom(.semiBold, size: 16))
                .redacted(if: vm.mangaDetail == nil)

            Text(value ?? .placeholder(length: 10))
                .foregroundColor(.themeFour)
                .font(.custom(.medium, size: 15))
                .redacted(if: vm.mangaDetail == nil)
        }
    }

    var divider: some View {
        Rectangle()
            .frame(height: 2)
            .foregroundColor(.themeTwo)
            .padding(.vertical)
    }

    // MARK: - Description View
    var mangaDescription: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Description")
                .foregroundColor(.themeFour)
                .font(.custom(.bold, size: 20))

            ExpandableText(text: vm.mangaDetail?.description ?? .placeholder(length: 70))
                .font(.custom(.regular, size: 14))
                .foregroundColor(.themeFour)
                .lineLimit(5)
                .expandButton(TextSet(text: "more", font: .custom(.bold, size: 16), color: .themeThree))
                .collapseButton(TextSet(text: "less", font: .custom(.bold, size: 16), color: .themeThree))
                .redacted(if: vm.mangaDetail == nil)
        }
    }

    func chapterSection(proxy: ScrollViewProxy) -> some View {
        VStack(alignment: .leading, spacing: 15) {
            chapterHeader(proxy: proxy)
            chapterListView
        }
        .id(chapterSectionId)
    }

    func chapterHeader(proxy: ScrollViewProxy) -> some View {
        HStack {
            Text("Chapters")
                .foregroundColor(.themeFour)
                .font(.custom(.bold, size: 20))
                .padding(5)

            Spacer()

            if vm.showDetails {
                chapterSearchBar(proxy: proxy)
                chapterSortMenu
            }
        }
    }

    func chapterSearchBar(proxy: ScrollViewProxy) -> some View {
            HStack {
                Button {
                    withAnimation {
                        proxy.scrollTo(chapterSectionId)
                        showSearchBar = true
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        isSearchFieldActive = true
                    }
                } label: {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.themeFour)
                        .padding(3)
                }
                .allowsHitTesting(!showSearchBar)

                if showSearchBar {
                    TextField("Search", text: $vm.searchText, prompt: Text("Search chapter")
                        .foregroundColor(.themeThree)
                        .font(.custom(.medium, size: 13)))
                        .tint(.themeFour)
                        .foregroundColor(.themeFour)
                        .font(.custom(.regular, size: 15))
                        .focused($isSearchFieldActive)

                    Button {
                        withAnimation { showSearchBar = false }
                        vm.discardSearch()
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.themeFour)
                    }
                    .offset(x: -3)
                }
            }
            .padding(3)
            .background(showSearchBar ? .themeTwo : .clear)
            .clipShape(Capsule())
        }

    var chapterSortMenu: some View {
        Menu {
            Button(action: { vm.sortChapters(from: .newestToOldest) }) {
                Label("Newest - Oldest", systemImage: vm.sortType == .newestToOldest ? "checkmark" : "")
            }
            Button(action: { vm.sortChapters(from: .oldestToNewest) }) {
                Label("Oldest - Newest", systemImage: vm.sortType == .oldestToNewest ? "checkmark" : "")
            }
        } label: {
            Image(systemName: "arrow.up.arrow.down")
                .foregroundColor(.themeFour)
                .padding(5)
        }
    }

    var chapterListView: some View {
        ScrollViewReader { proxy in
            List {
                ForEach(vm.requiredChapters) { chapter in
                    Button {
                        vm.updateSelectedChapter(title: chapter.chapTitle ?? "")
                        pushChapter(for: chapter.chapUrl)
                    } label: {
                        HStack {
                            Text(chapter.chapTitle ?? "")
                                .foregroundColor(.themeFour)
                                .font(.custom(.semiBold, size: 13))
                                .redacted(if: vm.mangaDetail == nil)

                            if chapter.chapTitle == vm.selectedChapTitle {
                                Image("ContinueNew")
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 70, height: 20)
                            }

                            Spacer()

                            if vm.showDetails {
                                Image(systemName: "chevron.right")
                                    .foregroundColor(.themeFour)
                            }
                        }
                    }
                    .id(chapter.chapTitle)
                }
                .listRowSeparatorTint(.themeTwo)
                .listRowBackground(Color.clear)
            }
            .frame(height: 400)
            .listStyle(.plain)
            .onAppear {
                withAnimation {
                    proxy.scrollTo(vm.selectedChapTitle, anchor: .top)
                }
            }
            .allowsHitTesting(vm.showDetails)
        }
    }

    func pushChapter(for url: String?) {
        guard let url = url else { return }
        switch tab {
        case .topMangas:
            topMangasRouter.router.push(.mangaChapter(url: url, from: tab))
        case .searchMangas:
            searchMangaRouter.router.push(.mangaChapter(url: url, from: tab))
        case .myMangas:
            myMangaRouter.router.push(.mangaChapter(url: url, from: tab))
        }
    }

    var navigationBackButton: some ToolbarContent {
        ToolbarItem(placement: .navigationBarLeading) {
            Button {
                switch tab {
                case .topMangas: topMangasRouter.router.pop()
                case .searchMangas: searchMangaRouter.router.pop()
                case .myMangas: myMangaRouter.router.pop()
                }
            } label: {
                Image(systemName: "arrowshape.left.fill")
                    .foregroundColor(.themeFour)
            }
        }
    }

    func onAppear() {
        isVisible = true
        notificationManager.reset()
        isTabBarVisible.wrappedValue = false
        vm.getMangaDetail(from: detailUrl)
    }

    func handleNotification() {
        guard let mangaUrl = notificationManager.mangaUrl, isVisible, detailUrl != mangaUrl else { return }
        notificationManager.reset()
        switch tab {
        case .topMangas:
            topMangasRouter.router.push(.mangaDetail(url: mangaUrl, from: .topMangas))
        case .searchMangas:
            searchMangaRouter.router.push(.mangaDetail(url: mangaUrl, from: .searchMangas))
        case .myMangas:
            myMangaRouter.router.push(.mangaDetail(url: mangaUrl, from: .myMangas))
        }
    }
}
