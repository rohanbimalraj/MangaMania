//
//  RemoteConfigManager.swift
//  MangaMania
//
//  Created by Rohan Bimal Raj on 28/08/23.
//
import FirebaseRemoteConfig
import Foundation

struct RemoteConfigManager {
    
    private static var remoteConfig: RemoteConfig = {
        
        var remoteConfig = RemoteConfig.remoteConfig()
        let settings = RemoteConfigSettings()
        settings.minimumFetchInterval = 0
        remoteConfig.configSettings = settings
        remoteConfig.setDefaults(fromPlist: "RemoteConfigDefaults")
        return remoteConfig
    }()
    
    static func configure(expirationDuration: TimeInterval = 3600.0) {
        remoteConfig.fetch(withExpirationDuration: expirationDuration) { status, error in
            if let error = error {
                print(error.localizedDescription)
            }else {
                remoteConfig.activate()
                print("Successfully fetched remote config!!!!")
            }
        }
    }
    
    static func value(forKey key: String) -> String {
        if let value = remoteConfig.configValue(forKey: key).stringValue {
            return value
        }
        fatalError("Couldn't get remote config value")
    }
}
