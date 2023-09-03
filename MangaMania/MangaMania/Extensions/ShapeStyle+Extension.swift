//
//  ShapeStyle+Extension.swift
//  MangaMania
//
//  Created by Rohan Bimal Raj on 12/07/23.
//

import SwiftUI

extension ShapeStyle where Self == Color {
    
    static var themeOne: Color {
       let color = #colorLiteral(red: 0.3960784314, green: 0.01568627451, blue: 0.01568627451, alpha: 1)
        return Color(color)
    }
    
    static var themeTwo: Color {
        let color = #colorLiteral(red: 0.7411764706, green: 0.03921568627, blue: 0.03921568627, alpha: 1)
        return Color(color)
    }
    
    static var themeThree: Color {
        let color = #colorLiteral(red: 1, green: 0.2156862745, blue: 0.2156862745, alpha: 1)
        return Color(color)
    }
    
    static var themeFour: Color {
        let color = #colorLiteral(red: 1, green: 0.8392156863, blue: 0.8392156863, alpha: 1)
        return Color(color)
    }
}
