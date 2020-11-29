//
//  UIViewController+Extension.swift
//  Messenger + FireBase
//
//  Created by Yurii Sameliuk on 29/11/2020.
//

import UIKit

extension UIViewController {
    func configure<T: SelfConfiguringCell, U: Hashable>(collectionView: UICollectionView, cellTupe: T.Type, with value: U, for indexPath: IndexPath) -> T {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellTupe.reuseID, for: indexPath) as? T else { fatalError("Unable to dequeue \(cellTupe)")}
        
        cell.configure(with: value)
        return cell
    }
}
