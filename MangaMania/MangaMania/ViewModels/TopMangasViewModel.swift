//
//  TopMangasViewModel.swift
//  MangaMania
//
//  Created by Rohan Bimal Raj on 18/08/23.
//

import SwiftUI

@MainActor
final class TopMangasViewModel: ObservableObject {
    
    @Published var mangas: [Manga] = []
    @Published var state: LoadingState = .idle {
        didSet {
            //print("Rohan's super:", state)
        }
    }
    
    private var page = 1
    private let maxPageLimit = 5
    
    let mangaManager = MangaManager()
    
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


