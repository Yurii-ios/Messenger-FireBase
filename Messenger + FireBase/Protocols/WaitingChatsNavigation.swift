//
//  WaitingChatsNavigation.swift
//  Messenger + FireBase
//
//  Created by Yurii Sameliuk on 10/12/2020.
//

import UIKit

protocol WaitingChatsNavigation: class {
    func removeWaitingCtah(chat: MChat)
    func chatToActive(chat: MChat)
}
