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
    
    let detailUrl: String
    let tab: Tab
    
    var body: some View {
        
        ZStack {
            LinearGradient(gradient: Gradient(colors: [.themeTwo, .themeOne]), startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()
            if vm.showDetails {
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
                            
                            VStack(alignment: .leading, spacing: 20) {
                                Text("Chapters")
                                    .foregroundColor(.themeFour)
                                    .font(.custom(.bold, size: 20))
                                List {
                                    ForEach(vm.mangaDetail?.chapters ?? []) { chapter in
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
                        }
                        .padding(.horizontal)
                }
                .clipped()
                .padding(.bottom, 90)
                .navigationBarTitleDisplayMode(.inline)
                .transition(.opacity)

            }else {
                CustomLoaderView()
            }
            
        }
        .onAppear{
            Task {
                do {
                    try await vm.getMangaDetail(from: detailUrl)

                }catch {
                    print(error.localizedDescription)
                }
            }
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
            Button("Ok"){}
        }message: {
            Text(vm.message)
        }
        .preferredColorScheme(.dark)
    }
}

struct MangaDetailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            MangaDetailView(detailUrl: "", tab: .topMangas)
        }
    }
}
