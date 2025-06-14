//
//  MangaChapterView.swift
//  MangaMania
//
//  Created by Rohan Bimal Raj on 13/08/23.
//
import Kingfisher
import StoreKit
import SwiftUI

struct MangaChapterView: View {

    @EnvironmentObject private var topMangasRouter: TopMangasRouter
    @EnvironmentObject private var searchMangaRouter: SearchMangaRouter
    @EnvironmentObject private var myMangaMangaRouter: MyMangasRouter
    
    @Environment(\.isTabBarVisible) private var isTabBarVisible
    @Environment(\.requestReview) private var requestReview

    @State private var pageUrls: [String] = []
    
    @StateObject private var vm = ViewModel()
    
    let chapterlUrl: String
    let tab: Tab
    
    var body: some View {
        
        ZStack {
            
            ScrollView {
                LazyVStack(spacing: 0) {
                    ForEach(pageUrls.indices, id: \.self) { index in
                        KFImage(URL(string: pageUrls[index]))
                            .requestModifier(MangaManager.shared.kfRequestModifier)
                            .resizable()
                            .placeholder({ _ in ProgressView() })
                            .scaledToFill()
                            .pinchToZoom()
                            .onAppear {
                                if index == pageUrls.count - 1 {
                                    vm.handleScrollToBottom()
                                }
                            }
                    }
                }
            }
            .clipped()
            .onAppear{
                Task {
                    pageUrls = try await MangaManager.shared.getMangaChapterPages(from: chapterlUrl)
                }
                vm.evaluateReviewEligibility()
            }
            .onChange(of: vm.isReviewRequested) { newValue in
                if newValue {
                    requestReview()
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden()
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        switch tab {
                        case .topMangas:
                            topMangasRouter.router.pop()
                            
                        case .searchMangas:
                            searchMangaRouter.router.pop()
                        case .myMangas:
                            myMangaMangaRouter.router.pop()
                            
                        }
                    }label: {
                        Image(systemName: "arrowshape.left.fill")
                            .foregroundColor(.themeThree)
                    }
                }
            }
            .preferredColorScheme(.dark)
        }
        .background(.black)
    }
}

struct MangaChapterView_Previews: PreviewProvider {
    static var previews: some View {
        MangaChapterView(chapterlUrl: "", tab: .topMangas)
    }
}
