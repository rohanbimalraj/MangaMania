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
            ScrollView {
                if showDetails {
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
                    .animation(.default, value: showDetails)
                }
            }
            .clipped()
            .padding(.bottom, 90)
            .navigationBarTitleDisplayMode(.inline)

            
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
                    topMangasRouter.router.pop()
                }label: {
                    Image(systemName: "arrowshape.left.fill")
                        .foregroundColor(.themeFour)
                }
            }
        }
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
