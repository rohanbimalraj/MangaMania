//
//  UIApplication+Extension.swift
//  MangaMania
//
//  Created by Rohan Bimal Raj on 15/08/23.
//

import SwiftUI

extension UIApplication {
    
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
