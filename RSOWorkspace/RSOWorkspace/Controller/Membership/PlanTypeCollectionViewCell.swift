//
//  PlanTypeCollectionViewCell.swift
//  RSOWorkspace
//
//  Created by Pradip Deore on 25/07/24.
//

import UIKit

class SelectedIndexData {
    static let shared = SelectedIndexData()
    private init () {
        
    }
    var collectionIndex = -1
    var tableIndex = -1
}

protocol PlanSelectDelegate: AnyObject {
    func didSelectPlan(index: Int)
}

class PlanTypeCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var mainTitleLabel: UILabel!
    @IBOutlet weak var continueButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var containerView: ShadowedView!
    let planPriceIdentifier = "PlanPriceTableViewCell"
    let planInfoIdentifier = "PlanInfoTableViewCell"
    var selectedIndex = -1
    var priceOptions: [PlanPrice] = []
    weak var planDelegate: PlanSelectDelegate?
    var services: [String] = []
    override func awakeFromNib() {
        super.awakeFromNib()
        tableView.register(UINib(nibName: planPriceIdentifier, bundle: nil), forCellReuseIdentifier: planPriceIdentifier)
        tableView.register(UINib(nibName: planInfoIdentifier, bundle: nil), forCellReuseIdentifier: planInfoIdentifier)
        self.continueButton.isUserInteractionEnabled = false
        self.continueButton.alpha = 0.5
    }
    
    func setData(titleString: String?, priceList:[PlanPrice]?, serviceList: [String]?) {
        self.mainTitleLabel.text = titleString
        self.priceOptions = priceList ?? []
        self.services = serviceList ?? []
        self.tableView.reloadData()
    }
    func clearSelection() {
        self.selectedIndex = -1
        self.tableView.reloadData()
    }
}
extension PlanTypeCollectionViewCell: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return services.count
        }
        return priceOptions.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 70
        }
        return 60
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: planInfoIdentifier, for: indexPath) as! PlanInfoTableViewCell
            cell.messageLabel.text = services[indexPath.row]
            cell.selectionStyle = .none
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: planPriceIdentifier, for: indexPath) as! PlanPriceTableViewCell
            let planPrice = priceOptions[indexPath.row]
            cell.selectionStyle = .none
            // let planInfo = "From AED \(planPrice.price ?? ""), \(planPrice.duration ?? "")"
            // cell.setTextMessage(msg: planInfo)
            let priceText = "AED \(planPrice.price ?? "")"
            let fullText = "From \(priceText)/pp, \(planPrice.duration ?? "")"
            
            // Create an attributed string with the full text
            let attributedString = NSMutableAttributedString(string: fullText)
            
            // Define the range for the price part
            if let priceRange = fullText.range(of: priceText) {
                let nsRange = NSRange(priceRange, in: fullText)
                
                // Use the custom RSOFont utility to get Poppins-Bold font with size 16
                let boldFont = RSOFont.poppins(size: 16, type: .Bold)
                attributedString.addAttribute(.font, value: boldFont, range: nsRange)
            }
            
            // Set the attributed string to the label
            cell.setTextMessage(attributedMsg: attributedString)
            
            cell.setRadioImage(selcted: false)
            if selectedIndex >= 0 && indexPath.row == selectedIndex {
                cell.setRadioImage(selcted: true)
            }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            // logic to handle single selection across collection cells
            SelectedIndexData.shared.collectionIndex = self.tag
            SelectedIndexData.shared.tableIndex = indexPath.row
            //------------------------------------------------
            selectedIndex = indexPath.row
            self.continueButton.isUserInteractionEnabled = true
            self.continueButton.alpha = 1.0
            self.tableView.reloadData()
            self.planDelegate?.didSelectPlan(index: selectedIndex)
        }
    }
}
