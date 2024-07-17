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
