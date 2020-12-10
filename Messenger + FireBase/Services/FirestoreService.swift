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
    
    private var waitingChatsRef: CollectionReference {
        return db.collection(["users", currentUser.id, "waitingChats"].joined(separator: "/"))
    }
    
    var currentUser: MUser!
    
    // proweriaem poly4ena li wsia informacuja ot juzera( zapolnen ego profil). eta fync srab kak tolko mu zapysk prilož
    func getUserData(user: User, completion: @escaping (Result<MUser, Error>) -> Void) {
        // poly4aem dostyp do informacii o user
        let docRef = usersRef.document(user.uid)
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                guard let muser = MUser(document: document) else {
                    completion(.failure(UserError.cannotUnwrapToMUser))
                    return
                }
                //poly4aem tekys4ego otprawitelia soobs4enija w func createWaitingChat
                self.currentUser = muser
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
    
    // otprawliaet soobs4enie polzowateliam pri nažatii na knopky send w ProfileVC
    func createWaitingChat(message: String, receiver: MUser, completion: @escaping(Result<Void, Error>) -> Void) {
        // sozdaem y usera kolekcujy w firebase gde bydyt chranitsia wse ego perepiski
        // razmes4aem kolekcujy waitingChat w firebase. (chranit ssulky na konkretnogo usera s waiting chats)
        let reference = db.collection(["users", receiver.id, "waitingChats"].joined(separator: "/"))
        // delaem ref na soobs4enija
        let messageRef = reference.document(self.currentUser.id).collection("messages")
        
        // sozdaem obekta soobs4enij
        let message = MMessage(user: currentUser, content: message)
        
        let chat = MChat(friendUsername: currentUser.username,
                         friendAvatarStringURL: currentUser.avatarStringURL,
                         lastMessageContent: message.content,
                         friendId: currentUser.id)
        // dobawliaem nowuj dokyment(chat) s waiting chatom, w ka4estwe nazwanija ispolzyem indefikator usera
        reference.document(currentUser.id).setData(chat.representation) { (error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            // dobawliaem nowuj dokyment
            messageRef.addDocument(data: message.representation) { (error) in
                if let error = error {
                    completion(.failure(error))
                    return
                }
                completion(.success(Void()))
            }
        }
    }
    
    // ydaliaet polnostjy 4at
    func deleteWaitingChat(chat: MChat, completion: @escaping(Result<Void, Error>) -> Void) {
        // dostaem toj 4at kotoruj chotim ydalit
        waitingChatsRef.document(chat.friendId).delete { (error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            completion(.success(Void()))
        }
    }
}
