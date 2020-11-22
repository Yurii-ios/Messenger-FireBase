//
//  SetupProfileViewController.swift
//  Messenger + FireBase
//
//  Created by Yurii Sameliuk on 22/11/2020.
//

import UIKit
import SwiftUI

class SetupProfileViewController: UIViewController {
    
    let fillImageView = AddPhotoView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupConstraints()
    }
}

//MARK: - Setup Constraints
extension SetupProfileViewController {
    
    private func setupConstraints() {
        view.addSubview(fillImageView)
        
        fillImageView.translatesAutoresizingMaskIntoConstraints = false
        
        fillImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 160).isActive = true
        fillImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
}

//MARK: - SwiftUI
struct SetupProfileViewControllerProvider: PreviewProvider {
    static var previews: some View {
        ContainerView().edgesIgnoringSafeArea(.all)
    }
    
    struct ContainerView: UIViewControllerRepresentable {
        
        let setupProfileViewController = SetupProfileViewController()
        
        func makeUIViewController(context: UIViewControllerRepresentableContext<SetupProfileViewControllerProvider.ContainerView>) -> SetupProfileViewController {
            return setupProfileViewController
        }
        func updateUIViewController(_ uiViewController: SetupProfileViewControllerProvider.ContainerView.UIViewControllerType, context: UIViewControllerRepresentableContext<SetupProfileViewControllerProvider.ContainerView>) {
            
        }
    }
}
