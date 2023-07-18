//
//  SettingsView.swift
//  MangaMania
//
//  Created by Rohan Bimal Raj on 16/07/23.
//

import SwiftUI

struct SettingsView: View {
    
    @StateObject private var viewModel = SettingsViewModel()
    @Binding var showSignInView: Bool
    
    var body: some View {
        VStack {
            Button {
                
                do {
                    try viewModel.signOut()
                    showSignInView = true
                    
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
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView(showSignInView: .constant(false))
    }
}
