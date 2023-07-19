//
//  AppErrors.swift
//  MangaMania
//
//  Created by Rohan Bimal Raj on 18/07/23.
//

import Foundation

enum AppErrors: Error {
    
    // throws when entered password or
    case incorrectPasswordOrEmail
}

extension AppErrors: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .incorrectPasswordOrEmail:
            return NSLocalizedString("Either email or passowrd entered is incorrect", comment: "Incorrect email or password")
        }
    }
}
