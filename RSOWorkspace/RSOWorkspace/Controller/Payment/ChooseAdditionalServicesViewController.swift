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
    var bookingId: Int = 0
    var selectedServices: [String] = []
    var coordinator: RSOTabBarCordinator?
    var apiResponseData:PaymentRoomBookingResponse?
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var containerView: UIView!
    
    var totalPrice:Double = 0.0
    var vatAmount:Double = 0.0
    var provideRequirementDet = ""
    var additionalServicesArray:[String] = []
    
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
    func checkoutNavigation() {
     /* let type =  paymentTypes[selectedPaymentTypeIndex]
      switch type {
      case .applePay:
        print("applePay")
      case .debitCreditCard:
        print("debitCreditCard")
          var requestModel = PaymentRequestModel()
          requestModel.customerID = UserSessionHelper.shared.getCustomerId()
          requestModel.total = Int(cartServiceManager.getTotal())
          requestModel.email = UserSessionHelper.shared.getUserEmail()
          self.checkoutServiceManager.createOrder(requestModel: requestModel)
      case .tabby:
        print("tabby")
      case .cashOnDelivery:
        GPToastView.shared.show(self.checkoutServiceManager.checkoutReponse?.message ?? "")
        let delayInSeconds = 2.0
        DispatchQueue.main.asyncAfter(deadline: .now() + delayInSeconds) {
          let myOrderVC = UIViewController.createController(storyBoard: .Profile, ofType: MyOrdersViewController.self)
          self.navigationController?.pushViewController(myOrderVC, animated: true)
        }
      case .unknown:
        print("unknown")
      }*/
    }
    func paymentRoomBookingAPI(additionalrequirements :[String], bookingid:Int, requirementdetails:String,totalprice:Double,vatamount:Double) {
        self.eventHandler?(.loading)
        let requestModel = PaymentRoomBookingRequest(additional_requirements: additionalrequirements, booking_id: bookingid, requirement_details: requirementdetails, total_price: totalprice, vatamount: vatamount)
        print("requestModel",requestModel)
        APIManager.shared.request(
            modelType: PaymentRoomBookingResponse.self,
            type: PaymentRoomBookingEndPoint.getBookingOfRooms(requestModel: requestModel)) { response in
                self.eventHandler?(.stopLoading)
                switch response {
                case .success(let response):
                    
                    self.apiResponseData = response
                    var requestModel = NiPaymentRequestModel()
                    requestModel.total = Int(totalprice)
                    requestModel.email = UserHelper.shared.getUserEmail()
                    self.makePayment(requestModel: requestModel)
                    self.eventHandler?(.dataLoaded)
                case .failure(let error):
                    self.eventHandler?(.error(error))
                    DispatchQueue.main.async {
                        //  Unsuccessful
                        RSOToastView.shared.show("\(error.localizedDescription)", duration: 2.0, position: .center)
                    }
                }
            }
    }
    func makePayment(requestModel: NiPaymentRequestModel) {
      APIManager.shared.request(
        modelType: PaymentResponseModel.self,
        type: PaymentRoomBookingEndPoint.payment(requestModel: requestModel)
      ) { response in
        switch response {
        case .success(let response):
            let orderResponse = response.data
            DispatchQueue.main.async {
                self.showCardPaymentUI(orderResponse: orderResponse)
            }
        case .failure(let error):
            DispatchQueue.main.async {
                //  Unsuccessful
                RSOToastView.shared.show("\(error.localizedDescription)", duration: 2.0, position: .center)
            }
        }
      }
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
            return cell
        case .cancelAndRequestButton:
            let cell = tableView.dequeueReusableCell(withIdentifier: cellType.rawValue, for: indexPath) as! CancelAndRequestButtonTableViewCell
            cell.delegate = self
            return cell
        default:
            return UITableViewCell()
            
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: cellType.rawValue, for: indexPath)
        cell.selectionStyle = .none
        return cell
      
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellIdentifiers[indexPath.section].1
    }
}

extension ChooseAdditionalServicesViewController {
    enum Event {
        case loading
        case stopLoading
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProvideRequirementDetailsTableViewCell", for: IndexPath(row: 0, section: 2)) as! ProvideRequirementDetailsTableViewCell
        let details = cell.txtViewrequirnmentDetails.text
        //print("details=", details)
        self.paymentRoomBookingAPI(additionalrequirements: ["Stationary"], bookingid: self.bookingId, requirementdetails: details ?? "", totalprice: totalPrice, vatamount: 0.0)
      
    }
    
    func btnCancelTappedAction() {
        self.navigationController?.popViewController(animated: true)
    }
    
}
extension ChooseAdditionalServicesViewController: CardPaymentDelegate, ApplePayDelegate {

    func paymentDidComplete(with status: PaymentStatus) {
      if(status == .PaymentSuccess) {
        // Payment was successful
          //Booking Saved successfully
          DispatchQueue.main.async {
              RSOToastView.shared.show("Payment successfull", duration: 2.0, position: .center)
          }
      } else if(status == .PaymentFailed) {
         // Payment failed
      } else if(status == .PaymentCancelled) {
        // Payment was cancelled by user
      }
    }


    func authorizationDidComplete(with status: AuthorizationStatus) {
      if(status == .AuthFailed) {
        // Authentication failed
        return
      }
      // Authentication was successful
    }
    
    // On creating an order, call the following method to show the card payment UI
    func showCardPaymentUI(orderResponse: OrderResponse) {
      let sharedSDKInstance = NISdk.sharedInstance
      sharedSDKInstance.showCardPaymentViewWith(cardPaymentDelegate: self,
                                            overParent: self,
                                            for: orderResponse)
    }
  func presentApplePay(orderResponse: OrderResponse) {

  }
}
