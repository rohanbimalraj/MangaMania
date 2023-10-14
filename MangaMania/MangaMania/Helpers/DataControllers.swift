//
//  DataControllers.swift
//  MangaMania
//
//  Created by Rohan Bimal Raj on 16/08/23.
//
import CoreData
import Foundation

final class DataController {
    
    static let shared = DataController()
    
    let container = NSPersistentContainer(name: "MangaMania")
    
    private var context: NSManagedObjectContext {
        container.viewContext
    }
    
    private init() {
        container.loadPersistentStores { description, error in
            if let error = error {
                print("Core data failed to load model with error \(error.localizedDescription)")
            }
        }
    }
    
    func fetchMangas() -> [MyManga] {
        
        let request = NSFetchRequest<MyManga>(entityName: "MyManga")
        let sort = NSSortDescriptor(key: "date", ascending: false)
        request.sortDescriptors = [sort]
        
        do {
            return try context.fetch(request)
            
        }catch {
            print(error.localizedDescription)
            return []
        }
    }
    
    private func save(completion: (Result<String, Error>) -> Void) {
        do {
            try context.save()
            completion(.success("Library updated successfully"))
        }catch {
            print(error.localizedDescription)
            completion(.failure(error))
        }
    }
    
    func addMangaToLib(title: String, detailUrl: String, coverUrl: String, completion: (Result<String, Error>) -> Void) {
        
        let myManga = MyManga(context: context)
        myManga.id = UUID()
        myManga.coverUrl = coverUrl
        myManga.detailUrl = detailUrl
        myManga.title = title
        myManga.date = Date.now
        save(completion: completion)
    }
    
    
    func deleteMangaFromLib(with title: String, completion: (Result<String, Error>) -> Void) {
        let mangas = fetchMangas()
        let requiredManga = mangas.filter{ $0.title == title }.first
        guard let requiredManga = requiredManga else {
            completion(.failure(AppErrors.internalError))
            return
        }
        context.delete(requiredManga)
        save(completion: completion)
    }
    
    func updateSelectedChapter(of title: String, with chapTitle: String) {
        let mangas = fetchMangas()
        let requiredManga = mangas.filter{ $0.title == title }.first
        guard let requiredManga = requiredManga else {
            return
        }
        requiredManga.selectedChapTitle = chapTitle
        save { _ in }
    }
    
    func isMangaInLib(with title: String) -> (Bool, String) {
        let mangas = fetchMangas()
        guard let requiredManga = mangas.filter({ $0.title == title }).first else {
            return (false, "")
        }
        return (true, requiredManga.selectedChapTitle ?? "")
    }
}
