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
    @StateObject private var vm = ViewModel()
    
    var columns: [GridItem] = [
        GridItem(.adaptive(minimum: 150))
    ]
    
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [.themeTwo, .themeOne]), startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()
            
            if vm.myMangas.isEmpty {
                Text("You have not added any manga to library yet!!!")
                    .foregroundColor(.themeFour)
                    .font(.custom(.bold, size: 17))
                    .padding(.bottom, 90)
                
            }else {
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
                .padding(.top, 1)
                .clipped()
            }
            
        }
        .navigationTitle("My Manga")
        .onAppear(perform: vm.getMyMangas)
        .preferredColorScheme(.dark)
    }
}

struct MyMangasView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            MyMangasView()
        }
    }
}
