//
//  MangaChapterView.swift
//  MangaMania
//
//  Created by Rohan Bimal Raj on 13/08/23.
//

import SwiftUI

struct MangaChapterView: View {
    
    @EnvironmentObject private var mangaManager: MangaManager
    
    let chapterlUrl: String
    let tab: Tab
    
    var body: some View {
        ScrollView {
            Text(chapterlUrl)
        }
        .onAppear{
            Task {
                let pageUrls = try await mangaManager.getMangaChapterPages(from: chapterlUrl)
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
