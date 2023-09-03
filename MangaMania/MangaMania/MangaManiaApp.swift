//
//  MangaManiaApp.swift
//  MangaMania
//
//  Created by Rohan Bimal Raj on 12/07/23.
//

import SwiftUI
import Firebase
import Kingfisher


@main
struct MangaManiaApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    var body: some Scene {
        WindowGroup {
            AppRouterView()
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        RemoteConfigManager.configure()
        
        let cache = ImageCache.default
        // Constrain In-Memory Cache to 10 MB
        cache.memoryStorage.config.totalCostLimit = 1024 * 1024 * 10
        
        return true
    }
}
