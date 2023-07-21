//
//  SettingsViewModel.swift
//  MangaMania
//
//  Created by Rohan Bimal Raj on 16/07/23.
//

import SwiftUI

@MainActor
class SettingsViewModel: ObservableObject {
    
    var authenticationManager: AuthenticationManager?
    
    func signOut() throws {
        try authenticationManager?.signOut()
    }
    
    func resetPassword() async throws {
        try await authenticationManager?.resetPassword()
    }
}
