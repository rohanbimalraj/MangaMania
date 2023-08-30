//
//  AppRouterView.swift
//  MangaMania
//
//  Created by Rohan Bimal Raj on 20/07/23.
//

import SwiftUI

struct AppRouterView: View {
    
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
                vm.checkForUpdate()
            }
        }
        .animation(.easeInOut(duration: 0.5), value: vm.showSplash)
        .alert("Update Available", isPresented: $vm.showUpdateAlert) {
            Button {
                UIApplication.shared.openAppStore()
                
            }label: {
                Text("Update")
            }
        }message: {
            Text("A new version of Manga Mania is available. Please update to latest version now.")
        }
    }
}

struct AppRouterView_Previews: PreviewProvider {
    static var previews: some View {
        AppRouterView()
    }
}
