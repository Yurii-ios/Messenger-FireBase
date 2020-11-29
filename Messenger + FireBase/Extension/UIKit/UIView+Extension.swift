//
//  UIView+Extension.swift
//  Messenger + FireBase
//
//  Created by Yurii Sameliuk on 29/11/2020.
//

import UIKit

extension UIView {
    func applyGradients(cornerRadius: CGFloat) {
        self.backgroundColor = nil
        self.layoutIfNeeded()
        let gradientView = GradientView(from: .topTrailing, to: .bottomLeading, startColor: #colorLiteral(red: 0.5568627451, green: 0.3529411765, blue: 0.968627451, alpha: 1), endColor: #colorLiteral(red: 0.2457692672, green: 0.7913601415, blue: 0.9534787548, alpha: 1))
        if let gradientLayer = gradientView.layer.sublayers?.first as? CAGradientLayer {
            gradientLayer.frame = self.bounds
            gradientLayer.cornerRadius = cornerRadius
        }
        self.layer.insertSublayer(CAGradientLayer, at: 0)
    }
}
