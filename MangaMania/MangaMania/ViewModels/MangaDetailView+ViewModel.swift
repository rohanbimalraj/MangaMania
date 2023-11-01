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
        @Published private(set) var actualChapters: [MangaDetail.Chapter] = MangaDetail.dummyChapters
        @Published private(set) var requiredChapters: [MangaDetail.Chapter] = MangaDetail.dummyChapters
        @Published private(set) var isAddedToLib = false
        @Published private(set) var sortType: SortType = .newestToOldest
        @Published var showAlert = false
        @Published var searchText = ""
        private var subscriptions = Set<AnyCancellable>()
        let mangaManager = MangaManager.shared
        
        private var detailUrl = ""
        private var loadingTask: Task<Void, Never>?
        var message = ""
        private(set) var selectedChapTitle = ""
                
        var showDetails: Bool {
            mangaDetail != nil
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
                    let mangaInLib = DataController.shared.isMangaInLib(with: detail.title ?? "")
                    isAddedToLib = mangaInLib.0
                    selectedChapTitle = mangaInLib.1
                    mangaDetail = detail
                    actualChapters = detail.chapters ?? []
                    requiredChapters = actualChapters
                    sortChapters(from: sortType)
                    
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
        
        func updateSelectedChapter(title: String) {
            guard isAddedToLib else { return }
            DataController.shared.updateSelectedChapter(of: mangaDetail?.title ?? "", with: title)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.selectedChapTitle = title
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
