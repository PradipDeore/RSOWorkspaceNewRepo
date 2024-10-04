//
//  PaymentDetailsViewController.swift
//  RSOWorkspace
//
//  Created by Pradip Deore on 25/07/24.
//

import UIKit
import NISdk
class MembershipPaymentDetailsViewController: UIViewController, MembershipNavigable {
  @IBOutlet var continueButton: UIButton!
  @IBOutlet var tableView: UITableView!
  let identifier = "PaymentSummaryTableViewCell"
  let headerIdentifier =  "PaymentSummaryHeaderTableViewCell"
    let termsAndConditionIdentifier = "TermsAndConditionsTableViewCell"
  var membershipNavigationDelegate: MembershipNavigationDelegate?
    var isTermsAccepted = false // This flag will track the checkbox state.

  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.register(UINib(nibName: identifier, bundle: nil), forCellReuseIdentifier: identifier)
      tableView.register(UINib(nibName: headerIdentifier, bundle: nil), forCellReuseIdentifier: headerIdentifier)
      tableView.register(UINib(nibName: termsAndConditionIdentifier, bundle: nil), forCellReuseIdentifier: termsAndConditionIdentifier)


    // Do any additional setup after loading the view.
  }
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    self.tableView.reloadData()
  }
  @IBAction func continueAction(_ sender: Any) {
      // Check if the Terms and Conditions are accepted
             if !isTermsAccepted {
                 RSOToastView.shared.show("Please agree to the Terms and Conditions before proceeding", duration: 2.0, position: .center)
                 return
             }
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
                    PaymentNetworkManager.shared.paymentTypeEntity = .membership
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
    return 3
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      if section == 0 {
          return 1
      }else if section == 2{
          return 1
      }
    return 5
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      if indexPath.section == 0 {
          let cell = tableView.dequeueReusableCell(withIdentifier: headerIdentifier, for: indexPath) as! PaymentSummaryHeaderTableViewCell
          cell.selectionStyle = .none
        
          return cell
      }else if indexPath.section == 1 {
          
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
      }else{
          let cell = tableView.dequeueReusableCell(withIdentifier: termsAndConditionIdentifier, for: indexPath) as! TermsAndConditionsTableViewCell
          cell.selectionStyle = .none
          cell.delegate = self // Set delegate

          return cell
      }
      return UITableViewCell()
    
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
      if indexPath.section == 0 {
          return 75
      } else if indexPath.section == 2 {
          return 63
      }
    return 80 // Default row height
  }
}

extension MembershipPaymentDetailsViewController: TermsAndConditionsDelegate {
    func didToggleTermsCheckbox(isSelected: Bool) {
        isTermsAccepted = isSelected

        // Handle the checkbox selection state
        if isSelected {

            print("Terms and Conditions accepted")
        } else {
            print("Terms and Conditions not accepted")
        }
    }
}
