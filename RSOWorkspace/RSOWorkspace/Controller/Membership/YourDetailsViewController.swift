//
//  YourDetailsViewController.swift
//  RSOWorkspace
//
//  Created by Pradip Deore on 25/07/24.
//

import UIKit

class YourDetailsViewController: UIViewController, MembershipNavigable {
  var membershipNavigationDelegate: MembershipNavigationDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
  @IBAction func createAccountAction(_ sender: Any) {
    GetStartedViewController.presentAsRootController()
  }
  @IBAction func loginNowAction(_ sender: Any) {
    GetStartedViewController.presentAsRootController()
  }
}
