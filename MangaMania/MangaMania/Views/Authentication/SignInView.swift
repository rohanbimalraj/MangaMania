//
//  SignInView.swift
//  MangaMania
//
//  Created by Rohan Bimal Raj on 16/07/23.
//

import SwiftUI

struct SignInView: View {
        
    @StateObject private var viewModel = SignInViewModel()
    
    @State private var showPassword = false
    @FocusState private var isFocused: Field?
    
    enum Field: Hashable {
        case secure, plain
    }
    
    var body: some View {
        Form {
            Section {
                TextField("Enter Email", text: $viewModel.email)
                    .keyboardType(.emailAddress)
                    .textInputAutocapitalization(.never)
                if showPassword {
                    TextField("Enter Password", text: $viewModel.password)
                        .focused($isFocused, equals: .plain)
                        .autocorrectionDisabled()
                        .textInputAutocapitalization(.none)
                        .overlay(alignment: .trailing) {
                            Button {
                                isFocused = .secure
                                showPassword = false
                            }label: {
                                 Image(systemName: "eye.slash")
                            }
                        }
                }else {
                    SecureField("Enter Password", text: $viewModel.password)
                        .focused($isFocused, equals: .secure)
                        .overlay(alignment: .trailing) {
                            Button {
                                isFocused = .plain
                                showPassword = true

                            }label: {
                                 Image(systemName: "eye")
                            }
                        }
                }
            }
            
            Section {
                Button {
                    viewModel.signIn()
                }label: {
                    Text("Sign In")
                }
            }
        }
        .navigationTitle("Sign In")
    }
}

struct SignInView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            SignInView()
        }
    }
}
