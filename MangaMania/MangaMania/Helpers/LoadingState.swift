//
//  LoadingState.swift
//  MangaMania
//
//  Created by Rohan Bimal Raj on 18/08/23.
//

import Foundation

enum LoadingState: Comparable {
    
    case idle
    case loading
    case error(String)
}
