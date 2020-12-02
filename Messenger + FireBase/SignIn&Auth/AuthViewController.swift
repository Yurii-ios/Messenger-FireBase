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
    private let logoImageView = UIImageView(image: #imageLiteral(resourceName: "Logo"), contentMode: .scaleAspectFit)
   
//MARK: - Labels
    private let goodleLabel = UILabel(text: "Get started with")
    private let emailLabel = UILabel(text: "Or sing up with")
    private let alreadyOnboardLabel = UILabel(text: "Already onboard?")
    
//MARK: - Buttons
   private let emailButton = UIButton(title: "Email",
                               titleColor: .white,
                               backgroundColor: .buttonBlack(),
                               isShadow: false)
    
   private let loginButton = UIButton(title: "Login",
                               titleColor: .buttonRed(),
                               backgroundColor: .white,
                               isShadow: true)
    
   private let googleButton = UIButton(title: "Google",
                                titleColor: .black,
                                backgroundColor: .white,
                                isShadow: true)
    
   private let signUpVC = SignUpViewController()
   private let loginVC = LoginViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // dobawliaem logo google w lewyjy 4ast knopki
        googleButton.customizeGoogleButton()
        
        view.backgroundColor = .white
        setupConstraints()
        
        emailButton.addTarget(self, action: #selector(emailButtonTapped), for: .touchUpInside)
        
        loginButton.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
        
        signUpVC.delegate = self
        loginVC.delegate = self
    }
    
    @objc private func emailButtonTapped() {
        print(#function)
        present(signUpVC, animated: true, completion: nil)
    }
    
    @objc private func loginButtonTapped() {
        print(#function)
        present(loginVC, animated: true, completion: nil)
    }
}

//MARK: - AuthViewControllerDelegate
extension AuthViewController: AuthNavigationDelegate {
    func toLoginVC() {
        present(loginVC, animated: true, completion: nil)
    }
    
    func toSignUpVC() {
        present(signUpVC, animated: true, completion: nil)
    }
    
    
}

//MARK: - Setup Constraints
extension AuthViewController {
    private func setupConstraints() {
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
    
        let googleView = ButtonFormView(label: goodleLabel, button: googleButton)
        let emailleView = ButtonFormView(label: emailLabel, button: emailButton)
        let loginView = ButtonFormView(label: alreadyOnboardLabel, button: loginButton)
        
        let stackView = UIStackView(arrangedSubviews: [googleView, emailleView, loginView], axis: .vertical, spacing: 40)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        
        
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
