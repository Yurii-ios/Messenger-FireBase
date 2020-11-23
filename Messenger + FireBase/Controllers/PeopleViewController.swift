//
//  PeopleViewController.swift
//  Messenger + FireBase
//
//  Created by Yurii Sameliuk on 23/11/2020.
//

import UIKit
import SwiftUI

class PeopleViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSearchBar()
        view.backgroundColor = .brown
    }
    
    private func setupSearchBar() {
        // izmeniaem cwet navigationBar
        navigationController?.navigationBar.barTintColor = .mainWhite()
        // navBar vizyalno propadaet iz wida
        navigationController?.navigationBar.shadowImage = UIImage()
        
        let searchController = UISearchController(searchResultsController: nil)
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        //должна ли панель навигации быть скрыта при поиске
        searchController.hidesNavigationBarDuringPresentation = false
        //скрыто ли основное содержимое во время поиска.
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.delegate = self
    }
}
//MARK: - UISearchBarDelegate
extension PeopleViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print(searchText)
    }
}

//MARK: - SwiftUI
struct PeopleViewControllerProvider: PreviewProvider {
    static var previews: some View {
        ContainerView().edgesIgnoringSafeArea(.all)
    }
    
    struct ContainerView: UIViewControllerRepresentable {
        
        let mainViewController = MainTabBarController()
        
        func makeUIViewController(context: UIViewControllerRepresentableContext<PeopleViewControllerProvider.ContainerView>) -> MainTabBarController {
            return mainViewController
        }
        func updateUIViewController(_ uiViewController: PeopleViewControllerProvider.ContainerView.UIViewControllerType, context: UIViewControllerRepresentableContext<PeopleViewControllerProvider.ContainerView>) {
            
        }
    }
}
