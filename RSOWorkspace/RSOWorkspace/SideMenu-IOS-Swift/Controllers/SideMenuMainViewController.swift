//
//  ViewController.swift
//  SideMenu-IOS-Swift
//
//  Created by apple on 12/01/22.
//

import UIKit

class SideMenuMainViewController: UIViewController,RSOTabCoordinated {
    
    var coordinator: RSOTabBarCordinator?
    
    private var sideMenuViewController: SideMenuSubViewController!
    private var sideMenuRevealWidth: CGFloat = 300
    private var paddingForRotation: CGFloat = 110
    private var isExpanded: Bool = false
    private var revealFromLeft: Bool = false
    private var sideMenuTrailingConstraint: NSLayoutConstraint!
    private var sideMenuShadowView: UIView!
    private var draggingIsEnabled: Bool = false
    private var panBaseLocation: CGFloat = 0.0
    private var revealSideMenuOnTop: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSideMenu()
    }
    
    
    private func setupSideMenu() {
        addShadowView()
        addSideMenuViewController()
        addDefaultMainViewController()
    }
    private func addShadowView() {
        sideMenuShadowView = UIView(frame: view.bounds)
        sideMenuShadowView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        sideMenuShadowView.backgroundColor = .black
        sideMenuShadowView.alpha = 0.0
        //sideMenuShadowView.isHidden = true
        if revealSideMenuOnTop {
            view.insertSubview(sideMenuShadowView, at: 1)
        }
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTapGesture))
        tapGestureRecognizer.numberOfTapsRequired = 1
        tapGestureRecognizer.delegate = self
        sideMenuShadowView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    private func addSideMenuViewController() {
        sideMenuViewController = UIViewController.createController(storyBoard: .TabBar, ofType: SideMenuSubViewController.self)
        sideMenuViewController.defaultHighlightedCell = 0
        sideMenuViewController.delegate = self
        view.insertSubview(sideMenuViewController!.view, at: revealSideMenuOnTop ? 2 : 0)
        addChild(sideMenuViewController!)
        sideMenuViewController!.didMove(toParent: self)
        
        sideMenuViewController.view.translatesAutoresizingMaskIntoConstraints = false
        var val = -sideMenuRevealWidth - paddingForRotation
        if !revealFromLeft {
            val = sideMenuRevealWidth + paddingForRotation
        }
        sideMenuTrailingConstraint = sideMenuViewController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: val)
        print("sideMenuTrailingConstraint val=", val)
        sideMenuTrailingConstraint.isActive = revealSideMenuOnTop
        NSLayoutConstraint.activate([
            sideMenuViewController.view.widthAnchor.constraint(equalToConstant: sideMenuRevealWidth),
            sideMenuViewController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            sideMenuViewController.view.topAnchor.constraint(equalTo: view.topAnchor)
        ])
    }
    
    private func addDefaultMainViewController() {
        let vc = UIViewController.createController(storyBoard: .TabBar, ofType: RSOTabBarViewController.self)
        view.insertSubview(vc.view, at: revealSideMenuOnTop ? 0 : 1)
        addChild(vc)
        
        if !revealSideMenuOnTop {
            if isExpanded {
                vc.view.frame.origin.x = sideMenuRevealWidth
            }
            if sideMenuShadowView != nil {
                vc.view.addSubview(sideMenuShadowView)
            }
        }
        vc.view.frame = self.view.frame
        vc.didMove(toParent: self)
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate { _ in
            self.sideMenuTrailingConstraint.constant = self.isExpanded ? 0 : (-self.sideMenuRevealWidth - self.paddingForRotation)
        }
    }
    private func sideMenuState(expanded: Bool) {
        expanded ? showMenu() : hideMenu()
    }
    
    func showMenu() {
        //sideMenuShadowView.isHidden = false
        UIView.animate(withDuration: 0.5, animations: {
            self.sideMenuShadowView.alpha = 0.4
            if self.revealFromLeft {
                self.sideMenuTrailingConstraint.constant = 0
            } else {
                if self.sideMenuViewController.view.superview == nil {
                    self.view.insertSubview(self.sideMenuViewController.view, at: self.revealSideMenuOnTop ? 2 : 0)
                }
                self.sideMenuTrailingConstraint.constant = (self.paddingForRotation)
            }
            self.view.layoutIfNeeded()
        }) { [self] _ in
            self.isExpanded = true
        }
    }
    
    func hideMenu() {
        // sideMenuShadowView.isHidden = true
        UIView.animate(withDuration: 0.5, animations: {
            self.sideMenuShadowView.alpha = 0.0
            if self.revealFromLeft {
                self.sideMenuTrailingConstraint.constant = -(self.sideMenuRevealWidth + self.paddingForRotation)
            } else {
                self.sideMenuTrailingConstraint.constant = (self.sideMenuRevealWidth + self.paddingForRotation)
            }
            self.view.layoutIfNeeded()
        }) { _ in
            self.isExpanded = false

        }
    }
    @objc private func handleTapGesture(sender: UITapGestureRecognizer) {
        if isExpanded {
            sideMenuState(expanded: false)
        }
    }
}

