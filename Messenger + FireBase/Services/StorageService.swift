//
//  StorageService.swift
//  Messenger + FireBase
//
//  Created by Yurii Sameliuk on 06/12/2020.
//

import UIKit
import FirebaseAuth
import FirebaseStorage

class StorageService {
    static let shared = StorageService()
    
    // sozdaem ssulky
    let storegRef = Storage.storage().reference()
    
    // delaem ssulky na papky s avatarkami polzowatelej
    private var avatarsRef: StorageReference {
        return storegRef.child("avatars")
    }
    
    private var currentUserId: String {
        return Auth.auth().currentUser!.uid
    }
    
    func uploadImage(photo: UIImage, completion: @escaping(Result<URL, Error>) -> Void) {
        guard let scaledImage = photo.scaledToSafeUploadSize, let imageData = scaledImage.jpegData(compressionQuality: 0.4) else { return }
        
        // zagružaem izobrazenija wnytr firebase storage
        
        // dostaem ssulky na izobraž
        
        // dobawliaem nowuj dokyment s id usera
        
        // y id usera dobawliaem nowyjy kartinky ego awy
        
        let metaData = StorageMetadata()
        metaData.contentType = "image/jpeg"
        
        avatarsRef.child(currentUserId).putData(imageData, metadata: metaData) { (metadata, error) in
            guard let _ = metadata else {
                completion(.failure(error!))
                return
            }
            // dostaem ssulky na izobraž
            self.avatarsRef.child(self.currentUserId).downloadURL { (url, error) in
                guard let downloadURL = url else {
                    completion(.failure(error!))
                    return
                }
                completion(.success(downloadURL))
            }
        }
    }
    
    func uploadImageMessage(photo: UIImage, to chat: MChat, completion: @escaping(Result<URL, Error>) -> Void) {
        guard let scaleImage = photo.scaledToSafeUploadSize, let imageData = scaleImage.jpegData(compressionQuality: 0.4) else { return }
        
        let metaData = StorageMetadata()
        metaData.contentType = "image/jpeg"
        // sozdaem imja izobraz
        let imageName = [UUID().uuidString, String(Date().timeIntervalSince1970)].joined()
        
        let uid: String = Auth.auth().currentUser!.uid
        let chatName = [chat.friendUsername,  uid].joined()
        
        self.storegRef.child(chatName).child(imageName).putData(imageData, metadata: metaData) { (metadata, error) in
            guard let _ = metadata else {
                completion(.failure(error!))
                return
            }
            self.storegRef.child(chatName).child(imageName).downloadURL { (url, error) in
                guard let downloadURL = url  else {
                    completion(.failure(error!))
                    return
                }
                
                completion(.success(downloadURL))
            }
        }
    }
    
    func downloadImage(url: URL, completion: @escaping(Result<UIImage?, Error>) -> Void) {
        let ref = Storage.storage().reference(forURL: url.absoluteString)
        
        let megaByte = Int64(1 * 1024 * 1024)
        ref.getData(maxSize: megaByte) { (data, error) in
            guard let imageData = data else {
                completion(.failure(error!))
                return
            }
            completion(.success(UIImage(data: imageData)))
        }
    }
}
