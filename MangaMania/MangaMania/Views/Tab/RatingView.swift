//
//  RatingView.swift
//  MangaMania
//
//  Created by Rohan Bimal Raj on 11/08/23.
//

import SwiftUI

struct RatingView: View {
    
    var label = ""
    var maximumRating = 5
    
    var offImage: Image?
    var onImage = Image(systemName: "star.fill")
    
    var onColor = Color.yellow
    var offColor = Color.gray
    
    @Binding var rating: Int
    
    var body: some View {
        
        if !label.isEmpty {
            Text(label)
        }
        
        HStack {
            ForEach(1..<maximumRating + 1, id: \.self) { number in
                getImage(for: number)
                    .foregroundColor(number > rating ? offColor : onColor)
                    .onTapGesture {
                        rating = number
                    }
            }
        }
    }
    
    private func getImage(for number: Int) -> Image {
        if number > rating {
            return offImage ?? onImage
        }else {
            return onImage
        }
    }
}

struct RatingView_Previews: PreviewProvider {
    static var previews: some View {
        RatingView(rating: .constant(3))
    }
}
