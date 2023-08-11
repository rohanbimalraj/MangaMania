//
//  MangaSearchView.swift
//  MangaMania
//
//  Created by Rohan Bimal Raj on 23/07/23.
//

import SwiftUI

struct MangaSearchView: View {
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [.themeTwo, .themeOne]), startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()
        }
        .navigationTitle("Search Manga")
    }
}

struct MangaSearchView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            MangaSearchView()
        }
    }
}
