//
//  AddPhotoView.swift
//  Messenger + FireBase
//
//  Created by Yurii Sameliuk on 22/11/2020.
//

import UIKit

class AddPhotoView: UIView {
    // polzowatelskaja awatarka pri registracii
    var circleImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = #imageLiteral(resourceName: "avatar")
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.borderColor = UIColor.black.cgColor
        imageView.layer.borderWidth = 1
        return imageView
    }()
    
    let plusButton: UIButton = {
        let plusButton = UIButton(type: .system)
        plusButton.translatesAutoresizingMaskIntoConstraints = false
        let myImage = #imageLiteral(resourceName: "plus")
        plusButton.setImage(myImage, for: UIControl.State.normal)
        plusButton.tintColor = .buttonBlack()
        
        return plusButton
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(circleImageView)
        addSubview(plusButton)
        
        setupConstraints()
        
    }
    
    //MARK: - Setup constraints
    private func setupConstraints() {
        circleImageView.topAnchor.constraint(equalTo: topAnchor, constant: 0).isActive = true
        circleImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0).isActive = true
        circleImageView.widthAnchor.constraint(equalToConstant: 100).isActive = true
        circleImageView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        
        plusButton.leadingAnchor.constraint(equalTo: circleImageView.trailingAnchor, constant: 10).isActive = true
        plusButton.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        plusButton.widthAnchor.constraint(equalToConstant: 30).isActive = true
        plusButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        bottomAnchor.constraint(equalTo: circleImageView.bottomAnchor).isActive = true
        trailingAnchor.constraint(equalTo: plusButton.trailingAnchor).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // okrugliaem circleImageView
    override func layoutSubviews() {
        super.layoutSubviews()
        circleImageView.layer.masksToBounds = true
        circleImageView.layer.cornerRadius = circleImageView.frame.width / 2
    }
}
