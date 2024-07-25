//
//  PlanTypeCollectionViewCell.swift
//  RSOWorkspace
//
//  Created by Pradip Deore on 25/07/24.
//

import UIKit

class PlanTypeCollectionViewCell: UICollectionViewCell {
  @IBOutlet weak var mainTitleLabel: UILabel!
  @IBOutlet weak var continueButton: UIButton!
  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var containerView: ShadowedView!
  let planPriceIdentifier = "PlanPriceTableViewCell"
  let planInfoIdentifier = "PlanInfoTableViewCell"
  var selectedIndex = -1
  var priceOptions: [String]? {
          didSet {
              tableView.reloadData()
          }
      }
    override func awakeFromNib() {
        super.awakeFromNib()
      tableView.register(UINib(nibName: planPriceIdentifier, bundle: nil), forCellReuseIdentifier: planPriceIdentifier)
      tableView.register(UINib(nibName: planInfoIdentifier, bundle: nil), forCellReuseIdentifier: planInfoIdentifier)
    }

  @IBAction func continuePlanSelectAction(_ sender: Any) {
  }
}
extension PlanTypeCollectionViewCell: UITableViewDelegate, UITableViewDataSource {
  func numberOfSections(in tableView: UITableView) -> Int {
    return 2
  }
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if section == 0 {
      return 1
    }
    return priceOptions?.count ?? 0
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    if indexPath.section == 0 {
      return 140
    }
    return 80
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    if indexPath.section == 0 {
      let cell = tableView.dequeueReusableCell(withIdentifier: planInfoIdentifier, for: indexPath) as! PlanInfoTableViewCell
      cell.selectionStyle = .none
      return cell
    } else {
      let cell = tableView.dequeueReusableCell(withIdentifier: planPriceIdentifier, for: indexPath) as! PlanPriceTableViewCell
      if let list = priceOptions {
        cell.setTextMessage(msg: list[indexPath.row])
      }
      cell.setRadioImage(selcted: false)
      if selectedIndex >= 0 && indexPath.row == selectedIndex {
        cell.setRadioImage(selcted: true)
      }
      return cell
    }
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    if indexPath.section == 1 {
      selectedIndex = indexPath.row
      self.tableView.reloadData()
    }
  }
}
