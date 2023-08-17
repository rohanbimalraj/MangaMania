//
//  MyMangaViewModel.swift
//  MangaMania
//
//  Created by Rohan Bimal Raj on 17/08/23.
//

import SwiftUI

@MainActor
final class MyMangaViewModel: ObservableObject {
    
    @Published var myMangas: [MyManga] = []
    
    func getMyMangas() {
        myMangas = DataController.shared.fetchMangas()
    }
}
