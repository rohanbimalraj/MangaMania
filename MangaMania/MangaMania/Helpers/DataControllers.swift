//
//  DataControllers.swift
//  MangaMania
//
//  Created by Rohan Bimal Raj on 16/08/23.
//
import CoreData
import Foundation

final class DataController: ObservableObject {
    
    let container = NSPersistentContainer(name: "MangaMania")
    
    init() {
        container.loadPersistentStores { description, error in
            if let error = error {
                print("Core data failed to load model with error \(error.localizedDescription)")
            }
        }
    }
}
