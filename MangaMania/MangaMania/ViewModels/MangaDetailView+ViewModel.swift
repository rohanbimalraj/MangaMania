//
//  MangaDetailViewModel.swift
//  MangaMania
//
//  Created by Rohan Bimal Raj on 16/08/23.
//
import SwiftUI

extension MangaDetailView {
    
    @MainActor class ViewModel: ObservableObject {
        
        @Published private(set) var mangaDetail: MangaDetail?
        @Published private(set) var isAddedToLib = false
        @Published var showAlert = false
        
        let mangaManager = MangaManager.shared
        
        private var detailUrl = ""
        private var loadingTask: Task<Void, Never>?
        var message = ""
        
        var isReadFeatureEnabled: Bool = {
            let currentVersion = "\(Bundle.appVersionBundle)(\(Bundle.appBuildBundle))"
            let readFeatureVersion = RemoteConfigManager.value(forKey: RCKey.READ_FEATURE_VERSION)
            return currentVersion == readFeatureVersion
        }()
        
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
    }
}
