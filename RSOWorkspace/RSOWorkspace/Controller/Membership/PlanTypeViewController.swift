//
//  PlanTypeViewController.swift
//  RSOWorkspace
//
//  Created by Pradip Deore on 25/07/24.
//

import UIKit
import CenteredCollectionView

class PlanTypeViewController: UIViewController, MembershipNavigable {
  @IBOutlet var collectionView: UICollectionView!
  let cellIdentifier = "PlanTypeCollectionViewCell"
  var planSelectedIndex = 0
  var membershipNavigationDelegate: MembershipNavigationDelegate?
  var list: [MembershipData] = []
  var centeredCollectionViewFlowLayout: CenteredCollectionViewFlowLayout!
  let cellPercentWidth: CGFloat = 0.8
  override func viewDidLoad() {
    super.viewDidLoad()
    self.fetchMembershipPlan()
    collectionView.register(UINib(nibName: cellIdentifier, bundle: nil), forCellWithReuseIdentifier: cellIdentifier)
    
    // Get the reference to the `CenteredCollectionViewFlowLayout` (REQUIRED STEP)
    centeredCollectionViewFlowLayout = collectionView.collectionViewLayout as! CenteredCollectionViewFlowLayout
    
    // Modify the collectionView's decelerationRate (REQUIRED STEP)
    collectionView.decelerationRate = .fast
    
    // Assign delegate and data source
    collectionView.delegate = self
    collectionView.dataSource = self

    // Configure the required item size (REQUIRED STEP)
    centeredCollectionViewFlowLayout.itemSize = CGSize(
      width: collectionView.frame.size.width-40,
      height: collectionView.frame.size.height * 0.7
    )
    
    // Configure the optional inter item spacing (OPTIONAL STEP)
    centeredCollectionViewFlowLayout.minimumLineSpacing = 0
  
  }
  func fetchMembershipPlan() {
    RSOLoader.showLoader()
    APIManager.shared.request(
      modelType: MembershipResponse.self,
      type: MembershipEndPoint.getPlans) { [weak self] response in
        DispatchQueue.main.async {
          RSOLoader.removeLoader()
          guard let self = self else { return }
          switch response {
          case .success(let response):
              // Print the response for debugging
            print("API Response MembershipPlan: \(response)")
            self.list = response.data ?? []
            self.collectionView.reloadData()
          case .failure(let error):
            //  Unsuccessful
            RSOToastView.shared.show("\(error.localizedDescription)", duration: 2.0, position: .center)
          }
        }
      }
  }
  @objc func selectPlanAction(_ sender: UIButton) {
    let planSelected = list[sender.tag]
    SelectedMembershipData.shared.packageName = planSelected.name ?? ""
    let priceSelected = planSelected.getDistinctPlanPriceList()[planSelectedIndex]
    let durationSelected = priceSelected.duration ?? ""
    SelectedPlanPriceList.shared.selectedDuration = durationSelected
    SelectedPlanPriceList.shared.list = planSelected.matchingPlanPriceList(for: durationSelected)
    
    SelectedPlanPriceList.shared.selectedIndex = planSelectedIndex
    SelectedMembershipData.shared.id = planSelected.id ?? 0
    membershipNavigationDelegate?.navigateToNextVC()
  }
  func updateCellSelection() {
    // Get the index paths of the visible cells
    let visibleIndexPaths = collectionView.indexPathsForVisibleItems
    
    // Iterate through each visible cell and update its selection state
    for indexPath in visibleIndexPaths {
      if let cell = collectionView.cellForItem(at: indexPath) as? PlanTypeCollectionViewCell {
        if cell.tag == SelectedIndexData.shared.collectionIndex {
          cell.continueButton.isUserInteractionEnabled = true
          cell.continueButton.alpha = 1.0
        } else {
          cell.continueButton.isUserInteractionEnabled = false
          cell.continueButton.alpha = 0.5
          cell.clearSelection()
        }
      }
    }
  }
  
}
extension PlanTypeViewController: UICollectionViewDelegate, UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return list.count
  }
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! PlanTypeCollectionViewCell
    
    let option = list[indexPath.item]
    cell.planDelegate = self
    cell.tag = indexPath.item
    cell.continueButton.tag = indexPath.item
    cell.setData(titleString: option.name, priceList: option.getDistinctPlanPriceList(), serviceList: option.services)
    cell.continueButton.addTarget(self, action: #selector(selectPlanAction(_:)), for: .touchUpInside)
    
    if cell.tag == SelectedIndexData.shared.collectionIndex {
      
    } else {
      cell.clearSelection()
    }
    return cell
  }
}
extension PlanTypeViewController {
  enum Event {
    case dataLoaded
    case error(Error?)
  }
}
extension PlanTypeViewController: PlanSelectDelegate {
  func didSelectPlan(index: Int) {
    self.planSelectedIndex = index
  }
}

extension PlanTypeViewController {
  func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
    updateCellSelection()
  }
  
  func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
    if !decelerate {
      updateCellSelection()
    }
  }
  
  func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
    updateCellSelection()
  }
}
