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
    
    @EnvironmentObject private var mangaManager: MangaManager
    @EnvironmentObject private var topMangasRouter: TopMangasRouter
    @EnvironmentObject private var searchMangaRouter: SearchMangaRouter
    
    @State private var mangaDetail: MangaDetail?
    var showDetails: Bool {
       return mangaDetail != nil
    }
    
    let detailUrl: String
    let tab: Tab
    
    var body: some View {
        
        ZStack {
            LinearGradient(gradient: Gradient(colors: [.themeTwo, .themeOne]), startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()
            if showDetails {
                ScrollView {
                        VStack {
                            HStack(alignment: .top) {
                                KFImage(URL(string: mangaDetail?.coverUrl ?? ""))
                                    .resizable()
                                    .fade(duration: 0.5)
                                    .placeholder({
                                        Image("book-cover-placeholder")
                                            .resizable()
                                    })
                                    .frame(width: 150, height: 250)
                                    .cornerRadius(10)
                                
                                VStack(alignment: .leading, spacing: 20) {
                                    Text(mangaDetail?.title ?? "")
                                        .foregroundColor(.themeFour)
                                        .font(.custom(.bold, size: 24))
                                    VStack(alignment: .leading, spacing: 5) {
                                        
                                        HStack(alignment: .top ,spacing: 5) {
                                            Text("Author(s): ")
                                                .foregroundColor(.themeFour)
                                                .font(.custom(.semiBold, size: 16))
                                            Text(mangaDetail?.authors ?? "")
                                                .foregroundColor(.themeFour)
                                                .font(.custom(.medium, size: 15))
                                        }

                                        HStack(alignment: .top, spacing: 5) {
                                            Text("Updated:  ")
                                                .foregroundColor(.themeFour)
                                                .font(.custom(.semiBold, size: 16))
                                            Text(mangaDetail?.updatedDate ?? "")
                                                .foregroundColor(.themeFour)
                                                .font(.custom(.medium, size: 15))
                                        }
                                        
                                        HStack(alignment: .top, spacing: 5) {
                                            Text("Status:      ")
                                                .foregroundColor(.themeFour)
                                                .font(.custom(.semiBold, size: 16))
                                            Text(mangaDetail?.status ?? "")
                                                .foregroundColor(.themeFour)
                                                .font(.custom(.medium, size: 15))
                                        }
                                    }
                                    
                                    RatingView(rating: .constant(mangaDetail?.rating ?? 0))
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
                                if mangaDetail != nil {
                                    ExpandableText(text: mangaDetail?.description ?? "")
                                        .font(.custom(.regular, size: 14))
                                        .foregroundColor(.themeFour)
                                        .lineLimit(5)
                                        .expandButton(TextSet(text: "more", font: .custom(.bold, size: 16), color: .themeThree))
                                        .collapseButton(TextSet(text: "less", font: .custom(.bold, size: 16), color: .themeThree))
                                }

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
                                    ForEach(mangaDetail?.chapters ?? []) { chapter in
                                        Button {
                                            switch tab {
                                            case .topMangas:
                                                topMangasRouter.router.push(.mangaChapter(url: chapter.chapUrl ?? "", from: .topMangas))
                                            case .searchMangas:
                                                searchMangaRouter.router.push(.mangaChapter(url: chapter.chapUrl ?? "", from: .searchMangas))
                                            default:
                                                break
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
                LottieView()
                    .frame(width: 200, height: 200)
                    .padding(.bottom, 90)
                    .overlay(alignment: .bottom) {
                        Text("Loading...")
                            .font(.custom(.black, size: 16))
                            .foregroundColor(.themeFour)
                            .padding(.bottom, 100)
                    }
            }
            
        }
        .onAppear{
            Task {
                do {
                    mangaDetail = try await mangaManager.getMangaDetail(from: detailUrl)
                    
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
                        
                    default:
                        break
                    }
                }label: {
                    Image(systemName: "arrowshape.left.fill")
                        .foregroundColor(.themeFour)
                }
            }
        }
        .animation(.easeInOut(duration: 0.5), value: showDetails)
    }
}

struct MangaDetailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            MangaDetailView(detailUrl: "", tab: .topMangas)
                .environmentObject(MangaManager())
        }
    }
}
