//
//  ChooseAdditionalServicesViewController.swift
//  RSOWorkspace
//
//  Created by Sumit Aquil on 07/03/24.
//

import NISdk
import UIKit
import PassKit

enum PaymentType: String {
  case applePay = "Apple Pay"
  case debitCreditCard = "Debit/Credit Card"
  case tabby = "Tabby"
  case cashOnDelivery = "Cash On Delivery"
  case unknown = "Unknown"
}
class ChooseAdditionalServicesViewController: UIViewController {
 
  var selectedServices: [String] = []
  var coordinator: RSOTabBarCordinator?
  var apiResponseData:PaymentRoomBookingResponse?
  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var containerView: UIView!
  
  var bookingId: Int = 0
  var totalPrice:Double = 0.0
  var vatAmount:Double = 0.0
  var provideRequirementDet = ""
  var additionalServicesArray:[String] = []
  var paymentServiceManager = PaymentNetworkManager.shared
  var eventHandler: ((_ event: Event) -> Void)?
  
  private let cellIdentifiers: [(CellType,CGFloat)] = [(.chooseAdditionalServicesLabel,20.0),(.chooseAdditionaServices,60),(.provideRequirementDet,70),(.cancelAndRequestButton,45)]
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupTableView()
    containerView.setCornerRadiusForView()
    setValuesForAdditionalServices()
    containerView.setCornerRadiusForView()
    
  }
  func setValuesForAdditionalServices(){
    self.additionalServicesArray = ["Flipchart","Refreshments","Water Bottles","Stationary"]
  }
  
  private func setupTableView() {
    tableView.dataSource = self
    tableView.delegate = self
    
    navigationController?.navigationBar.isHidden = true
    
    for cellIdentifier in cellIdentifiers {
      let type = cellIdentifier.0
      tableView.register(UINib(nibName: type.rawValue, bundle: nil), forCellReuseIdentifier: type.rawValue)
    }
  }
  @IBAction func btnHideViewTappedAction(_ sender: Any) {
    dismiss(animated: true, completion: nil)
  }
  
}
extension ChooseAdditionalServicesViewController: UITableViewDataSource, UITableViewDelegate {
  
  func numberOfSections(in tableView: UITableView) -> Int {
    return cellIdentifiers.count
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if section == 1{
      return additionalServicesArray.count
    }
    return 1
  }
  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    if section == 1{
      return 10
    }
    return 10
  }
  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    if section == 1 {
      return UIView()
    }
    return UIView()
  }
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cellType = cellIdentifiers[indexPath.section].0
    switch cellType{
    case .chooseAdditionalServicesLabel:
      let labelCell = tableView.dequeueReusableCell(withIdentifier: cellType.rawValue, for: indexPath) as!  SelectMeetingRoomLabelTableViewCell
      labelCell.lblMeetingRoom.text = "Choose Additional Services"
      labelCell.lblMeetingRoom.font = UIFont(name: "Poppins-SemiBold", size: 20.0)
      return labelCell
      
    case .chooseAdditionaServices:
      let cell = tableView.dequeueReusableCell(withIdentifier: cellType.rawValue, for: indexPath) as! ChooseAdditionalServicesTableViewCell
      
      let services = additionalServicesArray[indexPath.row]
      cell.lblServices.text = services
      cell.selectionStyle = .none
      cell.delegate = self
      cell.service = services
      return cell
      
    case . provideRequirementDet:
      let cell = tableView.dequeueReusableCell(withIdentifier: cellType.rawValue, for: indexPath) as! ProvideRequirementDetailsTableViewCell
        cell.selectionStyle = .none
      return cell
    case .cancelAndRequestButton:
      let cell = tableView.dequeueReusableCell(withIdentifier: cellType.rawValue, for: indexPath) as! CancelAndRequestButtonTableViewCell
        cell.selectionStyle = .none
      cell.delegate = self
      return cell
    }
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return cellIdentifiers[indexPath.section].1
  }
}

extension ChooseAdditionalServicesViewController {
  enum Event {
    case dataLoaded
    case error(Error?)
  }
  
  enum CellType: String {
    case chooseAdditionalServicesLabel = "SelectMeetingRoomLabelTableViewCell"
    case chooseAdditionaServices = "ChooseAdditionalServicesTableViewCell"
    case provideRequirementDet = "ProvideRequirementDetailsTableViewCell"
    case cancelAndRequestButton = "CancelAndRequestButtonTableViewCell"
  }
  
}
extension ChooseAdditionalServicesViewController:ChooseAdditionalServicesCellDelegate{
  func didSelect(service: String) {
    selectedServices.append(service)
    print("selected services array when added ",selectedServices)
  }
  
  func didDeselect(service: String) {
    if let index = selectedServices.firstIndex(of: service) {
      selectedServices.remove(at: index)
      print("selected services array when removed",selectedServices)
    }
  }
}
extension ChooseAdditionalServicesViewController:CancelAndRequestButtonTableViewCellDelegate{
  
  func btnRequestTappedAction() {
    
    if UserHelper.shared.isUserExplorer() {
      CurrentLoginType.shared.loginScreenDelegate = self
      LogInViewController.showLoginViewController()
      return
    }
    let details = "RSO booking"
    //print("details=", details)
      paymentServiceManager.paymentTypeEntity = .room
      paymentServiceManager.currentViewController = self
      paymentServiceManager.currentNavigationController = self.navigationController
      paymentServiceManager.paymentRoomBookingAPI(additionalrequirements: selectedServices, bookingid: self.bookingId, requirementdetails: details, totalprice: totalPrice, vatamount: vatAmount)
  }
  
  func btnCancelTappedAction() {
    self.navigationController?.popViewController(animated: true)
  }
  
}

extension ChooseAdditionalServicesViewController: LoginScreenActionDelegate {
  func loginScreenDismissed() {
    DispatchQueue.main.async {
      self.btnRequestTappedAction()
    }
  }
}
