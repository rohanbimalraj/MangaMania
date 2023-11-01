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
            LinearGradient(gradient: Gradient(colors: [.themeTwo, .themeOne]), startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()
            ScrollViewReader { proxy in
                
                ScrollView {
                        VStack {
                            HStack(alignment: .top) {
                                KFImage(URL(string: vm.mangaDetail?.coverUrl ?? ""))
                                    .resizable()
                                    .fade(duration: 0.5)
                                    .placeholder({
                                        Image("book-cover-placeholder")
                                            .resizable()
                                            .redacted(if: vm.mangaDetail == nil)
                                    })
                                    .frame(width: 150, height: 250)
                                    .cornerRadius(10)
                                
                                VStack(alignment: .leading, spacing: 20) {
                                    Text(vm.mangaDetail?.title ?? .placeholder(length: 10))
                                        .redacted(if: vm.mangaDetail == nil)
                                        .foregroundColor(.themeFour)
                                        .font(.custom(.bold, size: 24))
                                    VStack(alignment: .leading, spacing: 5) {
                                        
                                        HStack(alignment: .top ,spacing: 5) {
                                            Text("Author(s): ")
                                                .foregroundColor(.themeFour)
                                                .font(.custom(.semiBold, size: 16))
                                                .redacted(if: vm.mangaDetail == nil)
                                            Text(vm.mangaDetail?.authors ?? .placeholder(length: 10))
                                                .foregroundColor(.themeFour)
                                                .font(.custom(.medium, size: 15))
                                                .redacted(if: vm.mangaDetail == nil)
                                        }

                                        HStack(alignment: .top, spacing: 5) {
                                            Text("Updated:  ")
                                                .foregroundColor(.themeFour)
                                                .font(.custom(.semiBold, size: 16))
                                                .redacted(if: vm.mangaDetail == nil)
                                            Text(vm.mangaDetail?.updatedDate ?? .placeholder(length: 10))
                                                .foregroundColor(.themeFour)
                                                .font(.custom(.medium, size: 15))
                                                .redacted(if: vm.mangaDetail == nil)
                                        }
                                        
                                        HStack(alignment: .top, spacing: 5) {
                                            Text("Status:      ")
                                                .foregroundColor(.themeFour)
                                                .font(.custom(.semiBold, size: 16))
                                                .redacted(if: vm.mangaDetail == nil)
                                            Text(vm.mangaDetail?.status ?? .placeholder(length: 10))
                                                .foregroundColor(.themeFour)
                                                .font(.custom(.medium, size: 15))
                                                .redacted(if: vm.mangaDetail == nil)
                                        }
                                    }
                                    
                                    if vm.showDetails {
                                        RatingView(rating: .constant(vm.mangaDetail?.rating ?? 0))
                                    }

                                    
                                    if vm.showDetails {
                                        Button {
                                            if vm.isAddedToLib {
                                                vm.deleteFromLib()
                                            }else {
                                                vm.saveToLib()
                                            }
                                        }label: {
                                            HStack {
                                                Text(vm.isAddedToLib ? "Remove" : "Save")
                                                    .foregroundStyle(.themeFour)
                                                    .font(.custom(.semiBold, size: 15))
                                                Image(systemName: vm.isAddedToLib ? "bookmark.slash.fill" : "bookmark.fill")
                                                    .foregroundStyle(.themeFour)
                                            }
                                            .frame(maxWidth: .infinity)
                                            .padding(10)
                                            .background(Color.themeThree)
                                            .clipShape(Capsule())
                                        }
                                    }
                                }
                            }
                            
                            Rectangle()
                                .frame(height: 2)
                                .foregroundColor(.themeTwo)
                                .padding(.vertical)
                            
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
                            
                            Rectangle()
                                .frame(height: 2)
                                .foregroundColor(.themeTwo)
                                .padding(.vertical)
                            
                            VStack(alignment: .leading, spacing: 15) {
                                HStack {
                                    Text("Chapters")
                                        .foregroundColor(.themeFour)
                                    .font(.custom(.bold, size: 20))
                                    .padding(5)
                                    
                                    Spacer()
                                    
                                    if vm.showDetails {
                                        HStack {
                                            
                                            Button {
                                                
                                                withAnimation {
                                                    proxy.scrollTo(chapterSectionId)
                                                    showSearchBar = true
                                                }
                                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                                    isSearchFieldActive = true
                                                }
                                                
                                            }label: {
                                                Image(systemName: "magnifyingglass")
                                                    .foregroundColor(.themeFour)
                                                    .padding(3)
                                            }
                                            .allowsHitTesting(!showSearchBar)
                                            if showSearchBar {
                                                TextField("Search", text: $vm.searchText, prompt:
                                                            Text("Search chapter")
                                                    .foregroundColor(.themeThree)
                                                    .font(.custom(.medium, size: 13))
                                                )
                                                .tint(.themeFour)
                                                .foregroundColor(.themeFour)
                                                .font(.custom(.regular, size: 15))
                                                .focused($isSearchFieldActive)

                                                
                                                
                                                Button {
                                                    withAnimation {
                                                        showSearchBar = false
                                                    }
                                                    vm.discardSearch()
                                                }label: {
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
                                    
                                    
                                    if vm.showDetails {
                                        Menu {
                                            Button {
                                                vm.sortChapters(from: .newestToOldest)
                                            } label: {
                                                if vm.sortType == .newestToOldest {
                                                    Label("Newest - Oldest", systemImage: "checkmark")
                                                }else {
                                                    Text("Newest - Oldest")
                                                }
                                                
                                            }
                                            
                                            Button {
                                                vm.sortChapters(from: .oldestToNewest)
                                            } label: {
                                                if vm.sortType == .oldestToNewest {
                                                    Label("Oldest - Newest", systemImage: "checkmark")
                                                }else {
                                                    Text("Oldest - Newest")
                                                }
                                            }
                                            
                                        }label: {
                                            Image(systemName: "arrow.up.arrow.down")
                                                .foregroundColor(.themeFour)
                                                .padding(5)
                                        }
                                    }
                                }
                                ScrollViewReader { secondProxy in
                                    List {
                                        ForEach(vm.requiredChapters) { chapter in
                                            Button {
                                                vm.updateSelectedChapter(title: chapter.chapTitle ?? "")
                                                switch tab {
                                                case .topMangas:
                                                    topMangasRouter.router.push(.mangaChapter(url: chapter.chapUrl ?? "", from: tab))
                                                case .searchMangas:
                                                    searchMangaRouter.router.push(.mangaChapter(url: chapter.chapUrl ?? "", from: tab))
                                                case .myMangas:
                                                    myMangaRouter.router.push(.mangaChapter(url: chapter.chapUrl ?? "", from: tab))

                                                }

                                            }label: {
                                                HStack {
                                                    Text(chapter.chapTitle ?? "")
                                                        .foregroundColor(.themeFour)
                                                        .font(.custom(.semiBold, size: 13))
                                                        .redacted(if: vm.mangaDetail == nil)

                                                    if (chapter.chapTitle == vm.selectedChapTitle) {
                                                        Image("ContinueNew", bundle: nil)
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
                                            secondProxy.scrollTo(vm.selectedChapTitle, anchor: .top)
                                        }
                                    }
                                    .allowsHitTesting(vm.showDetails)
                                }
                                
                            }
                            .id(chapterSectionId)
                        }
                        .padding(.horizontal)
                }
            }
            .clipped()
            .navigationBarTitleDisplayMode(.inline)
            .transition(.opacity)
            
        }
        .onDisappear {
            isVisible = false
        }
        .onAppear{
            isVisible = true
            notificationManager.reset()
            isTabBarVisible.wrappedValue = false
            vm.getMangaDetail(from: detailUrl)
        }
        .navigationBarBackButtonHidden()
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    switch tab {
                    case .topMangas:
                        topMangasRouter.router.pop()
                        
                    case .searchMangas:
                        searchMangaRouter.router.pop()
                    case .myMangas:
                        myMangaRouter.router.pop()

                    }
                }label: {
                    Image(systemName: "arrowshape.left.fill")
                        .foregroundColor(.themeFour)
                }
            }
        }
        .animation(.easeInOut(duration: 0.5), value: vm.showDetails)
        .alert("Message", isPresented: $vm.showAlert) {
            Button("Ok"){
                NotificationCenter.default.post(name: .libraryUpdated, object: nil)
            }
        }message: {
            Text(vm.message)
        }
        .preferredColorScheme(.dark)
        .ignoresSafeArea(.keyboard)
        .onChange(of: notificationManager.mangaUrl) { mangaUrl in
            guard let mangaUrl = mangaUrl, isVisible else {return}
            notificationManager.reset()
            guard (detailUrl != mangaUrl) else {return}
            switch tab {
            case .myMangas:
                myMangaRouter.router.push(.mangaDetail(url: mangaUrl, from: .myMangas))
                break
            case .topMangas:
                topMangasRouter.router.push(.mangaDetail(url: mangaUrl, from: .topMangas))
                break
            case .searchMangas:
                searchMangaRouter.router.push(.mangaDetail(url: mangaUrl, from: .searchMangas))
                break
            }
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
