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
        NavigationStack(path: $appRouter.path) {
            appRouter.build(page: authenticationManager.isUserLoggedIn ? .settings : .login)
                .navigationDestination(for: Page.self) { page in
                    appRouter.build(page: page)
                }
                .fullScreenCover(item: $appRouter.fullScrrenCover) { fullScreenCover in
                    appRouter.build(fullScreenCover: fullScreenCover)
                }
                .animation(.default, value: authenticationManager.isUserLoggedIn)
        }
        .environmentObject(appRouter)
        .environmentObject(authenticationManager)
    }
}

struct AppRouterView_Previews: PreviewProvider {
    static var previews: some View {
        AppRouterView()
    }
}
