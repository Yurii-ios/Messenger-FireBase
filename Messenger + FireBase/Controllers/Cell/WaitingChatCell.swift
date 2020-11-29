//
//  WaitingChatCell.swift
//  Messenger + FireBase
//
//  Created by Yurii Sameliuk on 26/11/2020.
//

import UIKit
import SwiftUI

class WaitingChatCell: UICollectionViewCell, SelfConfiguringCell {
    func configure<U>(with value: U) where U : Hashable {
        
    }
    
    static var reuseID: String = "WaitingChatCell"
    
    let friendImageView = UIImageView()
    
    func configure(with value: MChat) {
        friendImageView.image = UIImage(named: value.userImageString)
    }
    
    private func setupConstraints() {
        friendImageView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(friendImageView)
        
        NSLayoutConstraint.activate([
            friendImageView.topAnchor.constraint(equalTo: self.topAnchor),
            friendImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            friendImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            friendImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .orange
        
        self.layer.cornerRadius = 4
        self.clipsToBounds = true
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: - SwiftUI
struct WaitingChatCellProvider: PreviewProvider {
    static var previews: some View {
        ContainerView().edgesIgnoringSafeArea(.all)
    }
    
    struct ContainerView: UIViewControllerRepresentable {
        
        let mainViewController = MainTabBarController()
        
        func makeUIViewController(context: UIViewControllerRepresentableContext<WaitingChatCellProvider.ContainerView>) -> MainTabBarController {
            return mainViewController
        }
        func updateUIViewController(_ uiViewController: WaitingChatCellProvider.ContainerView.UIViewControllerType, context: UIViewControllerRepresentableContext<WaitingChatCellProvider.ContainerView>) {
            
        }
    }
}
