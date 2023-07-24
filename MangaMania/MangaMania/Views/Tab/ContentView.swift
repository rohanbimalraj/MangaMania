//
//  ContentView.swift
//  MangaMania
//
//  Created by Rohan Bimal Raj on 23/07/23.
//

import SwiftUI

struct ContentView: View {
    
    @State private var selectedTab: Tab = .topMangas
    
    init() {
        UITabBar.appearance().isHidden = true
    }
    
    var body: some View {
        ZStack {
            
            LinearGradient(gradient: Gradient(colors: [.themeTwo, .themeOne]), startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()
            
            VStack {
                TabView(selection: $selectedTab) {
                    
                    TopMangasView()
                        .tag(Tab.topMangas)
                    
                    MyMangasView()
                        .tag(Tab.myMangas)
                    
                    MangaSearchView()
                        .tag(Tab.searchMangas)
                    
                    SettingsView()
                        .tag(Tab.settings)
                }
            }
            
            VStack {
                Spacer()
                TabBarView(selectedTab: $selectedTab)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
