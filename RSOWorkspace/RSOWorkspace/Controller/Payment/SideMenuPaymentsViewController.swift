//  SideMenuPaymentsViewController.swift
//  RSOWorkspace
//
//  Created by Sumit Aquil on 18/07/24.
//

import UIKit

class SideMenuPaymentsViewController: UIViewController {
    
    @IBOutlet weak var txtMonths: UITextField!
    @IBOutlet weak var btnSelectMonth: UIButton!
    @IBOutlet weak var monthNamesView: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    let months = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        txtMonths.setUpTextFieldView(rightImageName: "arrowdown")
        monthNamesView.setCornerRadiusForView()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        // Register table view cells using UINib
        tableView.register(UINib(nibName: "PaymentDateTableViewCell", bundle: nil), forCellReuseIdentifier: "PaymentDateTableViewCell")
        tableView.register(UINib(nibName: "PaymentDetailsTableViewCell", bundle: nil), forCellReuseIdentifier: "PaymentDetailsTableViewCell")
        tableView.register(UINib(nibName: "PaymentMethodTableViewCell", bundle: nil), forCellReuseIdentifier: "PaymentMethodTableViewCell")
        tableView.register(UINib(nibName: "PayNowButtonTableViewCell", bundle: nil), forCellReuseIdentifier: "PayNowButtonTableViewCell")
    }
    
    
    @IBAction func btnBackAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)

    }
    @IBAction func btnSelectMonthAction(_ sender: Any) {
        showMonthSelectionActionSheet()
    }
    
    private func showMonthSelectionActionSheet() {
        let actionSheet = UIAlertController(title: "Select Month", message: nil, preferredStyle: .actionSheet)
        
        for month in months {
            let action = UIAlertAction(title: month, style: .default) { [weak self] action in
                self?.txtMonths.text = month
            }
            actionSheet.addAction(action)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        actionSheet.addAction(cancelAction)
        
        // For iPad support
        if let popoverController = actionSheet.popoverPresentationController {
            popoverController.sourceView = self.view
            popoverController.sourceRect = btnSelectMonth.frame
        }
        self.present(actionSheet, animated: true, completion: nil)
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate

extension SideMenuPaymentsViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 1:
            return 4
        default:
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "PaymentDateTableViewCell", for: indexPath)
            cell.selectionStyle = .none
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "PaymentDetailsTableViewCell", for: indexPath)
            cell.selectionStyle = .none
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "PaymentMethodTableViewCell", for: indexPath)
            cell.selectionStyle = .none
            return cell
        case 3:
            let cell = tableView.dequeueReusableCell(withIdentifier: "PayNowButtonTableViewCell", for: indexPath)
            cell.selectionStyle = .none
            return cell
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 3 {
            // Handle Pay Now button tap
            print("Pay Now button tapped")
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return ""
        case 1:
            return "Details"
        case 2:
            return ""
        case 3:
            return ""
        default:
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 112
        }else if indexPath.section == 1{
            return 61
        }else if indexPath.section == 2 {
            return 96
        }
        return 44 // Default row height
    }
}
