//
//  Validators.swift
//  Messenger + FireBase
//
//  Created by Yurii Sameliuk on 01/12/2020.
//

import UIKit

class Validators {
    static func isFilled(email: String?, password: String?, confirmPassword: String?) -> Bool {
        guard let password = password, let confirmPassword = confirmPassword, let email = email, password != "", confirmPassword != "", email != ""  else {
            return false
        }
        return true
    }
    
    static func isSimpleEmail(_ email: String) -> Bool {
        let emailRegEx = "^.+@.+\\..{2,}$"
        return cheak(text: email, regEx: emailRegEx)
    }
    
    private static func cheak(text: String, regEx: String) -> Bool {
        let predicate = NSPredicate(format: "SELF MATCHES %@", regEx)
        return predicate.evaluate(with: text)
    }
}
