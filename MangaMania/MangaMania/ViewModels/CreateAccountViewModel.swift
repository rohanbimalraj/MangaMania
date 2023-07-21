//
//  CreateAccountViewModel.swift
//  MangaMania
//
//  Created by Rohan Bimal Raj on 20/07/23.
//

import SwiftUI

@MainActor
class CreateAccountViewModel: ObservableObject {
    
    @Published var email = ""
    @Published var password = ""
    @Published var confirmPassword = ""
        
    var authenticationManager: AuthenticationManager?
    
    func signUp() async throws {
        
        guard !email.isEmpty else {
            throw AppErrors.emailEmpty
        }
        
        guard !password.isEmpty else {
            throw AppErrors.passwordEmpty
        }
        
        guard !confirmPassword.isEmpty else {
            throw AppErrors.confirmPasswordEmpty
        }
        
        guard password == confirmPassword else {
            throw AppErrors.passwordMismatch
        }
        
        do {
            
            try await authenticationManager?.createUser(email: email, password: password)
            
        }catch {
            throw error
        }
    }
}
