//
//  SettingsView.swift
//  MangaMania
//
//  Created by Rohan Bimal Raj on 21/07/23.
//

import SwiftUI

struct SettingsView: View {
    
    @StateObject private var viewModel = SettingsViewModel()
    @EnvironmentObject private var authenticationManager: AuthenticationManager
    @EnvironmentObject private var appRouter: AppRouter
    
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [.themeTwo, .themeOne]), startPoint: .top, endPoint: .bottom)
            
            Button {
                do {
                    try viewModel.signOut()
                    appRouter.popToRoot()
                }catch {
                    print("ERROR:", error.localizedDescription)
                }
            }label: {
                Text("Log out")
                    .font(.custom(.bold, size: 20))
                    .foregroundColor(.themeFour)
                    .padding(30)
                    .background(
                        LinearGradient(gradient: Gradient(colors: [.themeTwo, .themeThree]), startPoint: .topLeading, endPoint: .bottomTrailing))
                    .clipShape(Capsule())
            }
        }
        .ignoresSafeArea()
        .onAppear{
            viewModel.authenticationManager = authenticationManager
        }
        .navigationBarBackButtonHidden()
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
            .environmentObject(AuthenticationManager())
    }
}
