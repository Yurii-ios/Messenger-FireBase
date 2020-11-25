//
//  ActiveChatCell.swift
//  Messenger + FireBase
//
//  Created by Yurii Sameliuk on 25/11/2020.
//

import UIKit
import SwiftUI

protocol SelfConfiguringCell {
    static var reuseID: String { get }
    func configure(with value: MChat )
}

class ActiveChatCell: UICollectionViewCell,SelfConfiguringCell {
    static var reuseID: String = "ActiveChatCell"
    
    let friendImageView = UIImageView()
    let friendName = UILabel(text: "User name", font: UIFont.laoSangamMN20())
    let lastMessage = UILabel(text: "Hello", font: UIFont.laoSangamMN18())
    let gradientView = UIView()
    
    func configure(with value: MChat) {
        friendImageView.image = UIImage(named: value.userImageString)
        friendName.text = value.username
        lastMessage.text = value.lastMessage
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        setupConsraints()
        
        self.layer.cornerRadius = 4
        self.clipsToBounds = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: - Setup constraints
extension ActiveChatCell {
    
    private func setupConsraints() {
        friendImageView.translatesAutoresizingMaskIntoConstraints = false
        gradientView.translatesAutoresizingMaskIntoConstraints = false
        friendName.translatesAutoresizingMaskIntoConstraints = false
        lastMessage.translatesAutoresizingMaskIntoConstraints = false
        
        friendImageView.backgroundColor = .green
        gradientView.backgroundColor = .black
       
        addSubview(friendImageView)
        addSubview(gradientView)
        addSubview(friendName)
        addSubview(lastMessage)
        
        //MARK: - FriendImageView constraints
        NSLayoutConstraint.activate([
            friendImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            friendImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            friendImageView.heightAnchor.constraint(equalToConstant: 78),
            friendImageView.widthAnchor.constraint(equalToConstant: 78)
        ])
        
        //MARK: - FriendName constraints
        NSLayoutConstraint.activate([
            friendName.topAnchor.constraint(equalTo: topAnchor, constant: 12),
            friendName.leadingAnchor.constraint(equalTo: friendImageView.trailingAnchor, constant: 16),
            friendName.trailingAnchor.constraint(equalTo: gradientView.leadingAnchor, constant: 16)
        ])
        
        //MARK: - FriendName constraints
        NSLayoutConstraint.activate([
            lastMessage.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -14),
            lastMessage.leadingAnchor.constraint(equalTo: friendImageView.trailingAnchor, constant: 16),
            lastMessage.trailingAnchor.constraint(equalTo: gradientView.leadingAnchor, constant: 16)
        ])
        
        //MARK: - GradientView constraints
        NSLayoutConstraint.activate([
            gradientView.trailingAnchor.constraint(equalTo: trailingAnchor),
            gradientView.centerYAnchor.constraint(equalTo: centerYAnchor),
            gradientView.heightAnchor.constraint(equalToConstant: 78),
            gradientView.widthAnchor.constraint(equalToConstant: 8)
        ])
    }
}

//MARK: - SwiftUI
struct ActiveChatCellProvider: PreviewProvider {
    static var previews: some View {
        ContainerView().edgesIgnoringSafeArea(.all)
    }
    
    struct ContainerView: UIViewControllerRepresentable {
        
        let mainViewController = MainTabBarController()
        
        func makeUIViewController(context: UIViewControllerRepresentableContext<ActiveChatCellProvider.ContainerView>) -> MainTabBarController {
            return mainViewController
        }
        func updateUIViewController(_ uiViewController: ActiveChatCellProvider.ContainerView.UIViewControllerType, context: UIViewControllerRepresentableContext<ActiveChatCellProvider.ContainerView>) {
            
        }
    }
}
