//
//  ContentView.swift
//  MangaMania
//
//  Created by Rohan Bimal Raj on 12/07/23.
//

import SwiftUI

struct ContentView: View {
    
    @State private var email = ""
    @State private var passowrd = ""
    @State private var showSignInView = false
    
    var body: some View {
        ZStack {
            SettingsView(showSignInView: $showSignInView)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .onAppear{
            let authUser = try? AuthenticationManager.shared.getAuthenticatedUser()
            showSignInView = authUser == nil
        }
        .fullScreenCover(isPresented: $showSignInView) {
            SignInView()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
