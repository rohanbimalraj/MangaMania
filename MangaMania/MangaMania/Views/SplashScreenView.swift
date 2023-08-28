//
//  SplashScreenView.swift
//  MangaMania
//
//  Created by Rohan Bimal Raj on 27/08/23.
//

import SwiftUI

struct SplashScreenView: View {
    
    @State private var startAnimation = false
    @State private var showLogo = false
    
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [
                .themeTwo,
                .themeOne
            ]), startPoint: startAnimation ? .topLeading : .bottomLeading, endPoint: startAnimation ? .bottomTrailing : .topTrailing
            )
            .ignoresSafeArea()
            
            if showLogo {
                Image("MangaManiaLogo")
                    .resizable()
                    .scaledToFit()
                    .padding(70)
                    .shadow(radius: 20)
                    .transition(.scale)
            }
            VStack {
                Spacer()
                Text("v\(Bundle.appVersionBundle)")
                    .foregroundColor(.themeFour)
                    .font(.custom(.black, size: 17))
            }
        }
        .animation(.easeInOut(duration: 1), value: showLogo)
        .onAppear{
            showLogo = true
            withAnimation(.linear(duration: 2.0).repeatForever()) {
                startAnimation.toggle()
            }
        }
    }
}

struct SplashScreenView_Previews: PreviewProvider {
    static var previews: some View {
        SplashScreenView()
    }
}
