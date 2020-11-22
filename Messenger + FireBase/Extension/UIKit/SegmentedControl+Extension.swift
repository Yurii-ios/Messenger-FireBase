//
//  SegmentedControl+Extension.swift
//  Messenger + FireBase
//
//  Created by Yurii Sameliuk on 22/11/2020.
//

import UIKit

extension UISegmentedControl {
    convenience init(first: String, second: String) {
        self.init()
        translatesAutoresizingMaskIntoConstraints = false
        insertSegment(withTitle: first, at: 0, animated: true)
        insertSegment(withTitle: second, at: 1, animated: true)
        
        selectedSegmentIndex = 0
        
    }
}
