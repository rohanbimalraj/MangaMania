//
//  MyMangasView.swift
//  MangaMania
//
//  Created by Rohan Bimal Raj on 23/07/23.
//
import Kingfisher
import SwiftUI

struct MyMangasView: View {
    
    @EnvironmentObject private var myMangasRouter: MyMangasRouter
    @StateObject private var vm = MyMangaViewModel()
    
    var columns: [GridItem] = [
        GridItem(.adaptive(minimum: 150))
    ]
    
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [.themeTwo, .themeOne]), startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()
            
            ScrollView {
                LazyVGrid(columns: columns, spacing: 10) {
                    ForEach(vm.myMangas) { manga in
                        
                        Button {
                            
                            myMangasRouter.router.push(.mangaDetail(url: manga.detailUrl ?? "", from: .myMangas))
                            
                        }label: {
                            KFImage(URL(string: manga.coverUrl ?? ""))
                                .resizable()
                                .fade(duration: 0.5)
                                .placeholder({
                                    Image("book-cover-placeholder")
                                        .resizable()
                                })
                                .overlay {
                                    LinearGradient(gradient: Gradient(colors: [.black, .clear]), startPoint: .bottom, endPoint: .top)
                                    VStack {
                                        Spacer()
                                        Text(manga.title ?? "")
                                            .foregroundColor(.themeFour)
                                            .font(.custom(.medium, size: 17))
                                            .padding([.horizontal, .bottom])
                                    }
                                }
                                .frame(height: 250)
                                .cornerRadius(10)
                                .padding(.horizontal, 20)
                                .padding(.top, 20)
                            
                        }
                    }
                }
            }
            .scrollBounceBehavior(.basedOnSize)
            .padding(.bottom, 90)
            .clipped()
        }
        .navigationTitle("My Mangas")
        .onAppear(perform: vm.getMyMangas)
    }
}

struct MyMangasView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            MyMangasView()
        }
    }
}
