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
        @Published private(set) var state: LoadingState = .idle
        
        private var page = 1
        private var loadingTask: Task<Void, Never>?
        private let maxPageLimit = 5
        private let mangaManager = MangaManager.shared
        
        deinit {
            loadingTask?.cancel()
        }
        
        func getTopMangas() {
            guard page <= 5 && state == .idle else { return }
            self.state = .loading
            loadingTask = Task {
                
                let result = await mangaManager.getTopMangas(in: page)
                switch result {
                    
                case .success(let mangaArray):
                    page += 1
                    mangas.append(contentsOf: mangaArray)
                    state = .idle
                    
                case .failure(let error):
                    print(error.localizedDescription)
                    
                }
            }
        }
    }
}

