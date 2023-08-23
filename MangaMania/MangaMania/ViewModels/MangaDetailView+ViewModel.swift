//
//  MangaDetailViewModel.swift
//  MangaMania
//
//  Created by Rohan Bimal Raj on 16/08/23.
//
import SwiftUI

extension MangaDetailView {
    
    @MainActor class ViewModel: ObservableObject {
        
        let mangaManager = MangaManager()
        private var detailUrl = ""
        
        @Published private(set) var mangaDetail: MangaDetail?
        @Published private(set) var isAddedToLib = false
        @Published var showAlert = false
        var message = ""
        
        var showDetails: Bool {
            mangaDetail != nil
        }
        
        var showldSave: Bool {
            !DataController.shared.isMangaInLib(with: mangaDetail?.title ?? "")
        }
        
        
        func getMangaDetail(from url: String) async throws {
            detailUrl = url
            do {
                mangaDetail = try await mangaManager.getMangaDetail(from: detailUrl)
            }catch {
                throw error
            }
            isAddedToLib = DataController.shared.isMangaInLib(with: mangaDetail?.title ?? "")
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
    }
}
