//
//  SearchBarView.swift
//  MangaMania
//
//  Created by Rohan Bimal Raj on 15/08/23.
//

import SwiftUI

struct SearchBarView: View {
    @Binding var searchText: String
    var body: some View {
        HStack {
          Image(systemName: "magnifyingglass")
                .foregroundColor(searchText.isEmpty ? .themeThree : .themeFour)
                .font(.body)
            TextField("Search Text", text: $searchText, prompt:
                        Text("Search by name...")
                .foregroundColor(.themeThree)
                .font(.custom(.semiBold, size: 15))
            )
            .autocorrectionDisabled()
            .foregroundColor(.themeFour)
            .font(.custom(.regular, size: 15))
            .keyboardType(.alphabet)
            .overlay(alignment: .trailing) {
                Image(systemName: "xmark.circle.fill")
                    .foregroundColor(.themeFour)
                    .padding()
                    .offset(x: 10)
                    .opacity(searchText.isEmpty ? 0.0 : 1.0)
                    .onTapGesture {
                        UIApplication.shared.endEditing()
                        searchText = ""
                    }
            }
        }
        .padding(15)
        .background(
            RoundedRectangle(cornerRadius: 25)
                .fill(.themeTwo)
                .shadow(color: .black.opacity(0.15), radius: 10)
        )
        .padding()
        .clipped()

    }
}

struct SearchBarView_Previews: PreviewProvider {
    static var previews: some View {
        SearchBarView(searchText: .constant(""))
            .previewLayout(.sizeThatFits)
    }
}
