//
//  UIAplication+Extension.swift
//  Messenger + FireBase
//
//  Created by Yurii Sameliuk on 06/12/2020.
//

import UIKit

extension UIApplication {
    // funkcuja dostaet samuj werchij UIController w priloženii
    class func getTopViewController(base: UIViewController? = UIApplication.shared.windows.filter {$0.isKeyWindow}.first?.rootViewController) -> UIViewController? {
        if let nav = base as? UINavigationController {
            return getTopViewController(base: nav.visibleViewController)
        } else if let tab = base as? UITabBarController, let selected = tab.selectedViewController{
            return getTopViewController(base: selected)
        } else if let presented = base?.presentedViewController {
            return getTopViewController(base: presented)
        }
        return base
    }
}
