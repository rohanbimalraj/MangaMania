//
//  MangaDetailView.swift
//  MangaMania
//
//  Created by Rohan Bimal Raj on 07/08/23.
//

import SwiftUI

struct MangaDetailView: View {
    
    let detailUrl: String
    
    var body: some View {
        Text(detailUrl)
    }
}

struct MangaDetailView_Previews: PreviewProvider {
    static var previews: some View {
        MangaDetailView(detailUrl: "")
    }
}
