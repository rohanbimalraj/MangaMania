//
//  MangaSearchViewModel.swift
//  MangaMania
//
//  Created by Rohan Bimal Raj on 16/08/23.
//
import Combine
import SwiftUI

extension MangaSearchView {
    
    @MainActor class ViewModel: ObservableObject {
        
        private let mangaManager = MangaManager.shared
        private var previousSearchText = ""
        private var cancellable = Set<AnyCancellable>()
        private var loadingTask: Task<Void, Never>?
        
        @Published var searchText = ""
        @Published private(set) var mangas: [Manga] = []
        @Published private(set) var loadingState: LoadingState = .idle
        
        init() {
            debounceSearchText()
        }
        
        deinit {
            loadingTask?.cancel()
        }
        
        private func debounceSearchText() {
            $searchText
                .debounce(for: 1.0, scheduler: RunLoop.main)
                .sink {
                    guard !$0.isEmpty else {
                        self.previousSearchText = ""
                        self.loadingState = .idle
                        self.mangas = []
                        return
                    }
                    guard $0 != self.previousSearchText else { return }
                    self.previousSearchText = $0
                    self.loadingState = .loading
                    self.getMangas(with: $0)
                    
                }
                .store(in: &cancellable)
        }
        
        private func getMangas(with title: String) {
            loadingTask = Task {
                let result = await mangaManager.getMangas(with: title)
                
                switch result {
                    
                case .success(let mangaArray):
                    mangas = mangaArray
                    guard mangas.isEmpty && !searchText.isEmpty else {
                        loadingState = .idle
                        return
                    }
                    loadingState = .error("No results found!!!!")
                    
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }
}
