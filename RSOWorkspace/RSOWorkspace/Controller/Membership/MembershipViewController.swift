//
//  MembershipViewController.swift
//  RSOWorkspace
//
//  Created by Pradip Deore on 25/07/24.
//

import UIKit

class MembershipViewController: UIViewController {
  
  @IBOutlet var topbarHeightConstraint: NSLayoutConstraint!
  
  @IBOutlet weak var topBarView: UIView!
  @IBOutlet var containerView: UIView!
  @IBOutlet var collectionView: UICollectionView!
  @IBOutlet var screenNameLabel: UILabel!
  let cellIdentifier = "MembershipButtonCollectionViewCell"
  var viewControllers = [UIViewController]()
  var list: [MembershipTabItem] = [.planType, .agreementType, .yourDetails, .paymentDetails]
  var selectedIndex = 0
  var currentNavigationVC: UINavigationController?
  override func viewDidLoad() {
    super.viewDidLoad()
    collectionView.register(UINib(nibName: cellIdentifier, bundle: nil), forCellWithReuseIdentifier: cellIdentifier)

    for item in list {
      let viewController = item.createTabChildController()
      viewControllers.append(viewController)
    }
    if let firstVC = viewControllers.first {
      currentNavigationVC = UINavigationController(rootViewController: firstVC)
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
}
extension MembershipViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return list.count
  }
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! MembershipButtonCollectionViewCell
    let pageName = list[indexPath.item]
    cell.btnType.tag = indexPath.row
    cell.btnType.setTitle(pageName.getButtonTitle(), for: .normal)
    cell.selectButton(selcted: false)
    cell.btnType.addTarget(self, action: #selector(buttonClicked(_:)), for: .touchUpInside)
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
