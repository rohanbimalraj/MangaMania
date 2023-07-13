//
//  MangaManiaApp.swift
//  MangaMania
//
//  Created by Rohan Bimal Raj on 12/07/23.
//

import SwiftUI
import Firebase

@main
struct MangaManiaApp: App {
    
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
