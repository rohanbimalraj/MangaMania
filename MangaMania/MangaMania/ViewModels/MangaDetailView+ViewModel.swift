//
//  MangaDetailViewModel.swift
//  MangaMania
//
//  Created by Rohan Bimal Raj on 16/08/23.
//
import SwiftUI

extension MangaDetailView {
    
    @MainActor class ViewModel: ObservableObject {
        
        enum SortType {
            case oldestToNewest, newestToOldest
        }
        
        @Published private(set) var mangaDetail: MangaDetail?
        @Published private(set) var sortedChapters: [MangaDetail.Chapter] = []
        @Published private(set) var isAddedToLib = false
        @Published private(set) var sortType: SortType = .newestToOldest
        @Published var showAlert = false
        
        let mangaManager = MangaManager.shared
        
        private var detailUrl = ""
        private var loadingTask: Task<Void, Never>?
        var message = ""
                
        var showDetails: Bool {
            mangaDetail != nil
        }
        
        var showldSave: Bool {
            !DataController.shared.isMangaInLib(with: mangaDetail?.title ?? "")
        }
        
        deinit {
            loadingTask?.cancel()
        }
        
        func getMangaDetail(from url: String) {
            detailUrl = url

            loadingTask = Task {
                
                let result = await mangaManager.getMangaDetail(from: detailUrl)
                switch result {
                    
                case.success(let detail):
                    mangaDetail = detail
                    sortedChapters = detail.chapters ?? []
                    sortChapters(from: sortType)
                    isAddedToLib = DataController.shared.isMangaInLib(with: mangaDetail?.title ?? "")
                    
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
        
        func saveToLib() {
            
            DataController.shared.addMangaToLib(title: mangaDetail?.title ?? "", detailUrl: detailUrl, coverUrl: mangaDetail?.coverUrl ?? "") { result in
                switch result {
                case .success(let message):
                    self.message = message
                    isAddedToLib = true
                    
                case .failure(let error):
                    self.message = error.localizedDescription
                    print(error.localizedDescription)
                }
                
                showAlert = true
            }
        }
        
        func deleteFromLib() {
            DataController.shared.deleteMangaFromLib(with: mangaDetail?.title ?? "") { result in
                
                switch result {
                    
                case .success(let message):
                    self.message = message
                    isAddedToLib = false
                    
                case.failure(let error):
                    self.message = error.localizedDescription
                    print(error.localizedDescription)
                }
                
                showAlert = true
            }
        }
        
        func sortChapters(from type: SortType) {
            sortType = type
            switch sortType {
                
            case .newestToOldest:
                sortedChapters = sortedChapters.sorted { $0 > $1 }
                
            case .oldestToNewest:
                sortedChapters = sortedChapters.sorted { $0 < $1 }
                
            }
        }
    }
}
