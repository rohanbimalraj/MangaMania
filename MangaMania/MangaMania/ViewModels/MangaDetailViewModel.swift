//
//  MangaDetailViewModel.swift
//  MangaMania
//
//  Created by Rohan Bimal Raj on 16/08/23.
//
import CoreData
import SwiftUI

final class MangaDetailViewModel: ObservableObject {
    
    let mangaManager = MangaManager()
    let detailUrl: String
    private (set) var moc: NSManagedObjectContext
    
    @Published var mangaDetail: MangaDetail?
    
    var showDetails: Bool {
        mangaDetail != nil
    }
    
    init(moc: NSManagedObjectContext, detailUrl: String) {
        self.moc = moc
        self.detailUrl = detailUrl
    }
    
    func getMangaDetail() {
        Task {
            do {
                mangaDetail = try await mangaManager.getMangaDetail(from: detailUrl)
            }catch {
                print(error.localizedDescription)
            }
        }
    }
    
}
