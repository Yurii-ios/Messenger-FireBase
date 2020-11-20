//
//  ViewController.swift
//  Messenger + FireBase
//
//  Created by Yurii Sameliuk on 20/11/2020.
//

import UIKit
import SwiftUI

class AuthViewController: UIViewController {
//MARK: - Image
    let logoImageView = UIImageView(image: #imageLiteral(resourceName: "Logo"), contentMode: .scaleAspectFit)
   
//MARK: - Labels
    let goodleLabel = UILabel(text: "Get started with")
    let emailLabel = UILabel(text: "Or sing up with")
    let alreadyOnboardLabel = UILabel(text: "Already onboard?")
    
//MARK: - Buttons
    let emailButton = UIButton(title: "Email",
                               titleColor: .white,
                               backgroundColor: .buttonBlack(),
                               isShadow: false)
    
    let loginButton = UIButton(title: "Login",
                               titleColor: .buttonRed(),
                               backgroundColor: .white,
                               isShadow: true)
    
    let googleButton = UIButton(title: "Google",
                                titleColor: .black,
                                backgroundColor: .white,
                                isShadow: true)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupConstraints()
    }
    
    private func setupConstraints() {
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
    
        let googleView = ButtonFormView(label: goodleLabel, button: googleButton)
        let emailleView = ButtonFormView(label: emailLabel, button: emailButton)
        let loginView = ButtonFormView(label: alreadyOnboardLabel, button: loginButton)
        
        let stackView = UIStackView(arrangedSubviews: [googleView, emailleView, loginView])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 40
        
        view.addSubview(logoImageView)
        view.addSubview(stackView)
        
        logoImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 160).isActive = true
        logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        stackView.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 160).isActive = true
        stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40).isActive = true
        stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40).isActive = true
        
        
    }
}

//MARK: - SwiftUi
struct ViewControllerProvider: PreviewProvider {
    static var previews: some View {
        ContainerView().edgesIgnoringSafeArea(.all)
    }
    
    struct ContainerView: UIViewControllerRepresentable {
        let viewController = AuthViewController()
        func makeUIViewController(context: Context) -> AuthViewController {
            return viewController
        }
        func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
            
        }
    }
}
