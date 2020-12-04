//
//  UserError.swift
//  Messenger + FireBase
//
//  Created by Yurii Sameliuk on 03/12/2020.
//

import Foundation

enum UserError {
    case notField
    case photoNotExist
}

extension UserError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .notField:
            return NSLocalizedString("Field is empty", comment: "")
        case .photoNotExist:
            return NSLocalizedString("No photo", comment: "")
        
        }
    }
}
