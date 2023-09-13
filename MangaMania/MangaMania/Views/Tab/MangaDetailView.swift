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
    
    @EnvironmentObject private var topMangasRouter: TopMangasRouter
    @EnvironmentObject private var searchMangaRouter: SearchMangaRouter
    @EnvironmentObject private var myMangaMangaRouter: MyMangasRouter
    
    @StateObject private var vm = ViewModel()
    
    @Environment(\.isTabBarVisible) private var isTabBarVisible
    @Namespace private var searchAnimation
    @Namespace private var chapterSectionId
    
    @State private var showSearchBar = false
    @State private var searchText = ""
    @FocusState private var isSearchFieldActive
    
    let detailUrl: String
    let tab: Tab
    
    var body: some View {
        
        ZStack {
            LinearGradient(gradient: Gradient(colors: [.themeTwo, .themeOne]), startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()
            if vm.showDetails {
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
                                        })
                                        .frame(width: 150, height: 250)
                                        .cornerRadius(10)
                                    
                                    VStack(alignment: .leading, spacing: 20) {
                                        Text(vm.mangaDetail?.title ?? "")
                                            .foregroundColor(.themeFour)
                                            .font(.custom(.bold, size: 24))
                                        VStack(alignment: .leading, spacing: 5) {
                                            
                                            HStack(alignment: .top ,spacing: 5) {
                                                Text("Author(s): ")
                                                    .foregroundColor(.themeFour)
                                                    .font(.custom(.semiBold, size: 16))
                                                Text(vm.mangaDetail?.authors ?? "")
                                                    .foregroundColor(.themeFour)
                                                    .font(.custom(.medium, size: 15))
                                            }

                                            HStack(alignment: .top, spacing: 5) {
                                                Text("Updated:  ")
                                                    .foregroundColor(.themeFour)
                                                    .font(.custom(.semiBold, size: 16))
                                                Text(vm.mangaDetail?.updatedDate ?? "")
                                                    .foregroundColor(.themeFour)
                                                    .font(.custom(.medium, size: 15))
                                            }
                                            
                                            HStack(alignment: .top, spacing: 5) {
                                                Text("Status:      ")
                                                    .foregroundColor(.themeFour)
                                                    .font(.custom(.semiBold, size: 16))
                                                Text(vm.mangaDetail?.status ?? "")
                                                    .foregroundColor(.themeFour)
                                                    .font(.custom(.medium, size: 15))
                                            }
                                        }
                                        
                                        HStack(alignment: .top) {
                                            RatingView(rating: .constant(vm.mangaDetail?.rating ?? 0))
                                            
                                            VStack {
                                                Image(systemName: vm.isAddedToLib ? "bookmark.fill" : "bookmark")
                                                    .foregroundColor(.themeFour)
                                                    .font(.largeTitle)
                                                    .onTapGesture {
                                                        vm.showldSave ? vm.saveToLib() : vm.deleteFromLib()
                                                    }
                                                Text(vm.isAddedToLib ? "Delete from\nlibrary" : "Save to\nlibrary")
                                                    .foregroundColor(.themeFour)
                                                    .font(.custom(.semiBold, size: 10))
                                                    .multilineTextAlignment(.center)
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
                                    ExpandableText(text: vm.mangaDetail?.description ?? "")
                                        .font(.custom(.regular, size: 14))
                                        .foregroundColor(.themeFour)
                                        .lineLimit(5)
                                        .expandButton(TextSet(text: "more", font: .custom(.bold, size: 16), color: .themeThree))
                                        .collapseButton(TextSet(text: "less", font: .custom(.bold, size: 16), color: .themeThree))

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
                                        if showSearchBar {
                                            HStack {
                                                Image(systemName: "magnifyingglass")
                                                    .matchedGeometryEffect(id: "detailSearch", in: searchAnimation)
                                                    .foregroundColor(.themeFour)
                                                
                                                TextField("Search", text: $searchText, prompt:
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
                                                        showSearchBar.toggle()
                                                    }
                                                }label: {
                                                    Image(systemName: "xmark.circle.fill")
                                                        .foregroundColor(.themeFour)
                                                }
                                            }
                                            .padding(5)
                                            .background(.themeTwo)
                                            .clipShape(Capsule())
                                            .onAppear {
                                                
                                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                                    isSearchFieldActive.toggle()
                                                }
                                            }
                                            
                                        }else {
                                            Button {
                                                
                                                withAnimation {
                                                    proxy.scrollTo(chapterSectionId)
                                                }
                                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                                    withAnimation() {
                                                        showSearchBar.toggle()
                                                    }
                                                }

                                            } label: {
                                                
                                                Image(systemName: "magnifyingglass")
                                                    .matchedGeometryEffect(id: "detailSearch", in: searchAnimation)
                                                    .foregroundColor(.themeFour)
                                                    .padding(5)
                                            }

                                        }
                                        
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
                                    List {
                                        ForEach(vm.sortedChapters) { chapter in
                                            Button {
                                                switch tab {
                                                case .topMangas:
                                                    topMangasRouter.router.push(.mangaChapter(url: chapter.chapUrl ?? "", from: tab))
                                                case .searchMangas:
                                                    searchMangaRouter.router.push(.mangaChapter(url: chapter.chapUrl ?? "", from: tab))
                                                case .myMangas:
                                                    myMangaMangaRouter.router.push(.mangaChapter(url: chapter.chapUrl ?? "", from: tab))

                                                }

                                            }label: {
                                                HStack {
                                                    Text(chapter.chapTitle ?? "")
                                                        .foregroundColor(.themeFour)
                                                        .font(.custom(.semiBold, size: 13))
                                                    Spacer()
                                                    
                                                    Image(systemName: "chevron.right")
                                                        .foregroundColor(.themeFour)
                                                }
                                            }
                                        }
                                        .listRowSeparatorTint(.themeTwo)
                                        .listRowBackground(Color.clear)
                                    }
                                    .frame(height: 400)
                                    .listStyle(.plain)
                                }
                                .id(chapterSectionId)
                            }
                            .padding(.horizontal)
                    }
                }
                .clipped()
                .navigationBarTitleDisplayMode(.inline)
                .transition(.opacity)

            }else {
                CustomLoaderView()
            }
            
        }
        .onAppear{
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
                        myMangaMangaRouter.router.pop()

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

    }
}

struct MangaDetailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            MangaDetailView(detailUrl: "", tab: .topMangas)
        }
    }
}
