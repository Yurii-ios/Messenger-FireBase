//
//  MMessage.swift
//  Messenger + FireBase
//
//  Created by Yurii Sameliuk on 08/12/2020.
//

import UIKit
import FirebaseFirestore

struct MMessage: Hashable {
    let content: String
    let senderId: String
    let senderUsername: String
    var sentDate: Date
    let id: String?
    
    var representation: [String: Any] {
        let rep: [String: Any] = [
            "created": sentDate,
            "senderID": senderId,
            "senderName": senderUsername,
            "content": content
        ]
        
        return rep
    }
    
    init(user: MUser, content: String) {
        self.content = content
        senderId = user.id
        senderUsername = user.username
        sentDate = Date()
        id = nil
    }
    
    init?(document: QueryDocumentSnapshot) {
        let data = document.data()
        // data w fireBase chranitsia w drygom formate, poetomy nyžno kastit ne k Date a k Timestamp!
        guard let sentData = data["created"] as? Timestamp else { return nil }
        guard let senderID = data["senderID"] as? String else { return nil }
        guard let senderName = data["senderName"] as? String else { return nil }
        guard let content = data["content"] as? String else { return nil }
        
        self.id = document.documentID
        self.sentDate = sentData.dateValue()
        self.senderId = senderID
        self.senderUsername = senderName
        self.content = content
    }
}
