//
//  UIButton+Extension.swift
//  Messenger + FireBase
//
//  Created by Yurii Sameliuk on 20/11/2020.
//

import UIKit

extension UIButton {
    convenience init(title: String,
                    titleColor: UIColor,
                    backgroundColor: UIColor,
                    font: UIFont?,
                    isShadow: Bool,
                    cornerRadius: CGFloat) {
        self.init(type: .system)
        self.setTitle(title, for: .normal)
        self.setTitleColor(titleColor, for: .normal)
        self.backgroundColor = backgroundColor
        self.titleLabel?.font = font
        self.layer.cornerRadius = cornerRadius
        
        if isShadow {
            self.layer.shadowColor = UIColor.black.cgColor
            self.layer.shadowRadius = 4
            self.layer.shadowOpacity = 0.2// blik
            self.layer.shadowOffset = CGSize(width: 0, height: 4)// w kakyjy storony bydet ychodit
        }
    }
}
