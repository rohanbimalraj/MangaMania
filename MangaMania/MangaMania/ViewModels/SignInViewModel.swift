//
//  SignInViewModel.swift
//  MangaMania
//
//  Created by Rohan Bimal Raj on 16/07/23.
//

import SwiftUI

@MainActor
class SignInViewModel: ObservableObject {
    
    @Published var email = ""
    @Published var password = ""
    
    func signIn() {
        
        guard !email.isEmpty, !password.isEmpty else {
            print("No Email or Password found")
            return
        }
        
        Task {
            do {
                let returnedUserData = try await AuthenticationManager.shared.createUser(email: email, password: password)
                print("Success", returnedUserData)
            }catch {
                print(error.localizedDescription)
            }
        }
    }
}
