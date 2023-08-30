//
//  MangaChapterView.swift
//  MangaMania
//
//  Created by Rohan Bimal Raj on 13/08/23.
//
import Kingfisher
import SwiftUI

struct MangaChapterView: View {
        
    @EnvironmentObject private var topMangasRouter: TopMangasRouter
    @EnvironmentObject private var searchMangaRouter: SearchMangaRouter
    @EnvironmentObject private var myMangaMangaRouter: MyMangasRouter
    
    @Environment(\.isTabBarVisible) private var isTabBarVisible
    @State private var pageUrls: [String] = []
    
    let chapterlUrl: String
    let tab: Tab
    
    var body: some View {
        
        ZStack {
            
            ScrollView {
                ForEach(pageUrls, id: \.self) { url in
                    KFImage(URL(string: url))
                        .requestModifier(MangaManager.shared.chapterRequestModifier)
                        .resizable()
                        .placeholder({ _ in
                            ProgressView()
                        })
                        .scaledToFill()
                        .padding(.bottom, 2)
                        .pinchToZoom()
                }
            }
            .onAppear{
                isTabBarVisible.wrappedValue = false
                Task {
                    pageUrls = try await MangaManager.shared.getMangaChapterPages(from: chapterlUrl)
                }
            }
            .onDisappear{
                isTabBarVisible.wrappedValue = true
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
                            .foregroundColor(.themeThree)
                    }
                }
            }
            
        }
        .background(.black)
    }
}

struct MangaChapterView_Previews: PreviewProvider {
    static var previews: some View {
        MangaChapterView(chapterlUrl: "", tab: .topMangas)
    }
}
