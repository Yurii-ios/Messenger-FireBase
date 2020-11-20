//
//  ViewController.swift
//  Messenger + FireBase
//
//  Created by Yurii Sameliuk on 20/11/2020.
//

import UIKit
import SwiftUI

class AuthViewController: UIViewController {

    let emailButton = UIButton(title: "Email",
                            titleColor: .black,
                            backgroundColor: .white,
                            font: UIFont.avenir20(),
                            isShadow: true,
                            cornerRadius: 4)
   
    let loginButton = UIButton(title: "Login",
                               titleColor: .red,
                               backgroundColor: <#T##UIColor#>,
                               font: <#T##UIFont?#>,
                               isShadow: <#T##Bool#>,
                               cornerRadius: <#T##CGFloat#>)
    
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
