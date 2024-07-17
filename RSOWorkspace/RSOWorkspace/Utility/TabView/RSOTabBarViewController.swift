//
//  RSOTabbarController.swift
//  TabDemo
//
//  Created by Pradip Deore on 22/02/24.
//

import Foundation
import UIKit

class RSOTabBarViewController: UIViewController {
    
    @IBOutlet weak var backButtonWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var lblGreeting: UILabel!
    
    @IBOutlet weak var topBarView: UIView!
    @IBOutlet weak var btnNotification: UIButton!
    @IBOutlet weak var titleLabelLeadingConstaint: NSLayoutConstraint!
    @IBOutlet weak var btnBackArrow: UIButton!
    @IBOutlet weak var btnSearch: UIButton!
    private var coordinator: RSOTabBarCordinator?
    @IBOutlet var tabViewWidthConstraint: NSLayoutConstraint!
    @IBOutlet var tabViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet var containerView: UIView!
    @IBOutlet var tabBarView: UIView!
    private var lastSelectedTabIndex = 0
    var scoreAPICount = 0
    var roomName = ""
    private var tabButtons = [UIButton]()
    private var viewControllers = [UIViewController]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showGreetingMessage()
        lastSelectedTabIndex = 0
        coordinator = RSOTabBarCordinator(tabBarController: self)
        setupTabBarView()
        for (index, item) in RSOTabItem.allCases.enumerated() {
            let viewController = item.createTabChildController()
            // set coordinator value
            if let childViewController = viewController as? RSOTabCoordinated {
                childViewController.coordinator = coordinator
            }
            if (tabButtons.count - 1) == index {
                viewControllers.append(viewController)
            } else {
                let navVC = UINavigationController(rootViewController: viewController)
                viewControllers.append(navVC)
            }
        }
        tabButtonTapped(tabButtons.first)
      
    }
    
    @IBAction func btnBackAction(_ sender: Any) {
        let currentNavcontroller = self.viewControllers[lastSelectedTabIndex] as? UINavigationController
        currentNavcontroller?.popViewController(animated: true)
            }
    func showGreetingMessage(){
        
        self.lblGreeting.text = RSOGreetings.greetingForCurrentTime()
    }
    
    @IBAction func btnNotificationsAction(_ sender: UIButton) {
        let notificationVC = UIViewController.createController(storyBoard: . Notifications, ofType: NotificationsViewController.self)
        self.topBarView.isHidden = true
        notificationVC.modalPresentationStyle = .overFullScreen
        notificationVC.modalTransitionStyle = .crossDissolve
        notificationVC.view.backgroundColor = UIColor.clear
        self.present(notificationVC, animated: true)
    }
    @IBAction func btnSearchRSOTAppedAction(_ sender: Any) {
        let searchRSOVC = UIViewController.createController(storyBoard: . TabBar, ofType: SearchRSOViewController.self)
        searchRSOVC.modalPresentationStyle = .overFullScreen
        searchRSOVC.modalTransitionStyle = .crossDissolve
        searchRSOVC.view.backgroundColor = UIColor.clear
        self.present(searchRSOVC, animated: true)
    }
    private func setupTabBarView() {
        // Create and configure the tab buttons\
        let screenWidth = UIScreen.main.bounds.width
        let itemWidth = Int(screenWidth) / RSOTabItem.allCases.count
        for (index, item) in RSOTabItem.allCases.enumerated() {
            let button = TabBarButton()
            let fontNormal = UIFont.systemFont(ofSize: 11)
            let fontSelected = UIFont.boldSystemFont(ofSize: 11)
            button.setTitleName(item.getTitle(), Font: fontNormal, Color: .white, SelectFont: fontSelected, SelectColor: .white)
            button.setIcon(item.getImages().image)
            button.setSelectedIcon(item.getImages().selectedImage)
            button.addTarget(self, action: #selector(tabButtonTapped(_:)), for: .touchUpInside)
            tabBarView.addSubview(button)
            tabButtons.append(button)
            button.translatesAutoresizingMaskIntoConstraints = false
            button.widthAnchor.constraint(equalTo: tabBarView.widthAnchor, multiplier: 1.0 / CGFloat(RSOTabItem.allCases.count)).isActive = true
            button.topAnchor.constraint(equalTo: tabBarView.topAnchor).isActive = true
            button.bottomAnchor.constraint(equalTo: tabBarView.bottomAnchor).isActive = true
            let screenWidth = UIScreen.main.bounds.width
            let originX = index * itemWidth
            button.leadingAnchor.constraint(equalTo: tabBarView.leadingAnchor, constant: CGFloat(originX)).isActive = true
        }
    }
    @objc private func tabButtonTapped(_ sender: UIButton?) {
        guard let sender = sender, let index = tabButtons.firstIndex(of: sender) else { return }
        // Update the selected tab button
        for (buttonIndex, button) in tabButtons.enumerated() {
            button.isSelected = (buttonIndex == index)
        }
        
        print(tabButtons.count)
        print(index)
        // last tab
        if (tabButtons.count - 1) == index {
            if let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate,
               let window = sceneDelegate.window,
               let rootNavigationController = window.rootViewController as? UINavigationController,
               let mainViewController = rootNavigationController.viewControllers.first as? SideMenuMainViewController {
                mainViewController.showMenu()
                return
            }
        }
        // Remove the current child view controller
        let currentViewController = viewControllers[lastSelectedTabIndex]
        coordinator?.hideChildViewController(currentViewController)
        // Add the new selected child view controller
        let selectedViewController = viewControllers[index]
        coordinator?.showChildViewController(selectedViewController)
        // No need to reload if no changes in tab selection.
        guard lastSelectedTabIndex != index else {
            return
        }
        lastSelectedTabIndex = index
    }
    
    class func presentAsRootController() {
        // Create your RSOTabBarVC instance
       // let rsoTabBarVC = UIViewController.createController(storyBoard: .TabBar, ofType: RSOTabBarViewController.self)
       let moreVC = UIViewController.createController(storyBoard: .TabBar, ofType:  SideMenuMainViewController.self)

        // Set the navigation controller as the root view controller of the window
        AppDelegate.setWindowRoot(viewController: moreVC)

    }
}

