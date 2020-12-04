//
//  FirestoreService.swift
//  Messenger + FireBase
//
//  Created by Yurii Sameliuk on 03/12/2020.
//

import Firebase
import FirebaseFirestore

class FirestoreService {
    static let shared = FirestoreService()
    
    let db = Firestore.firestore()
    
    private var usersRef: CollectionReference {
        return db.collection("users")
    }
    
    func saveProfileWith(id: String, email: String, username: String?, avatarImageString: String?, description: String?, sex: String?, completion: @escaping (Result<MUser, Error>) -> Void) {
        guard Validators.isFilled(username: username, description: description, sex: sex) else { completion(.failure(UserError.notField))
            return
        }
        let muser = MUser(username: username!,
                          email: email,
                          avatarStringURL: "not exist",
                          description: description!,
                          sex: sex!,
                          id: id)
        
        self.usersRef.document(muser.id).setData(muser.representation) { (error) in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(muser))
            }
        }
    }
}
