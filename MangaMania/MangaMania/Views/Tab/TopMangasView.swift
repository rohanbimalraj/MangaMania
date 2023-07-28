//
//  TopMangasView.swift
//  MangaMania
//
//  Created by Rohan Bimal Raj on 23/07/23.
//

import SwiftUI

struct TopMangasView: View {
    
    @EnvironmentObject private var mangaManager: MangaManager
    @State private var topMangas: [TopManga] = []
    
    var columns: [GridItem] {
        [
            GridItem(.adaptive(minimum: 150))
        ]
    }
        
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [.themeTwo, .themeOne]), startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()
            
            ScrollView {
                
                HStack {
                    Text("Top Mangas")
                        .foregroundColor(.themeFour)
                        .font(.custom(.black, size: 40))
                        .minimumScaleFactor(0.5)
                        .padding(.leading, 20)
                    Spacer()
                }
                
                LazyVGrid(columns: columns) {
                    ForEach(topMangas) { manga in
                        
                        Button {
                            
                        }label: {
                            VStack {
                                AsyncImage(url: URL(string: manga.coverUrl ?? "")) { image in
                                    image
                                        .resizable()
                                        .scaledToFill()
                                } placeholder: {
                                    ProgressView()
                                }

                            }
                            .frame(height: 250)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            .padding(.horizontal)
                            .padding(.vertical, 5)
                            .clipped()
                        }
                    }
                }
            }
        }
        .onAppear {
            Task {
                do {
                    
                    topMangas = try await mangaManager.getTopMangas()
                    
                }catch {
                    print(error)
                }
            }
        }
    }
}

struct TopMangasView_Previews: PreviewProvider {
    static var previews: some View {
        TopMangasView()
            .environmentObject(MangaManager())
    }
}
