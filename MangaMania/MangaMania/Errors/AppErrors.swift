//
//  AppErrors.swift
//  MangaMania
//
//  Created by Rohan Bimal Raj on 18/07/23.
//

import Foundation

enum AppErrors: Error {
    
    case incorrectPasswordOrEmail
    case internalError
    case emailEmpty
    case passwordEmpty
    case confirmPasswordEmpty
    case passwordMismatch
}

extension AppErrors: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .incorrectPasswordOrEmail:
            return NSLocalizedString("Either email or passowrd entered is incorrect.", comment: "Incorrect email or password")
            
        case .internalError:
            return NSLocalizedString("Due to unknow reason an internal error has occured.", comment: "Internal Error")
            
        case .emailEmpty:
            return NSLocalizedString("Please provide a valid email.", comment: "Missing Email")
            
        case .passwordEmpty:
            return NSLocalizedString("Please provide password.", comment: "Missing Password")
            
        case .confirmPasswordEmpty:
            return NSLocalizedString("Please provide confirm password.", comment: "Missing Confirm Password")
            
        case .passwordMismatch:
            return NSLocalizedString("Please make sure password and confirm password match", comment: "Password Mismatch")
        }
    }
}
