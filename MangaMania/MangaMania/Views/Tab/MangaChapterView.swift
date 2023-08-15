//
//  MangaChapterView.swift
//  MangaMania
//
//  Created by Rohan Bimal Raj on 13/08/23.
//
import Kingfisher
import SwiftUI

struct MangaChapterView: View {
        
    @EnvironmentObject private var mangaManager: MangaManager
    @EnvironmentObject private var topMangasRouter: TopMangasRouter
    @Environment(\.isTabBarVisible) private var isTabBarVisible
    @State private var pageUrls: [String] = []
    
    let chapterlUrl: String
    let tab: Tab
    
    var body: some View {
        ScrollView {
            ForEach(pageUrls, id: \.self) { url in
                KFImage(URL(string: url))
                    .requestModifier(mangaManager.chapterRequestModifier)
                    .resizable()
                    .placeholder({ _ in
                        ProgressView()
                    })
                    .scaledToFill()
                    .padding(.bottom, 2)
            }
        }
        .onAppear{
            isTabBarVisible.wrappedValue = false
            Task {
                pageUrls = try await mangaManager.getMangaChapterPages(from: chapterlUrl)
            }
        }
        .onDisappear{
            isTabBarVisible.wrappedValue = true
        }
        .navigationBarBackButtonHidden()
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    topMangasRouter.router.pop()
                }label: {
                    Image(systemName: "arrowshape.left.fill")
                        .foregroundColor(.themeThree)
                }
            }
        }
    }
}

struct MangaChapterView_Previews: PreviewProvider {
    static var previews: some View {
        MangaChapterView(chapterlUrl: "", tab: .topMangas)
            .environmentObject(MangaManager())
    }
}
