//
//  Font+Extension.swift
//  MangaMania
//
//  Created by Rohan Bimal Raj on 13/07/23.
//

import SwiftUI

extension Font {
    static func custom(_ font: CustomFonts, size: CGFloat) -> SwiftUI.Font {
        SwiftUI.Font.custom(font.rawValue, fixedSize: size)
    }
}
