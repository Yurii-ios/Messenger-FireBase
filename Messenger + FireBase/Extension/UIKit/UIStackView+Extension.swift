//
//  UIStackView+Extension.swift
//  Messenger + FireBase
//
//  Created by Yurii Sameliuk on 20/11/2020.
//

import UIKit

extension UIStackView {
    
    convenience init(arrangedSubviews: [UIView], axis: NSLayoutConstraint.Axis, spacing: CGFloat) {
        self.init(arrangedSubviews: arrangedSubviews)
        self.axis = axis
        self.spacing = spacing
        
    }
}
