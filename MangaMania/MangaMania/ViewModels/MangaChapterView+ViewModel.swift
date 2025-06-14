//
//  MangaChapterView+ViewModel.swift
//  MangaMania
//
//  Created by Rohan Bimal Raj on 14/06/25.
//
import Foundation
import SwiftUI

extension MangaChapterView {
    
    @MainActor
    class ViewModel: ObservableObject {
        
        @Published var isReviewRequested: Bool = false
        
        @AppStorage("scrollToBottomCount") private var scrollToBottomCount: Int = 0
        @AppStorage("lastReviewPromptVersion") private var lastReviewPromptVersion: String = ""
        @AppStorage("lastReviewPromptDate") private var lastReviewPromptDate: Double = 0
        @AppStorage("canCountScrolls") private var canCountScrolls: Bool = true
        
        func handleScrollToBottom() {
            guard canCountScrolls else { return }

            scrollToBottomCount += 1
            print("📈 Scroll to bottom count: \(scrollToBottomCount)")

            if scrollToBottomCount == 3 {
                isReviewRequested = true

                // Record prompt data
                lastReviewPromptDate = Date().timeIntervalSince1970
                lastReviewPromptVersion = Bundle.appVersionBundle

                // Reset everything after review
                scrollToBottomCount = 0
                canCountScrolls = false
            }
        }
        
        func evaluateReviewEligibility() {
            // This runs onAppear and allows scroll counting if enough time/version has passed
            if shouldPromptForReview() {
                canCountScrolls = true
            }
        }
        
        private func shouldPromptForReview() -> Bool {
            let sixMonths: Double = 60 * 60 * 24 * 30 * 6
            let now = Date().timeIntervalSince1970
            let hasBeenSixMonths = now - lastReviewPromptDate >= sixMonths
            let isNewVersion = lastReviewPromptVersion != Bundle.appVersionBundle

            return hasBeenSixMonths || isNewVersion
        }
    }
}
