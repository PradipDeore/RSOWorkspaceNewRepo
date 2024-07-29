//
//  AgreementViewController.swift
//  RSOWorkspace
//
//  Created by Pradip Deore on 25/07/24.
//

import UIKit

class AgreementViewController: UIViewController, MembershipNavigable {

  @IBOutlet var continueButton: UIButton!
  @IBOutlet var datePicker: UIDatePicker!
  @IBOutlet var collectionView: UICollectionView!
  let cellIdentifier = "AgreementCollectionViewCell"
  var membershipNavigationDelegate: MembershipNavigationDelegate?

  var selectedDate = ""
  var list:[PlanPrice] = [PlanPrice(price: "3000", duration: "6 month", length: 1), PlanPrice(price: "6000", duration: "12 month", length: 5)]
  var selectedIndex = -1
  override func viewDidLoad() {
        super.viewDidLoad()
    datePicker.minimumDate = Date()
    self.continueButton.isUserInteractionEnabled = false
    self.continueButton.alpha = 0.5
    collectionView.register(UINib(nibName: cellIdentifier, bundle: nil), forCellWithReuseIdentifier: cellIdentifier)

    }
  @IBAction func continueAction(_ sender: Any) {
    SelectedMembershipData.shared.startDate = selectedDate
    membershipNavigationDelegate?.navigateToNextVC()
  }
  @IBAction func selectDate(_ sender: UIDatePicker) {
    let actualselectedDate = sender.date // Date
    selectedDate = Date.formatSelectedDate(format: .yyyyMMdd, date: actualselectedDate)
    if selectedIndex >= 0 {
      self.continueButton.isUserInteractionEnabled = true
      self.continueButton.alpha = 1.0
    }
  }
}
extension AgreementViewController: UICollectionViewDelegate, UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return list.count
  }
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! AgreementCollectionViewCell
    let planPrice = list[indexPath.item]
    cell.setData(planPrice: planPrice)
    cell.selectCell(isSelected: false)
    if selectedIndex >= 0 && indexPath.row == selectedIndex {
      cell.selectCell(isSelected: true)
    }
    return cell
  }
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    selectedIndex = indexPath.row
    collectionView.reloadData()
    if selectedDate.isEmpty == false {
      self.continueButton.isUserInteractionEnabled = true
      self.continueButton.alpha = 1.0
    }
  }
}
