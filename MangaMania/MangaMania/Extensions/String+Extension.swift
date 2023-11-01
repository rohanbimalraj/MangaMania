//
//  String+Extension.swift
//  MangaMania
//
//  Created by Rohan Bimal Raj on 28/08/23.
//

import Foundation

extension String {
    var boolValue: Bool {
        return (self as NSString).boolValue
    }
    static func placeholder(length: Int) -> String {
        String(Array(repeating: "X", count: length))
    }
}
