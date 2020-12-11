//
//  ListenerService.swift
//  Messenger + FireBase
//
//  Created by Yurii Sameliuk on 07/12/2020.
//

import FirebaseAuth
import FirebaseFirestore

class ListenerService {
    static let shared = ListenerService()
    private let dataBase = Firestore.firestore()
    
    private var usersRef: CollectionReference {
        return dataBase.collection("users")
    }
    
    private var currentUserId: String {
        return Auth.auth().currentUser!.uid
    }
    
    // func kotoraya sledit za izmenenijami wsex users w firebase
    func usersObserve(users: [MUser], completion: @escaping(Result<[MUser], Error>) -> Void) -> ListenerRegistration? {
        var users = users
        let usersListener = usersRef.addSnapshotListener { (querySnapshot, error) in
            guard let snapshot = querySnapshot else {
                completion(.failure(error!))
                return
            }
            
            snapshot.documentChanges.forEach { (diff) in
                guard let muser = MUser(document: diff.document) else { return }
                switch diff.type {
                case .added:
                    guard !users.contains(muser) else { return }
                    guard muser.id != self.currentUserId else { return }
                    users.append(muser)
                case .modified:
                    guard let index = users.firstIndex(of: muser) else { return }
                    users[index] = muser
                case .removed:
                    guard let index = users.firstIndex(of: muser) else { return }
                    users.remove(at: index)
                }
            }
            completion(.success(users))
        }
        return usersListener
    }
    // sledit za ožudajus4imi 4atatami
    func waitingChatsObserve(chats: [MChat], completion: @escaping(Result<[MChat], Error>) -> Void) -> ListenerRegistration? {
        var chats = chats
        // ssulka po kotoroj mu bydem sledit wse izmenenija
        let chatsRef = dataBase.collection(["users", currentUserId, "waitingChats"].joined(separator: "/"))
        // delaem slyshatelia
        let chatsListener = chatsRef.addSnapshotListener { (querySnapshot, error) in
            guard let snapshot = querySnapshot else {
                completion(.failure(error!))
                return
            }
            // probegaemsia po kagdomy izmenenijy
            snapshot.documentChanges.forEach { (diff) in
                // dostaem obekt tipa chat
                guard let chat = MChat(document: diff.document) else { return }
                
                switch diff.type {
                case .added:
                    guard !chats.contains(chat) else { return }
                    chats.append(chat)
                case .modified:
                    guard let index = chats.firstIndex(of: chat) else { return }
                    chats[index] = chat
                case .removed:
                    guard let index = chats.firstIndex(of: chat) else { return }
                    chats.remove(at: index)
                }
            }
            
            completion(.success(chats))
        }
        return chatsListener
    }
    
    func activeChatsObserve(chats: [MChat], completion: @escaping(Result<[MChat], Error>) -> Void) -> ListenerRegistration? {
        var chats = chats
        // ssulka po kotoroj mu bydem sledit wse izmenenija
        let chatsRef = dataBase.collection(["users", currentUserId, "activeChats"].joined(separator: "/"))
        // delaem slyshatelia
        let chatsListener = chatsRef.addSnapshotListener { (querySnapshot, error) in
            guard let snapshot = querySnapshot else {
                completion(.failure(error!))
                return
            }
            // probegaemsia po kagdomy izmenenijy
            snapshot.documentChanges.forEach { (diff) in
                // dostaem obekt tipa chat
                guard let chat = MChat(document: diff.document) else { return }
                
                switch diff.type {
                case .added:
                    guard !chats.contains(chat) else { return }
                    chats.append(chat)
                case .modified:
                    guard let index = chats.firstIndex(of: chat) else { return }
                    chats[index] = chat
                case .removed:
                    guard let index = chats.firstIndex(of: chat) else { return }
                    chats.remove(at: index)
                }
            }
            
            completion(.success(chats))
        }
        return chatsListener
    }
    
    // w completion block  wozwras4aem každuj raz tolko odno soobs4enie
    func messagesObserve(chat: MChat, completion: @escaping(Result<MMessage, Error>) -> Void) -> ListenerRegistration {
        // sozdaem ssulky na obekt za kotorum bydem sledit
        let ref = usersRef.document(currentUserId).collection("activeChats").document(chat.friendId).collection("messages")
        
        // delaem listener
        let messageListener = ref.addSnapshotListener { (querySnapshot, error) in
            guard let snapshot = querySnapshot else {
                completion(.failure(error!))
                return
            }
            snapshot.documentChanges.forEach { (diff) in
                guard let message = MMessage(document: diff.document) else { return }
                switch diff.type {
                case .added:
                    // wozwras4aem message naryžy
                    completion(.success(message))
                case .modified:
                    break
                case .removed:
                    break
                }
            }
        }
        return messageListener
    }
}
