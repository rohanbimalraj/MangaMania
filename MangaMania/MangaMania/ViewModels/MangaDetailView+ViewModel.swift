//
//  MangaDetailViewModel.swift
//  MangaMania
//
//  Created by Rohan Bimal Raj on 16/08/23.
//
import Combine
import SwiftUI

extension MangaDetailView {
    
    @MainActor class ViewModel: ObservableObject {
        
        enum SortType {
            case oldestToNewest, newestToOldest
        }
        
        @Published private(set) var mangaDetail: MangaDetail?
        @Published private(set) var actualChapters: [MangaDetail.Chapter] = []
        @Published private(set) var requiredChapters: [MangaDetail.Chapter] = []
        @Published private(set) var isAddedToLib = false
        @Published private(set) var sortType: SortType = .newestToOldest
        @Published var showAlert = false
        @Published var searchText = ""
        private var subscriptions = Set<AnyCancellable>()
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
        init() {
            debounceSearchText()
        }
        
        deinit {
            loadingTask?.cancel()
            subscriptions.removeAll()
        }
        
        private func debounceSearchText() {
            $searchText
                .debounce(for: 0.5, scheduler: RunLoop.main)
                .sink {
                    guard !$0.isEmpty else {
                        self.requiredChapters = self.actualChapters
                        self.sortChapters(from: self.sortType)
                        return
                    }
                    let text = $0
                    self.requiredChapters = self.requiredChapters.filter({ chap in
                        return chap.chapTitle?.contains(text) ?? false
                    })
                }
                .store(in: &subscriptions)
        }
        
        func discardSearch() {
            searchText = ""
        }
        
        func getMangaDetail(from url: String) {
            detailUrl = url

            loadingTask = Task {
                
                let result = await mangaManager.getMangaDetail(from: detailUrl)
                switch result {
                    
                case.success(let detail):
                    mangaDetail = detail
                    actualChapters = detail.chapters ?? []
                    requiredChapters = actualChapters
                    //sortedChapters = detail.chapters ?? []
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
                requiredChapters = requiredChapters.sorted { $0 > $1 }
                
            case .oldestToNewest:
                requiredChapters = requiredChapters.sorted { $0 < $1 }
                
            }
        }
    }
}
