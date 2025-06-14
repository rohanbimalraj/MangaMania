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

    @AppStorage("scrollToBottomCount") private var scrollToBottomCount: Int = 0
    @AppStorage("lastReviewPromptVersion") private var lastReviewPromptVersion: String = ""
    @AppStorage("lastReviewPromptDate") private var lastReviewPromptDate: Double = 0
    @AppStorage("canCountScrolls") private var canCountScrolls: Bool = true

    @EnvironmentObject private var topMangasRouter: TopMangasRouter
    @EnvironmentObject private var searchMangaRouter: SearchMangaRouter
    @EnvironmentObject private var myMangaMangaRouter: MyMangasRouter
    
    @Environment(\.isTabBarVisible) private var isTabBarVisible
    @Environment(\.requestReview) private var requestReview

    @State private var pageUrls: [String] = []
    
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
                                    handleScrollToBottom()
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
                evaluateReviewEligibility()
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

    private func handleScrollToBottom() {
        guard canCountScrolls else { return }

        scrollToBottomCount += 1
        print("📈 Scroll to bottom count: \(scrollToBottomCount)")

        if scrollToBottomCount == 1 {
            requestReview()

            // Record prompt data
            lastReviewPromptDate = Date().timeIntervalSince1970
            lastReviewPromptVersion = Bundle.appVersionBundle

            // Reset everything after review
            scrollToBottomCount = 0
            canCountScrolls = false
        }
    }
    
    private func shouldPromptForReview() -> Bool {
        let sixMonths: Double = 60 * 60 * 24 * 30 * 6
        let now = Date().timeIntervalSince1970
        let hasBeenSixMonths = now - lastReviewPromptDate >= sixMonths
        let isNewVersion = lastReviewPromptVersion != Bundle.appVersionBundle

        return hasBeenSixMonths || isNewVersion
    }
    
    private func evaluateReviewEligibility() {
        // This runs onAppear and allows scroll counting if enough time/version has passed
        if shouldPromptForReview() {
            canCountScrolls = true
        }
    }
}

struct MangaChapterView_Previews: PreviewProvider {
    static var previews: some View {
        MangaChapterView(chapterlUrl: "", tab: .topMangas)
    }
}
