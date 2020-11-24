//
//  ListViewController.swift
//  Messenger + FireBase
//
//  Created by Yurii Sameliuk on 23/11/2020.
//

import UIKit
import SwiftUI

struct MChat: Hashable {
    var userName: String
    var userImage: UIImage
    var lastMessage: String
    var id = UUID()
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: MChat, rhs: MChat) -> Bool {
        return lhs.id == rhs.id
    }
}

class ListViewController: UIViewController {
    
    let activeChats: [MChat] = [
        MChat(userName: "Yurii", userImage: UIImage(named: "human1")!, lastMessage: "Hello"),
        MChat(userName: "Max", userImage: UIImage(named: "human2")!, lastMessage: "hello Yurii"),
        MChat(userName: "Irina", userImage: UIImage(named: "human3")!, lastMessage: "hello Yurii"),
        MChat(userName: "Maxim", userImage: UIImage(named: "human4")!, lastMessage: "hello Yurii")
    ]
    
    var collectionView: UICollectionView!
    
    enum Section: Int, CaseIterable {
        case activeChats
    }
    var dataSource: UICollectionViewDiffableDataSource<Section, MChat>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCollectionView()
        setupSearchBar()
        createDataSourse()
        reloadData()
        
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
    
    private func setupCollectionView() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createCompositionLayout())
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.backgroundColor = .mainWhite()
        view.addSubview(collectionView)
        
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
    }
    
    private func createDataSourse() {
        dataSource = UICollectionViewDiffableDataSource<Section, MChat>(collectionView: collectionView, cellProvider: { (collectionView, indexPath, chat) -> UICollectionViewCell? in
            // dostaem ja4ejky
            guard let section = Section(rawValue: indexPath.section) else { fatalError("Unknon Section")}
            
            switch section {
            case .activeChats:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
                cell.backgroundColor = .red
                return cell
            }
        })
    }
    
    private func reloadData() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, MChat>()
        snapshot.appendSections([.activeChats])
        snapshot.appendItems(activeChats,toSection: .activeChats)
        dataSource?.apply(snapshot, animatingDifferences: true)
    }
    
    private func createCompositionLayout() -> UICollectionViewLayout {
        
        let layout = UICollectionViewCompositionalLayout { (sectionIndex, layoutEnvironment) -> NSCollectionLayoutSection? in
            //section -> groups -> items -> size
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(84))
            let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
            group.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 8, trailing: 0)
            
            let section = NSCollectionLayoutSection(group: group)
            // razmer sekcii
            section.contentInsets = NSDirectionalEdgeInsets(top: 16, leading: 20, bottom: 0, trailing: 20)
            return section
        }
        return layout
    }
}
//MARK: - UICollectionViewDelegate, UICollectionViewDataSource
extension ListViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        cell.backgroundColor = .blue
        return cell
    }
}

//MARK: - UISearchBarDelegate
extension ListViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print(searchText)
    }
}

//MARK: - SwiftUI
struct ListViewControllerProvider: PreviewProvider {
    static var previews: some View {
        ContainerView().edgesIgnoringSafeArea(.all)
    }
    
    struct ContainerView: UIViewControllerRepresentable {
        
        let mainViewController = MainTabBarController()
        
        func makeUIViewController(context: UIViewControllerRepresentableContext<ListViewControllerProvider.ContainerView>) -> MainTabBarController {
            return mainViewController
        }
        func updateUIViewController(_ uiViewController: ListViewControllerProvider.ContainerView.UIViewControllerType, context: UIViewControllerRepresentableContext<ListViewControllerProvider.ContainerView>) {
            
        }
    }
}
