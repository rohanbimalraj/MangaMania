//
//  Bundle+Extension.swift
//  MangaMania
//
//  Created by Rohan Bimal Raj on 28/08/23.
//

import Foundation

extension Bundle {
    
    static var appVersionBundle: String {
        guard
            let info = Bundle.main.infoDictionary,
            let version = info["CFBundleShortVersionString"] as? String
        else { return "" }
        return version
    }
    
    static var appBuildBundle: String {
        guard
            let info = Bundle.main.infoDictionary,
            let version = info["CFBundleVersion"] as? String
        else { return "" }
        return version
    }
}
