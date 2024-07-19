//
//  RSOTabbarCordinator.swift
//  TabDemo
//
//  Created by Pradip Deore on 22/02/24.
//

import Foundation
import UIKit

protocol RSOTabCoordinated: AnyObject {
    var coordinator: RSOTabBarCordinator? { get set }
}
class RSOTabBarCordinator {
    private let tabBarController: RSOTabBarViewController
    init(tabBarController: RSOTabBarViewController) {
        self.tabBarController = tabBarController
    }
    func showChildViewController(_ viewController: UIViewController) {
        tabBarController.addChild(viewController)
        viewController.didMove(toParent: tabBarController)
        tabBarController.containerView.addSubview(viewController.view)
        viewController.view.frame = tabBarController.containerView.bounds
    }
    func hideChildViewController(_ viewController: UIViewController) {
        viewController.willMove(toParent: nil)
        viewController.view.removeFromSuperview()
        viewController.removeFromParent()
    }
    
    func hideBackButton(isHidden : Bool) {
        if isHidden {
            self.tabBarController.backButtonWidthConstraint.constant = 0
            self.tabBarController.btnBackArrow.isHidden = true
            self.tabBarController.titleLabelLeadingConstaint.constant = 25
            
        } else {
            self.tabBarController.backButtonWidthConstraint.constant = 50
            self.tabBarController.btnBackArrow.isHidden = false
            self.tabBarController.titleLabelLeadingConstaint.constant = 0
        }
    }
  func hideTopViewForHome(isHidden : Bool) {
      return 
      if isHidden {
        self.tabBarController.topbarHeightConstraint.constant = 0
      } else {
        self.tabBarController.topbarHeightConstraint.constant = 50
      }
  }
    func setTitle(title:String){
        self.tabBarController.lblGreeting.text = title
    }
    func loadHomeScreen(){
      self.tabBarController.tabButtonTapped( self.tabBarController.tabButtons.first)
    }
    
  func getInnerNavigationVC(at index: Int) -> UINavigationController? {
    if index < self.tabBarController.viewControllers.count {
      let navVC = self.tabBarController.viewControllers[index] as? UINavigationController
      return navVC
    }
    return nil
  }
}
