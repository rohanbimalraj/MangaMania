//
//  AuthenticationManager.swift
//  MangaMania
//
//  Created by Rohan Bimal Raj on 16/07/23.
//

import FirebaseAuth
import SwiftUI

struct AuthDataResultModel {
    
    let uid: String
    let email: String?
    let photoUrl: String?
    
    init(user: User) {
        uid = user.uid
        email = user.email
        photoUrl = user.photoURL?.absoluteString
    }
}

class AuthenticationManager: ObservableObject {
            
    var isUserLoggedIn: Bool {
        currentUser != nil
    }
    
    @Published var currentUser: User?
    
    init() {
        currentUser = Auth.auth().currentUser
    }
    
    @discardableResult
    func createUser(email: String, password: String) async throws -> AuthDataResultModel {
        let authDataResult = try await Auth.auth().createUser(withEmail: email, password: password)
        DispatchQueue.main.async {
            self.currentUser = Auth.auth().currentUser
        }
        return AuthDataResultModel(user: authDataResult.user)
    }
    
    func getAuthenticatedUser() throws -> AuthDataResultModel {
        guard let user = Auth.auth().currentUser else {
            throw URLError(.badServerResponse)
        }
        
        return AuthDataResultModel(user: user)
    }
    
    @discardableResult
    func signIn(email: String, password: String) async throws -> AuthDataResultModel {
        let authDataResult = try await Auth.auth().signIn(withEmail: email, password: password)
        DispatchQueue.main.async {
            self.currentUser = Auth.auth().currentUser
        }
        return AuthDataResultModel(user: authDataResult.user)
    }
    
    func signOut() throws {
        try Auth.auth().signOut()
        currentUser = nil
    }
    
    func resetPassword() async throws {
        let user = Auth.auth().currentUser
        let email = user?.email ?? ""
        try await Auth.auth().sendPasswordReset(withEmail: email)
    }
}
