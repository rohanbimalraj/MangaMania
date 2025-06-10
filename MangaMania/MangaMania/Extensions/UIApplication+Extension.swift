//
//  UIApplication+Extension.swift
//  MangaMania
//
//  Created by Rohan Bimal Raj on 15/08/23.
//

import SwiftUI

extension UIApplication {

    var hasBottomSafeArea: Bool {
        guard let windowScene = connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first else {
            return false
        }
        return window.safeAreaInsets.bottom > 0
    }

    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }

    func openAppStore() {
        let appStoreURL = RemoteConfigManager.shared.appStoreURL
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