extension SideMenuMainViewController: SideMenuViewControllerDelegate {
    
    func selectedCell(_ row: Int,menuTitle title:String) {
        DispatchQueue.main.async { self.sideMenuState(expanded: false) }
      let menuNavVC = self.coordinator?.getInnerNavigationVC() ?? self.navigationController
      self.coordinator?.hideBackButton(isHidden: true)
      self.coordinator?.hideTopViewForHome(isHidden: true)
        switch title {
            
        case "My Profile":
            let profileVC = UIViewController.createController(storyBoard: .Profile, ofType: ProfileViewController.self)
          menuNavVC?.pushViewController(profileVC, animated: true)
        case "Dashboard":
            RSOTabBarViewController.presentAsRootController()
        case "Schedule Visitors": // Scheduled Visitors
            let scheduleVisitorsVC = UIViewController.createController(storyBoard: .VisitorManagement, ofType: ScheduleVisitorsViewController.self)
          menuNavVC?.pushViewController(scheduleVisitorsVC, animated: true)
       
        case "My Visitors":
            let myvisitorsDetailsVC = UIViewController.createController(storyBoard: .VisitorManagement, ofType: MyVisitorsViewController.self)
          menuNavVC?.pushViewController(myvisitorsDetailsVC, animated: true)
       
        case "Payments":
            let paymentsVC = UIViewController.createController(storyBoard: .Payment, ofType: SideMenuPaymentsViewController.self)
          menuNavVC?.pushViewController(paymentsVC, animated: true)
       
        case "Amenities":
            let amenitiesVC = UIViewController.createController(storyBoard: .Feedback, ofType: AmenitiesViewController.self)
          menuNavVC?.pushViewController(amenitiesVC, animated: true)
       
        case "Feedback":
            let feedbackVC = UIViewController.createController(storyBoard: .Feedback, ofType: FeedbackViewController.self)
          menuNavVC?.pushViewController(feedbackVC, animated: true)
       
        case "FAQs":
            let faqVC = UIViewController.createController(storyBoard: .Feedback, ofType: FAQViewController.self)
          menuNavVC?.pushViewController(faqVC, animated: true)
        
        case "Locations":
            let locationVC = UIViewController.createController(storyBoard: .Feedback, ofType: LocationViewController.self)
          menuNavVC?.pushViewController(locationVC, animated: true)
       
        case "About Us":
            let aboutUsVC = UIViewController.createController(storyBoard: .Feedback, ofType: RSOWorkspaceViewController.self)
          menuNavVC?.pushViewController(aboutUsVC, animated: true)
           // Logout
        case "Logout":
            self.logout()
        default:
            break
        }
    }
    func logout() {
        let alertController = UIAlertController(title: "Logout", message: "Are you sure you want to logout?", preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        let logoutAction = UIAlertAction(title: "Logout", style: .destructive) { _ in
            RSOToken.shared.clearAll()
            UserHelper.shared.clearUser()
            GetStartedViewController.presentAsRootController()
        }
        alertController.addAction(logoutAction)
        self.present(alertController, animated: true, completion: nil)
    }
}

extension SideMenuMainViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        return !(touch.view?.isDescendant(of: sideMenuViewController.view) ?? false)
    }
}

