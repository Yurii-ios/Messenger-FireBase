//
//  SetupProfileViewController.swift
//  Messenger + FireBase
//
//  Created by Yurii Sameliuk on 22/11/2020.
//

import UIKit
import SwiftUI
import FirebaseAuth
import SDWebImage

class SetupProfileViewController: UIViewController {
    
    let fullImageView = AddPhotoView()
    
    //MARK: - Labels
    let welcomeLabel = UILabel(text: "Set up profile", font: UIFont.avenir26())
    
    let fullNameLabel = UILabel(text: "Full name")
    let aboutMeLabel = UILabel(text: "About me")
    let sexLabel = UILabel(text: "Sex")
    
    //MARK: - Text Fields
    let fullNameTextField = OneLineTextField(font: UIFont.avenir20())
    let aboutMeTextField = OneLineTextField(font: UIFont.avenir20())
    
    //MARK: - Segment control
    let sexSegmentedControll = UISegmentedControl(first: "Male", second: "Female")
    
    //MARK: - Button
    let goToChatsButton = UIButton(title: "Go to chats!", titleColor: .white, backgroundColor: .buttonBlack(), cornerRadius: 4)
    
    private let currentUser: User
    
    init(currentUser: User) {
        self.currentUser = currentUser
        super.init(nibName: nil, bundle: nil)
        
        //pri registracii 4erez google srazy peredaem imja polzowatelia w polia registracii
        if let username = currentUser.displayName {
            fullNameTextField.text = username
        }
        
        if let photoUrl = currentUser.photoURL {
            fullImageView.circleImageView.sd_setImage(with: photoUrl, completed: nil)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupConstraints()
        
        view.backgroundColor = .mainWhite()
        
        goToChatsButton.addTarget(self, action: #selector(goToChatsButtonTapped), for: .touchUpInside)
        
        fullImageView.plusButton.addTarget(self, action: #selector(fullImageViewPlusButtonTapped), for: .touchUpInside)
    }
    
    @objc private func goToChatsButtonTapped () {
        FirestoreService.shared.saveProfileWith(id: currentUser.uid,
                                                email: currentUser.email!,
                                                username: fullNameTextField.text,
                                                avatarImage: fullImageView.circleImageView.image,
                                                description: aboutMeTextField.text,
                                                sex: sexSegmentedControll.titleForSegment(at: sexSegmentedControll.selectedSegmentIndex)) { (result) in
            switch result {
            case .success(let muser):
                self.showAlert(with: "Registered", and: "You are registered!") {
                    let mainTabBar = MainTabBarController(currentUser: muser)
                    mainTabBar.modalPresentationStyle = .fullScreen
                    self.present(mainTabBar, animated: true, completion: nil)
                }
                print(muser)
            case .failure(let error):
                self.showAlert(with: "Error", and: error.localizedDescription)
            }
        }
    }
    
    @objc private func fullImageViewPlusButtonTapped() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = .photoLibrary
        present(imagePickerController, animated: true, completion: nil)
    }
}

//MARK: - UIImagePickerControllerDelegate
extension SetupProfileViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        picker.dismiss(animated: true, completion: nil)
        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else { return }
        
        fullImageView.circleImageView.image = image
    }
}

//MARK: - Setup Constraints
extension SetupProfileViewController {
    
    private func setupConstraints() {
        let fullNameStackView = UIStackView(arrangedSubviews: [ fullNameLabel, fullNameTextField], axis: .vertical, spacing: 0)
        let aboutMeStackView = UIStackView(arrangedSubviews: [aboutMeLabel, aboutMeTextField], axis: .vertical, spacing: 0)
        let sexStackView = UIStackView(arrangedSubviews: [sexLabel, sexSegmentedControll], axis: .vertical, spacing: 5)
        
        goToChatsButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        let stackView = UIStackView(arrangedSubviews: [fullNameStackView, aboutMeStackView, sexStackView, goToChatsButton], axis: .vertical, spacing: 40)
        
        welcomeLabel.translatesAutoresizingMaskIntoConstraints = false
        fullImageView.translatesAutoresizingMaskIntoConstraints = false
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(welcomeLabel)
        view.addSubview(fullImageView)
        view.addSubview(stackView)
        
        welcomeLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 160).isActive = true
        welcomeLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        fullImageView.topAnchor.constraint(equalTo: welcomeLabel.bottomAnchor, constant: 40).isActive = true
        fullImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        stackView.topAnchor.constraint(equalTo: fullImageView.bottomAnchor, constant: 40).isActive = true
        stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40).isActive = true
        stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40).isActive = true
        
    }
}

//MARK: - SwiftUI
struct SetupProfileViewControllerProvider: PreviewProvider {
    static var previews: some View {
        ContainerView().edgesIgnoringSafeArea(.all)
    }
    
    struct ContainerView: UIViewControllerRepresentable {
        
        let setupProfileViewController = SetupProfileViewController(currentUser: Auth.auth().currentUser!)
        
        func makeUIViewController(context: UIViewControllerRepresentableContext<SetupProfileViewControllerProvider.ContainerView>) -> SetupProfileViewController {
            return setupProfileViewController
        }
        func updateUIViewController(_ uiViewController: SetupProfileViewControllerProvider.ContainerView.UIViewControllerType, context: UIViewControllerRepresentableContext<SetupProfileViewControllerProvider.ContainerView>) {
            
        }
    }
}
