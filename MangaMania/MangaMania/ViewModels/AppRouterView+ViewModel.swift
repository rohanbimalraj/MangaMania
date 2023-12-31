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
        
        func checkForUpdate() {
            let currentVersion = "\(Bundle.appVersionBundle)(\(Bundle.appBuildBundle))"
            let appStoreVersion = RemoteConfigManager.value(forKey: RCKey.FORCE_UPDATE_CURRENT_VERSION)
            let forceRequired = RemoteConfigManager.value(forKey: RCKey.IS_FORCE_UPDATE_REQUIRED).boolValue
            
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
