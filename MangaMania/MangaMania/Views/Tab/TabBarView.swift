//
//  TabBarView.swift
//  MangaMania
//
//  Created by Rohan Bimal Raj on 23/07/23.
//

import SwiftUI

enum Tab: String, CaseIterable {
    
    case myMangas = "bookmark"
    case topMangas = "flame"
    case searchMangas = "magnifyingglass.circle"
}

struct TabBarView: View {
    
    @Binding var selectedTab: Tab
    @State private var libraryUpdated = false
    @Namespace private var barAnimation
    private var fillImage: String {
        selectedTab.rawValue + ".fill"
    }
    private let pub = NotificationCenter.default.publisher(for: .libraryUpdated)
    
    var body: some View {
        VStack {
            HStack {
                ForEach(Tab.allCases, id: \.rawValue) { tab in
                    Spacer()
                    VStack {
                        Image(systemName: selectedTab == tab ? fillImage : tab.rawValue)
                            .scaleEffect(selectedTab == tab ? 1.25 : 1.0)
                            .offset(y: selectedTab == tab ? 3 : 6)
                            .offset(y: (tab == .myMangas && libraryUpdated) ? -50 : 0)
                            .foregroundColor(.themeFour)
                            .font(.system(size: 25))
                            .onTapGesture {
                                let generator = UISelectionFeedbackGenerator()
                                generator.selectionChanged()
                                withAnimation(.easeInOut(duration: 0.1)) {
                                    selectedTab = tab
                                }
                        }
                        
                        if selectedTab == tab {
                            Capsule()
                                .fill(.themeFour)
                                .frame(width: 60, height: 6)
                                .offset(y: 9)
                                .matchedGeometryEffect(id: "animatedBar", in: barAnimation)
                        }else {
                            Capsule()
                                .fill(.clear)
                                .frame(width: 60, height: 6)
                                .offset(y: 10)
                                
                        }

                    }
                    Spacer()
                }
            }
            .frame(width: nil, height: 60)
            .background(
                LinearGradient(gradient: Gradient(colors: [.themeTwo, .themeThree]), startPoint: .top, endPoint: .bottom)
                    .clipShape(Capsule())
            )
            .padding()
            .shadow(radius: 20)
        }
        .onReceive(pub) { _ in
            animateBookmarkButton()
        }
    }
    
    private func animateBookmarkButton() {
        withAnimation(.interpolatingSpring(stiffness: 100, damping: 100, initialVelocity: 10).repeatCount(1,autoreverses: true)) {
            libraryUpdated.toggle()

            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                withAnimation(.interpolatingSpring(stiffness: 100, damping: 5, initialVelocity: 10).repeatCount(1,autoreverses: true)) {
                    libraryUpdated.toggle()
                }
            }
        }
        
    }
}

struct TabBarView_Previews: PreviewProvider {
    static var previews: some View {
        TabBarView(selectedTab: .constant(.topMangas))
            .previewLayout(.sizeThatFits)
    }
}

struct TabBarVisibilityKey: EnvironmentKey {
    static let defaultValue: Binding<Bool> = .constant(true)
}

extension EnvironmentValues {
    var isTabBarVisible: Binding<Bool> {
        get { self[TabBarVisibilityKey.self] }
        set { self[TabBarVisibilityKey.self] = newValue }
    }
}
