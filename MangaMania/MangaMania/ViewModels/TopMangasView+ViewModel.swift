//
//  TopMangasViewModel.swift
//  MangaMania
//
//  Created by Rohan Bimal Raj on 18/08/23.
//

import SwiftUI

extension TopMangasView {
    
    @MainActor class ViewModel: ObservableObject {
        
        @Published private(set) var mangas: [Manga] = []
        @Published private (set) var state: LoadingState = .idle
        
        private var page = 1
        private let maxPageLimit = 5
        
        private let mangaManager = MangaManager()
        
        func getTopMangas() {
            guard page <= 5 && state == .idle else { return }
            self.state = .loading
            Task {
                do {
                    let mangas = try await mangaManager.getTopMangas(in: self.page)
                    self.page += 1
                    self.mangas.append(contentsOf: mangas)
                    self.state = .idle
                }catch {
                    print(error.localizedDescription)
                }
            }
        }
    }
}

