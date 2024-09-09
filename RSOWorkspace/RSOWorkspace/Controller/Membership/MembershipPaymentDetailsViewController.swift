//
//  PaymentDetailsViewController.swift
//  RSOWorkspace
//
//  Created by Pradip Deore on 25/07/24.
//

import UIKit

class MembershipPaymentDetailsViewController: UIViewController, MembershipNavigable {
  @IBOutlet var continueButton: UIButton!
  @IBOutlet var tableView: UITableView!
  let identifier = "PaymentSummaryTableViewCell"
    let headerIdentifier =  "PaymentSummaryHeaderTableViewCell"
  var membershipNavigationDelegate: MembershipNavigationDelegate?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.register(UINib(nibName: identifier, bundle: nil), forCellReuseIdentifier: identifier)
      tableView.register(UINib(nibName: headerIdentifier, bundle: nil), forCellReuseIdentifier: headerIdentifier)

    // Do any additional setup after loading the view.
  }
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    self.tableView.reloadData()
  }
  @IBAction func continueAction(_ sender: Any) {
    submitPlan()
  }
  func submitPlan() {
    RSOLoader.showLoader()
    let requestModel = SelectedMembershipData.shared
    APIManager.shared.request(
        modelType: MembershipResponse.self,
        type: MembershipEndPoint.recurringPay(requestModel: requestModel)) { [weak self] response in
          DispatchQueue.main.async {
            RSOLoader.removeLoader()
            guard let self = self else { return }
              
            switch response {
            case .success(let responseObj):
                if let errormsg = responseObj.error, !errormsg.isEmpty  {
                    RSOToastView.shared.show("\(responseObj.message ?? "something bad happened")", duration: 2.0, position: .center)
                }else{
                    var PaymentRequestModel = NiPaymentRequestModel()
                    let floatValue = Float(requestModel.monthlyCost) ?? 0.0
                    PaymentRequestModel.total = Int(floatValue)
                    PaymentRequestModel.email = UserHelper.shared.getUserEmail()
                    PaymentNetworkManager.shared.currentViewController = self
                    PaymentNetworkManager.shared.currentNavigationController = self.navigationController
                    PaymentNetworkManager.shared.makePayment(requestModel: PaymentRequestModel)
                }
            case .failure(let error):
              //  Unsuccessful
              RSOToastView.shared.show("\(error.localizedDescription)", duration: 2.0, position: .center)
            }
          }
        }
  }
}
extension MembershipPaymentDetailsViewController: UITableViewDataSource, UITableViewDelegate {
  
  func numberOfSections(in tableView: UITableView) -> Int {
    return 2
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      if section == 0 {
          return 1
      }
    return 5
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      if indexPath.section == 0 {
          let cell = tableView.dequeueReusableCell(withIdentifier: headerIdentifier, for: indexPath) as! PaymentSummaryHeaderTableViewCell
          cell.selectionStyle = .none
          return cell
      }
      
    let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! PaymentSummaryTableViewCell
    cell.selectionStyle = .none
    
    switch indexPath.row {
    case 0:
      cell.summaryTitleLabel.text = "Package Name"
      cell.summaryValueLabel.text = SelectedMembershipData.shared.packageName
    case 1:
      cell.summaryTitleLabel.text = "Plan Type"
      cell.summaryValueLabel.text = SelectedMembershipData.shared.planType
    case 2:
      cell.summaryTitleLabel.text = "Agreement Length"
      cell.summaryValueLabel.text = "\(SelectedMembershipData.shared.agreementLength) months"
    case 3:
      cell.summaryTitleLabel.text = "Start Date"
     // let date = Date.convertTo(SelectedMembershipData.shared.startDate, givenFormat: .yyyyMMdd, newFormat: .ddMMyyyy)
        let date = Date.convertTo(SelectedMembershipData.shared.startDate, givenFormat: .yyyyMMddPlus, newFormat: .ddMMyyyy)
      cell.summaryValueLabel.text = date
    case 4:
      cell.summaryTitleLabel.text = "Monthly Cost"
      cell.summaryValueLabel.text = SelectedMembershipData.shared.monthlyCost
    default:
      return UITableViewCell()
    }
    return cell
    
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
      if indexPath.section == 0 {
          return 75
      }
    return 80 // Default row height
  }
}

