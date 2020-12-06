//
//  AuthService.swift
//  Messenger + FireBase
//
//  Created by Yurii Sameliuk on 30/11/2020.
//

import UIKit
import FirebaseAuth
import GoogleSignIn

class AuthService {
    
    static let shared = AuthService()
    private let auth = Auth.auth()
    
    func login(email: String?, password: String?, completion: @escaping (Result<User, Error>) -> Void) {
        guard let email = email, let password = password else {
            completion(.failure(AuthError.notField))
            return
        }
        
        auth.signIn(withEmail: email, password: password) { (result, error) in
            guard let result = result else {
                completion(.failure(error!))
                return
            }
            completion(.success(result.user))
        }
    }
    
    // registers with google button
    func googleLogin(user: GIDGoogleUser, error: Error!, completion: @escaping(Result<User, Error>) -> Void) {
        if let error = error {
            completion(.failure(error))
        } else {
            // est li auth y uzera
            guard let auth = user.authentication else { return }
            // poly4aem y4etnue dannue
            let credential = GoogleAuthProvider.credential(withIDToken: auth.idToken, accessToken: auth.accessToken)
            
            Auth.auth().signIn(with: credential) { (result, error) in
                if let error = error {
                    completion(.failure(error))
                } else {
                    guard let result = result else {
                        completion(.failure(error!))
                        return
                    }
                    completion(.success(result.user))
                }
            }
        }
    }
    
    func register(email: String?, password: String?, confirmPassword: String?, completion: @escaping (Result<User, Error>) -> Void) {
        guard Validators.isFilled(email: email, password: password, confirmPassword: confirmPassword) else {
            completion(.failure(AuthError.notField))
            return
        }
        
        guard password!.lowercased() == confirmPassword!.lowercased() else {
            completion(.failure(AuthError.passwordNotMatched))
            return
        }
        
        guard Validators.isSimpleEmail(email!) else {
            completion(.failure(AuthError.invalidEmail))
            return
        }
        
        auth.createUser(withEmail: email!, password: password!) { (result, error) in
            guard let result = result else {
                completion(.failure(error!))
                return
            }
            completion(.success(result.user))
        }
    }
}
