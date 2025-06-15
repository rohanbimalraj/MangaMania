//
//  MangaGridItemView.swift
//  MangaMania
//
//  Created by Rohan Bimal Raj on 15/06/25.
//

// MangaGridItemView.swift

import SwiftUI
import Kingfisher

struct MangaGridItemView<ContextMenuContent: View>: View {
    let manga: Manga
    let onTap: () -> Void
    private let contextMenuContent: ContextMenuContent?

    init(
        manga: Manga,
        onTap: @escaping () -> Void,
        @ViewBuilder contextMenu: () -> ContextMenuContent
    ) {
        self.manga = manga
        self.onTap = onTap
        self.contextMenuContent = contextMenu()
    }

    init(
        manga: Manga,
        onTap: @escaping () -> Void
    ) where ContextMenuContent == EmptyView {
        self.manga = manga
        self.onTap = onTap
        self.contextMenuContent = nil
    }

    var body: some View {
        let imageView = KFImage(URL(string: manga.coverUrl ?? ""))
            .requestModifier(MangaManager.shared.kfRequestModifier)
            .resizable()
            .fade(duration: 0.5)
            .placeholder {
                Image("book-cover-placeholder")
                    .resizable()
            }
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
            .scrollTransition { content, phase in
                content
                    .opacity(phase.isIdentity ? 1 : 0)
                    .scaleEffect(phase.isIdentity ? 1 : 0.8)
                    .blur(radius: phase.isIdentity ? 0 : 3)
            }
            .ifLet(contextMenuContent) { view, menu in
                view.contextMenu {
                    menu
                }
            }

        Button(action: onTap) {
            imageView
        }
        .padding(.horizontal, 20)
        .padding(.top, 20)
    }
}
