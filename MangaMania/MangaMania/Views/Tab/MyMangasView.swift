//
//  MyMangasView.swift
//  MangaMania
//
//  Created by Rohan Bimal Raj on 23/07/23.
//

import SwiftUI

struct MyMangasView: View {
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [.themeTwo, .themeOne]), startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()
        }
        .navigationTitle("My Mangas")
    }
}

struct MyMangasView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            MyMangasView()
        }
    }
}
