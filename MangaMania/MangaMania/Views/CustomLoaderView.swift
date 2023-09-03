//
//  CustomLoaderView.swift
//  MangaMania
//
//  Created by Rohan Bimal Raj on 28/08/23.
//

import SwiftUI

struct CustomLoaderView: View {
    
    var bottomPadding: CGFloat
    var body: some View {
        LottieView()
            .frame(width: 200, height: 200)
            .padding(.bottom, bottomPadding)
            .overlay(alignment: .bottom) {
                Text("Loading...")
                    .font(.custom(.black, size: 16))
                    .foregroundColor(.themeFour)
                    .padding(.bottom, 10 + bottomPadding)
            }
    }
    
    init(bottomPadding: CGFloat = 90) {
        self.bottomPadding = bottomPadding
    }
}

struct CustomLoaderView_Previews: PreviewProvider {
    static var previews: some View {
        CustomLoaderView()
            .previewLayout(.sizeThatFits)
    }
}
