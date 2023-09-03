//
//  UIApplication+Extension.swift
//  MangaMania
//
//  Created by Rohan Bimal Raj on 15/08/23.
//

import SwiftUI

extension UIApplication {
    
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    
    func openAppStore() {
        let appStoreURL = RemoteConfigManager.value(forKey: RCKey.FORCE_UPDATE_STORE_URL)
        guard let url = URL(string: appStoreURL) else {
            return
        }

        DispatchQueue.main.async {
            if self.canOpenURL(url) {
                self.open(url)
            }
        }
    }
}
