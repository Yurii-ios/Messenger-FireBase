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
    
    private var activeChatsRef: CollectionReference {
        return db.collection(["users", currentUser.id, "activeChats"].joined(separator: "/"))
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
            self.deleteMessages(chat: chat, completion: completion)
        }
    }
    
    func deleteMessages(chat: MChat, completion: @escaping(Result<Void, Error>) -> Void) {
        let ref = waitingChatsRef.document(chat.friendId).collection("messages")
        
        getWaitingChatMessanges(chat: chat) { (result) in
            switch result {
            case .success(let messages):
                for message in messages {
                    guard let documentId = message.id else { return }
                    let messageRef = ref.document(documentId)
                    messageRef.delete { (error) in
                        if let error = error {
                            completion(.failure(error))
                            return
                        }
                        completion(.success(Void()))
                    }
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func getWaitingChatMessanges(chat: MChat, completion: @escaping(Result<[MMessage], Error>) -> Void) {
        let ref = waitingChatsRef.document(chat.friendId).collection("messages")
        var messages = [MMessage]()
        // poly4aem wse documentupo ssulke, dannue s4ituwajutsia tolko odin raz w otli4ii ot listenara
        ref.getDocuments { (querySnapshot, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            for document in querySnapshot!.documents {
                guard let message = MMessage(document: document) else { return }
                messages.append(message)
            }
            completion(.success(messages))
        }
    }
    
    // izmeniaet(perenosit) waitingChat na activeChat
    func changeToActive(chat: MChat, completion: @escaping(Result<Void, Error>) -> Void) {
        /* dlia sozdanija actiwnogo chata nyžno:
         1. neobchodima wsia inform po wsemy 4aty
         2. wsia inform po soobs4enijam w danom 4ate
         */
        
        getWaitingChatMessanges(chat: chat) { (result) in
            // poly4aem wsy inform iz ožudajys4ego 4ata
            switch result {
            case .success(let messages):
                // esli ydalos poly4it wsy infrm - ydaliaem ožudajys4ij chat
                self.deleteWaitingChat(chat: chat) { (result) in
                    switch result {
                    case .success():
                        // posle yspeshnogo ydalenija sozdaem actiwnuj 4at
                        self.craateActiveChat(chat: chat, messages: messages) { (result) in
                            switch result {
                            case .success():
                                completion(.success(Void()))
                            case .failure(let error):
                                completion(.failure(error))
                            }
                        }
                    case .failure(let error):
                        completion(.failure(error))
                    }
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func craateActiveChat(chat: MChat, messages: [MMessage], completion: @escaping(Result<Void, Error>) -> Void) {
        let messageRef = activeChatsRef.document(chat.friendId).collection("messages")
        // sozdaem nowyjy ssulky na aktivnuj 4at danomy polzowately i dobawliaem k nemy 4at i soobs4enija
        activeChatsRef.document(chat.friendId).setData(chat.representation) { (error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            // dobawliaem soobs4enija w 4at
            for message in messages {
                messageRef.addDocument(data: message.representation) { (error) in
                    if let error = error {
                        completion(.failure(error))
                        return
                    }
                    completion(.success(Void()))
                }
            }
            
        }
    }
    
    // otprawliaet nabranue soobs4enija na ekrane ChatsViewController w firebase
    func sendMessage(chat: MChat, message: MMessage, completion: @escaping(Result<Void, Error>) -> Void) {
        /*
        - delaem ref:
        - na currentUser,
        - na togo s kem obs4aemsia,
        - na activeChats
         */
        // doberaemsia do aktiwnoga 4ata polzowatelia s ego drygom
        let friendRef = usersRef.document(chat.friendId).collection("activeChats").document(currentUser.id)
        
        // soobs4enija w actiwnom 4ate y dryga
        let friendMessageRef = friendRef.collection("messages")
        // ref na soobs4enija polzowatelia
        let myMessageRef = usersRef.document(currentUser.id).collection("activeChats").document(chat.friendId).collection("messages")
        
        let chatForFriend = MChat(friendUsername: currentUser.username,
                                  friendAvatarStringURL: currentUser.avatarStringURL,
                                  lastMessageContent: message.content,
                                  friendId: currentUser.id)
        // dobawliaem w sozdanue ssulki nyžnyjy nam informacujy
        friendRef.setData(chatForFriend.representation) { (error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            friendMessageRef.addDocument(data: message.representation) { (error) in
                if let error = error {
                    completion(.failure(error))
                    return
                }
                myMessageRef.addDocument(data: message.representation) { (error) in
                    if let error = error {
                        completion(.failure(error))
                        return
                    }
                    completion(.success(Void()))
                }
            }
        }
    }
}
