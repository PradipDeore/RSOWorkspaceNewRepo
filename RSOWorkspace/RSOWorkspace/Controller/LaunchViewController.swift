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
        if let _ = RSOToken.shared.getToken(){
            RSOTabBarViewController.presentAsRootController()
        }else{
            /*let deskListingVC = UIViewController.createController(storyBoard: .Products, ofType: RoomListingViewController.self)
            self.navigationController?.pushViewController(deskListingVC, animated: true)*/
            GetStartedViewController.presentAsRootController()
        }
    }
}
