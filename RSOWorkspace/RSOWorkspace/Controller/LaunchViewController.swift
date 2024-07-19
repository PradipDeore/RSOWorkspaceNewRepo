//
//  LaunchViewController.swift
//  RSOWorkspace
//
//  Created by Sumit Aquil on 12/02/24.
//

import UIKit

class LaunchViewController: UIViewController {
    @IBOutlet weak var btnStart: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
      if RSOToken.shared.isLoggedIn() {
            RSOTabBarViewController.presentAsRootController()
        }else{
            GetStartedViewController.presentAsRootController()
        }
    }
}
