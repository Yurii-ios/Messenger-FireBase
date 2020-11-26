//
//  SelfConfigurationCell.swift
//  Messenger + FireBase
//
//  Created by Yurii Sameliuk on 26/11/2020.
//

import UIKit

protocol SelfConfiguringCell {
    static var reuseID: String { get }
    func configure(with value: MChat )
}
