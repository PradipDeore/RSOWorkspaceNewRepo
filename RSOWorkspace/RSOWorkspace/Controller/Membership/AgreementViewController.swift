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
    var list:[PlanPrice] = []
    var selectedIndex = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        datePicker.minimumDate = Date()
        collectionView.register(UINib(nibName: cellIdentifier, bundle: nil), forCellWithReuseIdentifier: cellIdentifier)
        selectedDate = Date.formatSelectedDate(format: .yyyyMMdd, date: Date())
        SelectedMembershipData.shared.startDate = selectedDate + " 00:00:00"
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        list = SelectedPlanPriceList.shared.list
        selectedIndex = list.count - 1
        collectionView.reloadData()
        
        if selectedIndex >= 0 {
            let numberOfItemsInSection = collectionView.numberOfItems(inSection: 0)
            let indexPath = IndexPath(row: selectedIndex, section: 0)
            if indexPath.item < numberOfItemsInSection {
                collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
            }
        }
        
    }
    @IBAction func continueAction(_ sender: Any) {
        SelectedMembershipData.shared.startDate = selectedDate + " 00:00:00"
        let priceSelected = list[selectedIndex]
        SelectedMembershipData.shared.monthlyCost = priceSelected.price ?? ""
        SelectedMembershipData.shared.planType = priceSelected.duration ?? ""
        SelectedMembershipData.shared.agreementLength = priceSelected.length ?? 0
        membershipNavigationDelegate?.navigateToNextVC()
    }
    @IBAction func selectDate(_ sender: UIDatePicker) {
        let actualselectedDate = sender.date // Date
        selectedDate = Date.formatSelectedDate(format: .yyyyMMdd, date: actualselectedDate)
    }
}
extension AgreementViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return list.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! AgreementCollectionViewCell
        let planPrice = list[indexPath.item]
        if indexPath.row == 0 {
            // Special case for the first item
            if let length = planPrice.length {
                print("Plan length for first item: \(length)")
                cell.durationLabel.text = "per month"
                cell.priceLabel.text = planPrice.price
                cell.typeNameLabel.text = "monthly"
            }
        } else {
            // Use setData for other cells
            cell.setData(planPrice: planPrice)
        }
        
        cell.selectCell(isSelected: false)
        if selectedIndex >= 0 && indexPath.row == selectedIndex {
            cell.selectCell(isSelected: true)
        }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedIndex = indexPath.row
        SelectedPlanPriceList.shared.selectedIndex = selectedIndex
        
        
        collectionView.reloadData()
    }
}
