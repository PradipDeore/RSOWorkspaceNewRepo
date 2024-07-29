//
//  MembershipViewController.swift
//  RSOWorkspace
//
//  Created by Pradip Deore on 25/07/24.
//

import UIKit

protocol MembershipNavigable: AnyObject {
    var membershipNavigationDelegate: MembershipNavigationDelegate? { get set }
}
protocol MembershipNavigationDelegate : AnyObject {
  func navigateToNextVC()
}

class MembershipViewController: UIViewController, RSOTabCoordinated {
  
  @IBOutlet var topbarHeightConstraint: NSLayoutConstraint!
  var coordinator: RSOTabBarCordinator?

  @IBOutlet weak var topBarView: UIView!
  @IBOutlet var containerView: UIView!
  @IBOutlet var collectionView: UICollectionView!
  @IBOutlet var screenNameLabel: UILabel!
  let cellIdentifier = "MembershipButtonCollectionViewCell"
  var viewControllers = [UIViewController]()
  var list: [MembershipTabItem] = []
  var selectedIndex = 0
  var currentNavigationVC: UINavigationController?
  override func viewDidLoad() {
    super.viewDidLoad()
    collectionView.register(UINib(nibName: cellIdentifier, bundle: nil), forCellWithReuseIdentifier: cellIdentifier)
    if !UserHelper.shared.isUserLoggedIn() {
      list = [.planType, .agreementType, .yourDetails, .paymentDetails]
    } else {
      list = [.planType, .agreementType, .paymentDetails]
    }
    
    for item in list {
      let viewController = item.createTabChildController()
      if let membershipVCChild = viewController as? MembershipNavigable {
        membershipVCChild.membershipNavigationDelegate = self
      }
      viewControllers.append(viewController)
    }
    if let firstVC = viewControllers.first {
      currentNavigationVC = UINavigationController(rootViewController: firstVC)
      currentNavigationVC?.isNavigationBarHidden = true
      showChildViewController(currentNavigationVC!)
    }
  }
  func showChildViewController(_ viewController: UIViewController) {
      self.addChild(viewController)
      viewController.didMove(toParent: self)
    self.containerView.addSubview(viewController.view)
      viewController.view.frame = self.containerView.bounds
  }
  func hideChildViewController(_ viewController: UIViewController) {
      viewController.willMove(toParent: nil)
      viewController.view.removeFromSuperview()
      viewController.removeFromParent()
  }
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    self.coordinator?.hideBackButton(isHidden: false)
    self.coordinator?.setTitle(title: "Membership")
  }
}
extension MembershipViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return list.count
  }
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! MembershipButtonCollectionViewCell
    let pageName = list[indexPath.item]
    cell.btnType.tag = indexPath.row
    let tabName = "\(indexPath.row + 1). \(pageName.getButtonTitle())"
    cell.btnType.setTitle(tabName, for: .normal)
    cell.selectButton(selcted: false)
    cell.btnType.addTarget(self, action: #selector(buttonClicked(_:)), for: .touchUpInside)
    cell.btnType.isUserInteractionEnabled = false
    if indexPath.row == selectedIndex {
      cell.selectButton(selcted: true)
    }
    return cell
  }
  @objc func buttonClicked(_ sender: UIButton) {
  
    self.currentNavigationVC?.popToRootViewController(animated: false)
    self.currentNavigationVC?.viewControllers.removeAll()
    showScreen(index: sender.tag)
  }
  
  func showScreen( index: Int) {
    self.selectedIndex = index
    let currentVC = viewControllers[index]
    let pageName = list[index]
    self.currentNavigationVC?.pushViewController(currentVC, animated: false)
       self.collectionView.reloadData()
    self.screenNameLabel.text = pageName.getScreenTitle()
  }
  
  func moveToNextScreen() {
    if self.selectedIndex >= 0 && self.selectedIndex < list.count {
      showScreen(index: self.selectedIndex + 1)
    }
  }
}
extension MembershipViewController: MembershipNavigationDelegate {
  func navigateToNextVC() {
    DispatchQueue.main.async {
      self.moveToNextScreen()
    }
  }
}
