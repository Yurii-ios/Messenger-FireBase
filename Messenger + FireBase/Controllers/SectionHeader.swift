//
//  SectionHeader.swift
//  Messenger + FireBase
//
//  Created by Yurii Sameliuk on 26/11/2020.
//

import UIKit

class SectionHeader: UICollectionReusableView {
   static let reuseId = "SectionHeader"
    
    let title = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        title.translatesAutoresizingMaskIntoConstraints = false
        addSubview(title)
        
        NSLayoutConstraint.activate([
            title.topAnchor.constraint(equalTo: topAnchor),
            title.leadingAnchor.constraint(equalTo: leadingAnchor),
            title.trailingAnchor.constraint(equalTo: trailingAnchor),
            title.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    func configurate(text: String, font: UIFont?, textColor: UIColor) {
        title.text = text
        title.font = font
        title.textColor = textColor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
