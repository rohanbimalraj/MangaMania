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
    
    private func save() {
        do {
            try context.save()
        }catch {
            print(error.localizedDescription)
        }
    }
    
    func addMangaToLib(title: String, detailUrl: String, coverUrl: String) {
        
        let myManga = MyManga(context: context)
        myManga.id = UUID()
        myManga.coverUrl = coverUrl
        myManga.detailUrl = detailUrl
        myManga.title = title
        myManga.date = Date.now
        save()
    }
    
    
    func deleteMangaFromLib(manga: MyManga) {
        context.delete(manga)
        save()
    }
}
