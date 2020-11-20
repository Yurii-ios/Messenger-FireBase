//
//  ViewController.swift
//  Messenger + FireBase
//
//  Created by Yurii Sameliuk on 20/11/2020.
//

import UIKit
import SwiftUI

class AuthViewController: UIViewController {
    
    let goodleLabel = UILabel(
    
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
        view.backgroundColor = .blue
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
