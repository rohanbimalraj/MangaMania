//
//  View+Extension.swift
//  MangaMania
//
//  Created by Rohan Bimal Raj on 01/11/23.
//

import Shimmer
import SwiftUI

extension View {
    @ViewBuilder
    func redacted(if condition: @autoclosure () -> Bool) -> some View {
        if condition() {
            self
                .redacted(reason: condition() ? .placeholder : [])
                .shimmering(gradient: Gradient(colors: [.gray, .gray.opacity(0.5), .gray]))
        }else {
            self.redacted(reason: [])
        }
    }
    
    @ViewBuilder
    func ifLet<T, Content: View>(
        _ value: T?,
        transform: (Self, T) -> Content
    ) -> some View {
        if let value = value {
            transform(self, value)
        } else {
            self
        }
    }
}
