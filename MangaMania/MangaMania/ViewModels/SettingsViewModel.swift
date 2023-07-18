//
//  SettingsViewModel.swift
//  MangaMania
//
//  Created by Rohan Bimal Raj on 16/07/23.
//

import SwiftUI

@MainActor
class SettingsViewModel: ObservableObject {
    
    func signOut() throws {
        try AuthenticationManager.shared.signOut()
    }
    
    func resetPassword() async throws {
        try await AuthenticationManager.shared.resetPassword()
    }
}
