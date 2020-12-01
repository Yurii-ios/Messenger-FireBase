//
//  AuthError.swift
//  Messenger + FireBase
//
//  Created by Yurii Sameliuk on 01/12/2020.
//

import UIKit

enum AuthError {
    case notField
    case invalidEmail
    case passwordNotMatched
    case unknownError
    case serverError
}

extension AuthError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .notField:
            return NSLocalizedString("Field is empty", comment: "")
        case .invalidEmail:
            return NSLocalizedString("Wrong email format", comment: "")
        case .passwordNotMatched:
            return NSLocalizedString("wrong password", comment: "")
        case .unknownError:
            return NSLocalizedString("Unknown error", comment: "")
        case .serverError:
            return NSLocalizedString("Server error", comment: "")
        }
    }
}
