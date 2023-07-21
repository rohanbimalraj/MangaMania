//
//  SettingsView.swift
//  MangaMania
//
//  Created by Rohan Bimal Raj on 16/07/23.
//

import SwiftUI

struct SettingsView: View {
    
    @StateObject private var viewModel = SettingsViewModel()
    @EnvironmentObject private var authenticationManager: AuthenticationManager
    @Binding var showSignInView: Bool
    @EnvironmentObject private var appRouter: AppRouter
    
    var body: some View {
        VStack {
            Button {
                
                do {
                    try viewModel.signOut()
                    appRouter.popToRoot()
                    
                }catch {
                    print(error)
                }
                
            }label: {
                Text("Sign Out")
                    .font(.custom(.bold, size: 30))
                    .foregroundColor(.themeFour)
                    .padding()
                    .background(.themeOne)
                    .cornerRadius(10)
            }
            
            Button {
                
                Task {
                    do {
                        try await viewModel.resetPassword()
                    }catch {
                        print(error)
                    }
                }
                
            }label: {
                Text("Reset Password")
                    .font(.custom(.bold, size: 30))
                    .foregroundColor(.themeFour)
                    .padding()
                    .background(.themeOne)
                    .cornerRadius(10)
            }
        }
        .navigationBarBackButtonHidden()
        .onAppear{
            viewModel.authenticationManager = authenticationManager
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView(showSignInView: .constant(false))
    }
}
