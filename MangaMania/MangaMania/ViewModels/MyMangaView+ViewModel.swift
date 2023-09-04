//
//  MyMangaViewModel.swift
//  MangaMania
//
//  Created by Rohan Bimal Raj on 17/08/23.
//

import SwiftUI

extension MyMangasView {
    
    @MainActor class ViewModel: ObservableObject {
        
        @Published private(set) var myMangas: [MyManga] = []
        @Published var showEmptyMessage = false
        
        func getMyMangas() {
            myMangas = DataController.shared.fetchMangas()
            showEmptyMessage = myMangas.isEmpty
        }
    }
}
