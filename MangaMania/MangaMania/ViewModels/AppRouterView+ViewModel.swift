//
//  AppRouterView+ViewModel.swift
//  MangaMania
//
//  Created by Rohan Bimal Raj on 28/08/23.
//

import SwiftUI

extension AppRouterView {
    
    @MainActor class ViewModel: ObservableObject {
        
        @Published var showSplash = true
        @Published var showUpdateAlert = false
        
    }
}
