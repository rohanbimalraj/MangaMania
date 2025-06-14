//
//  AppRouterView+ViewModel.swift
//  MangaMania
//
//  Created by Rohan Bimal Raj on 28/08/23.
//

import SwiftUI

extension AppRouterView {
    
    @MainActor class ViewModel: ObservableObject {
        
        @Published var showSplash = true
        @Published var showUpdateAlert = false
        @Published var configReady = false
        private let remoteConfig = RemoteConfigManager.shared
        
        func checkForUpdate() {
            let currentVersion = "\(Bundle.appVersionBundle)(\(Bundle.appBuildBundle))"
            let appStoreVersion = remoteConfig.appStoreVersion
            let forceRequired = remoteConfig.forceRequired
            
            if forceRequired {
                if appStoreVersion > currentVersion {
                    showUpdateAlert = true
                }else {
                    showSplash = false
                }
                return
            }
            showSplash = false
        }
    }
}
