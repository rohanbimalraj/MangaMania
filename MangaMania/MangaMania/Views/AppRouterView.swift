//
//  AppRouterView.swift
//  MangaMania
//
//  Created by Rohan Bimal Raj on 20/07/23.
//

import SwiftUI

struct AppRouterView: View {
    
    //@StateObject private var appRouter = AppRouter()
    //@StateObject private var authenticationManager = AuthenticationManager()
    @StateObject private var vm = ViewModel()
    
    var body: some View {
        ZStack {
            if vm.showSplash {
                SplashScreenView()
                
            }else {
                ContentView()
                    .transition(.opacity)
            }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                vm.showSplash = false
            }
        }
        .animation(.easeInOut(duration: 0.5), value: vm.showSplash)
    }
}

struct AppRouterView_Previews: PreviewProvider {
    static var previews: some View {
        AppRouterView()
    }
}
