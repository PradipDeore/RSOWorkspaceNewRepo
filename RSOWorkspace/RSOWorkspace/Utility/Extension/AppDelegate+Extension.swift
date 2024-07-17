//
//  AppDelegate+Extension.swift
//  RSOWorkspace
//
//  Created by Sumit Aquil on 23/02/24.
//

import UIKit

extension AppDelegate {
  class func setWindowRoot(viewController: UIViewController) {
    let navigationController = UINavigationController(rootViewController: viewController)
    guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
          let delegate = windowScene.delegate as? SceneDelegate, let window = delegate.window else { return }
    navigationController.navigationBar.isHidden = true
    window.rootViewController = navigationController
    window.makeKeyAndVisible()
  }}
extension UIApplication {
    var topViewController: UIViewController? {
        var topViewController: UIViewController? = nil
        if #available(iOS 13, *) {
            topViewController = connectedScenes.compactMap {
                return ($0 as? UIWindowScene)?.windows.filter { $0.isKeyWindow  }.first?.rootViewController
            }.first
        } else {
            topViewController = keyWindow?.rootViewController
        }
        if let presented = topViewController?.presentedViewController {
            topViewController = presented
        } else if let navController = topViewController as? UINavigationController {
            topViewController = navController.topViewController
        } else if let tabBarController = topViewController as? UITabBarController {
            topViewController = tabBarController.selectedViewController
        }
        return topViewController
    }
}
