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
    // ref na kolekcujy w kotoroj chranitsia users
    private var usersRef: CollectionReference {
        return db.collection("users")
    }
    // proweriaem poly4ena li wsia informacuja ot juzera( zapolnen ego profil).
    func getUserData(user: User, completion: @escaping (Result<MUser, Error>) -> Void) {
        // poly4aem dostyp do informacii o user
        let docRef = usersRef.document(user.uid)
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                guard let muser = MUser(document: document) else {
                    completion(.failure(UserError.cannotUnwrapToMUser))
                    return
                }
                completion(.success(muser))
            } else {
                completion(.failure(UserError.cannotGetUserInfo))
            }
        }
    }
    // zagružaem inform o polzowatele w firestore
    func saveProfileWith(id: String, email: String, username: String?, avatarImage: UIImage?, description: String?, sex: String?, completion: @escaping (Result<MUser, Error>) -> Void) {
        guard Validators.isFilled(username: username, description: description, sex: sex) else { completion(.failure(UserError.notField))
            return
        }
        
        guard avatarImage != #imageLiteral(resourceName: "avatar")  else {
            completion(.failure(UserError.photoNotExist))
            return
        }
        var muser = MUser(username: username!,
                          email: email,
                          avatarStringURL: "not exist",
                          description: description!,
                          sex: sex!,
                          id: id)
     // !! w etom sly4ae wsia informacija bydet sochranena kogda user dobavit fofo !!!
        // zagryžaem poly4enue ižobraženija
        StorageService.shared.uploadImage(photo: avatarImage!) { (result) in
            switch result {
            case .success(let url):
                muser.avatarStringURL = url.absoluteString
                //sozdaem nowyj dokyment wnytri kolekcijy s dannumi user w hyżnom formate
                self.usersRef.document(muser.id).setData(muser.representation) { (error) in
                    if let error = error {
                        completion(.failure(error))
                    } else {
                        completion(.success(muser))
                    }
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }// storageService
    }
}
