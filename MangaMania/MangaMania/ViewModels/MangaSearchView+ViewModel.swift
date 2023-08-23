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
        private var cancellable = Set<AnyCancellable>()
        
        @Published var searchText = ""
        @Published private(set) var mangas: [Manga] = []
        
        init() {
            debounceSearchText()

        }
        
        private func debounceSearchText() {
            $searchText
                .debounce(for: 1.0, scheduler: RunLoop.main)
                .sink {
                    guard !$0.isEmpty else {
                        self.mangas = []
                        return
                    }
                    self.getMangas(with: $0)
                    
                }
                .store(in: &cancellable)
        }
        
        private func getMangas(with title: String) {
            Task {
                do {
                    mangas = try await mangaManager.getMangas(with: title)

                }catch {
                    print(error.localizedDescription)
                }
            }
        }
    }
}
