//
//  LoginViewModel.swift
//  MangaMania
//
//  Created by Rohan Bimal Raj on 21/07/23.
//

import SwiftUI

@MainActor
class LoginViewModel: ObservableObject {
    
    @Published var email = ""
    @Published var password = ""
    
    var authenticationManager: AuthenticationManager?
    
    func login() async throws {
        
        guard !email.isEmpty else {
            throw AppErrors.emailEmpty
        }
        
        guard !password.isEmpty else {
            throw AppErrors.passwordEmpty
        }
        
        do {
            
            try await authenticationManager?.signIn(email: email, password: password)
            
        }catch {
            throw error
        }
    }
}
