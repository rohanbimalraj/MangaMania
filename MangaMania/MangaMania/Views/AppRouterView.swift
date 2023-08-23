//
//  AppRouterView.swift
//  MangaMania
//
//  Created by Rohan Bimal Raj on 20/07/23.
//

import SwiftUI

struct AppRouterView: View {
    
    @StateObject private var appRouter = AppRouter()
    @StateObject private var authenticationManager = AuthenticationManager()
    
    var body: some View {
        ZStack {
            if authenticationManager.isUserLoggedIn {
                
                ContentView()
                .transition(.slide)
                .environmentObject(appRouter)
                .environmentObject(authenticationManager)
                
            }else {
                NavigationStack(path: $appRouter.path) {
                    appRouter.build(page: .login)
                        .navigationDestination(for: Page.self) { page in
                            appRouter.build(page: page)
                        }
                        .fullScreenCover(item: $appRouter.fullScrrenCover) { fullScreenCover in
                            appRouter.build(fullScreenCover: fullScreenCover)
                        }
                        .environmentObject(appRouter)
                        .environmentObject(authenticationManager)
                }
                .transition(.slide)

            }
        }
        .animation(.easeInOut, value: authenticationManager.isUserLoggedIn)
    }
}

struct AppRouterView_Previews: PreviewProvider {
    static var previews: some View {
        AppRouterView()
    }
}
