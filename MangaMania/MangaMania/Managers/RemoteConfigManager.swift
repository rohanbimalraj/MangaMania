//
//  RemoteConfigManager.swift
//  MangaMania
//
//  Created by Rohan Bimal Raj on 28/08/23.
//
import FirebaseRemoteConfig
import Foundation

final class RemoteConfigManager {
    
    static let shared = RemoteConfigManager()
    
    private let remoteConfig: RemoteConfig
    
    // MARK: - Properties
    private(set) var appStoreVersion: String = ""
    private(set) var forceRequired: Bool = false
    private(set) var appStoreURL: String = ""
    private(set) var homeScreen: HomeScreen = .default
    private(set) var detailScreen: DetailScreen = .default
    private(set) var chapterScreen: ChapterScreen = .default
    private(set) var searchScreen: SearchScreen = .default
    
    // MARK: - Init
    private init() {
        self.remoteConfig = RemoteConfig.remoteConfig()
        let settings = RemoteConfigSettings()
        settings.minimumFetchInterval = 3600.0
        #if DEBUG
        settings.minimumFetchInterval = 0.0
        #endif
        remoteConfig.configSettings = settings
        remoteConfig.setDefaults(fromPlist: "RemoteConfigDefaults")
        
        // Load initial values from defaults
        loadValues()
    }
    
    // MARK: - Configure and Fetch
    func configure(completion: @escaping () -> Void) {
        remoteConfig.fetchAndActivate { [weak self] status, error in
            if let error = error {
                print("RemoteConfig fetchAndActivate error: \(error.localizedDescription)")
                completion()
            } else {
                print("RemoteConfig fetchAndActivate status: \(status.rawValue)")
                self?.loadValues()
                completion()
            }
        }
    }
    
    // MARK: - Decode helper
    private func decode<T: Decodable>(forKey key: String) -> T? {
        guard let jsonString = remoteConfig.configValue(forKey: key).stringValue,
              let data = jsonString.data(using: .utf8) else {
            print("Failed to get JSON string for key: \(key)")
            return nil
        }
        
        do {
            return try JSONDecoder().decode(T.self, from: data)
        } catch {
            print("Decoding error for key: \(key): \(error)")
            return nil
        }
    }
    
    // MARK: - Load all remote config values
    private func loadValues() {
        self.appStoreVersion = remoteConfig.configValue(forKey: "force_update_current_version").stringValue ?? ""
        self.forceRequired = remoteConfig.configValue(forKey: "is_force_update_required").boolValue
        self.appStoreURL = remoteConfig.configValue(forKey: "force_update_store_url").stringValue ?? ""
        
        self.homeScreen = decode(forKey: "home_screen") ?? .default
        self.detailScreen = decode(forKey: "detail_screen") ?? .default
        self.chapterScreen = decode(forKey: "chapter_screen") ?? .default
        self.searchScreen = decode(forKey: "search_screen") ?? .default
    }
}
