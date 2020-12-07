//
//  MUser.swift
//  Messenger + FireBase
//
//  Created by Yurii Sameliuk on 28/11/2020.
//

import UIKit
import FirebaseFirestore

struct MUser: Hashable, Decodable {
    var username: String
    var email: String
    var avatarStringURL: String
    var description: String
    var sex: String
    var id: String
    
    init(username: String, email: String, avatarStringURL: String, description: String, sex: String, id: String) {
        self.username = username
            self.email = email
            self.avatarStringURL = avatarStringURL
            self.description = description
            self.sex = sex
        self.id = id
    }
    
    init?(document: DocumentSnapshot) {
        // poly4aem dannue
        guard let data = document.data() else { return nil }
        // proweriaem możem li mu s danoj datu poly4it obektu
        guard let username = data["username"] as? String,
              let userSex = data["sex"] as? String,
              let userEmail = data["email"] as? String,
              let userAvatarStringURL = data["avatarStringURL"] as? String,
              let userDescription = data["description"] as? String,
              let userUid = data["uid"] as? String
        else { return nil }
        self.username = username
        self.email = userEmail
        self.avatarStringURL = userAvatarStringURL
        self.description = userDescription
        self.sex = userSex
        self.id = userUid
    }
    
    init?(document: QueryDocumentSnapshot) {
        // poly4aem dannue
         let data = document.data()
        // proweriaem możem li mu s danoj datu poly4it obektu
        guard let username = data["username"] as? String,
              let userSex = data["sex"] as? String,
              let userEmail = data["email"] as? String,
              let userAvatarStringURL = data["avatarStringURL"] as? String,
              let userDescription = data["description"] as? String,
              let userUid = data["uid"] as? String
        else { return nil }
        self.username = username
        self.email = userEmail
        self.avatarStringURL = userAvatarStringURL
        self.description = userDescription
        self.sex = userSex
        self.id = userUid
    }
    
    var representation: [String: Any] {
        var rep = ["username": username]
        rep["sex"] = sex
        rep["email"] = email
        rep["avatarStringURL"] = avatarStringURL
        rep["description"] = description
        rep["uid"] = id
        return rep
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: MUser, rhs: MUser) -> Bool {
        return lhs.id == rhs.id
    }
    
    func contains(filter: String?) -> Bool {
        guard let filter = filter else { return true }
        if filter.isEmpty { return true }
        
        let lowercasedFilter = filter.lowercased()
        return username.lowercased().contains(lowercasedFilter)
    }
}
