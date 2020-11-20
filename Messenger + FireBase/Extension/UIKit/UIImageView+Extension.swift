//
//  UIImageView+Extension.swift
//  Messenger + FireBase
//
//  Created by Yurii Sameliuk on 20/11/2020.
//

import UIKit

extension UIImageView {
    
    convenience init(image: UIImage?, contentMode: UIView.ContentMode) {
        self.init()
        self.image = image
        self.contentMode = contentMode
    }
}
