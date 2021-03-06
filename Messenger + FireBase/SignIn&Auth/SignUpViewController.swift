//
//  SignUpViewController.swift
//  Messenger + FireBase
//
//  Created by Yurii Sameliuk on 21/11/2020.
//

import UIKit
import SwiftUI

class SignUpViewController: UIViewController {
    //MARK: - Labels
    let welcomeLabel = UILabel(text: "Good to see you!", font: UIFont.avenir26())
    
    let emailLabel = UILabel(text: "Email")
    let passordLabel = UILabel(text: "Password")
    let confirmPasswordLabel = UILabel(text: "ConfirmPassword")
    let alreadyOnboardLabel = UILabel(text: "Already onboard?")
    
    //MARK: - Text Fields
    let emailTextField = OneLineTextField(font: UIFont.avenir20())
    let passwordTextField = OneLineTextField(font: UIFont.avenir20())
    let confirmPasswordTextField = OneLineTextField(font: UIFont.avenir20())
    
    //MARK: - Buttons
    let signUpButton = UIButton(title: "Sign Up", titleColor: .white, backgroundColor: .buttonBlack(), cornerRadius: 4)
    let loginButton = UIButton(type: .system)
    
    weak var delegate: AuthNavigationDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loginButton.setTitle("Login", for: .normal)
        loginButton.setTitleColor(.buttonRed(), for: .normal)
        loginButton.titleLabel?.font = UIFont.avenir20()
        setupConstraints()
        view.backgroundColor = .mainWhite()
        signUpButton.addTarget(self, action: #selector(signUpButtonTapped), for: .touchUpInside)
        loginButton.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
    }
    
    @objc private func signUpButtonTapped() {
        print(#function)
        AuthService.shared.register(email: emailTextField.text, password: passwordTextField.text, confirmPassword: confirmPasswordTextField.text) { (result) in
            
            switch result {
            case .success(let user):
                self.showAlert(with: "Registered", and: "You are registered!") {
                    self.present(SetupProfileViewController(currentUser: user), animated: true, completion: nil)
                }
            case .failure(let error):
                self.showAlert(with: "Error", and: error.localizedDescription)
            }
        }
    }
    
    @objc private func loginButtonTapped() {
        self.dismiss(animated: true) {
            self.delegate?.toLoginVC()
        }
       
    }
}

extension UIViewController {
    func showAlert(with Title: String, and message: String, completion: @escaping () -> Void = { }) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let actionButton = UIAlertAction(title: "OK", style: .default) { (_) in
            completion()
        }
        alertController.addAction(actionButton)
        present(alertController, animated: true, completion: nil)
    }
}

//MARK: - Setup Constraints
extension SignUpViewController {
    
    private func setupConstraints() {
        let emailStackView = UIStackView(arrangedSubviews: [emailLabel, emailTextField], axis: .vertical, spacing: 0)
        let passwordStackView = UIStackView(arrangedSubviews: [passordLabel, passwordTextField], axis: .vertical, spacing: 0)
        let confirmPasswordStackView = UIStackView(arrangedSubviews: [confirmPasswordLabel, confirmPasswordTextField], axis: .vertical, spacing: 0)
        
        signUpButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        let stackView = UIStackView(arrangedSubviews: [emailStackView, passwordStackView, confirmPasswordStackView, signUpButton], axis: .vertical, spacing: 40)
        
        loginButton.contentHorizontalAlignment = .leading
        let bottomStackView = UIStackView(arrangedSubviews: [alreadyOnboardLabel, loginButton], axis: .horizontal, spacing: 10)
        bottomStackView.alignment = .firstBaseline
        
        welcomeLabel.translatesAutoresizingMaskIntoConstraints = false
        stackView.translatesAutoresizingMaskIntoConstraints = false
        bottomStackView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(welcomeLabel)
        view.addSubview(stackView)
        view.addSubview(bottomStackView)
        
        //MARK: - WelcomeLabel constraints
        welcomeLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 120
        ).isActive = true
        welcomeLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        //MARK: - StackView constraints
        stackView.topAnchor.constraint(equalTo: welcomeLabel.bottomAnchor, constant: 160).isActive = true
        stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40).isActive = true
        stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40).isActive = true
        
        //MARK: - Bottom StackView constraints
        bottomStackView.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 60).isActive = true
        bottomStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40
        ).isActive = true
        bottomStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40).isActive = true
        
    }
}
//MARK: - SwiftUi
struct SignUpProvider: PreviewProvider {
    static var previews: some View {
        ContainerView().edgesIgnoringSafeArea(.all)
    }
    
    struct ContainerView: UIViewControllerRepresentable {
        let signUpviewController = SignUpViewController()
        func makeUIViewController(context: Context) -> SignUpViewController {
            return signUpviewController
        }
        func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
            
        }
    }
}
