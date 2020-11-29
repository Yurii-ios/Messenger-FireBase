//
//  MainTabBarController.swift
//  Messenger + FireBase
//
//  Created by Yurii Sameliuk on 23/11/2020.
//

import UIKit

class MainTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let listViewController = ListViewController()
        let peopleViewController = PeopleViewController()
        
        tabBar.tintColor =  #colorLiteral(red: 0.5568627451, green: 0.3529411765, blue: 0.968627451, alpha: 1)
        let boldConfiguration = UIImage.SymbolConfiguration(weight: .medium)
        
        let peopleImage = UIImage(systemName: "person.2", withConfiguration: boldConfiguration)!
        let convImage = UIImage(systemName: "bubble.left.and.bubble.right",withConfiguration: boldConfiguration)!
        
        viewControllers = [
            generateNavigationController(rootviewController: peopleViewController, title: "People", image: peopleImage),
            generateNavigationController(rootviewController: listViewController, title: "Conversations", image: convImage)
                          
        ]
    }
    
    private func generateNavigationController(rootviewController: UIViewController, title: String, image: UIImage) -> UIViewController {
        let navigationViewController = UINavigationController(rootViewController: rootviewController)
        navigationViewController.tabBarItem.title = title
        navigationViewController.tabBarItem.image = image
        
        return navigationViewController
    }
}
