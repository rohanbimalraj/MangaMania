//
//  MangaDetailViewModel.swift
//  MangaMania
//
//  Created by Rohan Bimal Raj on 16/08/23.
//
import CoreData
import SwiftUI

@MainActor
final class MangaDetailViewModel: ObservableObject {
    
    let mangaManager = MangaManager()
    
    @Published var mangaDetail: MangaDetail?
    
    var showDetails: Bool {
        mangaDetail != nil
    }
    
    
    func getMangaDetail(from url: String) async throws {
        do {
            mangaDetail = try await mangaManager.getMangaDetail(from: url)
        }catch {
            throw error
        }
    }
}
