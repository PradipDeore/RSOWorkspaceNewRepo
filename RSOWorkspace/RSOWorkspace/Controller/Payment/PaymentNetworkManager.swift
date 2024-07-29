//
//  PaymentNetworkManager.swift
//  RSOWorkspace
//
//  Created by Sumit Aquil on 24/07/24.
//

import Foundation
import NISdk

enum PaymentTypeEntity {
  case desk
  case room
  case office
  case membership
}

class PaymentNetworkManager: CardPaymentDelegate ,ApplePayDelegate{
    
    static let shared = PaymentNetworkManager()
    private init() {}
    var eventHandler: ((_ event: Event) -> Void)?
    var apiResponseData:PaymentRoomBookingResponse?
    var apiOfficeResponseData:PaymentOfficeBookingResponse?
    var requestParameters : ConfirmBookingRequestModel?
    var currentViewController : UIViewController?
    var currentNavigationController: UINavigationController?
    var paymentTypeEntity:PaymentTypeEntity = .room
    var orderResponse: OrderResponse?
    func paymentRoomBookingAPI(additionalrequirements :[String], bookingid:Int, requirementdetails:String,totalprice:Double,vatamount:Double) {
        DispatchQueue.main.async {
            RSOLoader.showLoader()
        }
        let requestModel = PaymentRoomBookingRequest(additional_requirements: additionalrequirements, booking_id: bookingid, requirement_details: requirementdetails, total_price: totalprice, vatamount: vatamount)
        print("requestModel",requestModel)
        APIManager.shared.request(
            modelType: PaymentRoomBookingResponse.self,
            type: PaymentRoomBookingEndPoint.paymentRoombooking(requestModel: requestModel)) { response in
                DispatchQueue.main.async {
                    RSOLoader.removeLoader()
                    switch response {
                    case .success(let response):
                        if response.status.isError {
                            RSOToastView.shared.show(response.message, duration: 2.0, position: .center)
                        } else {
                            self.apiResponseData = response
                            if UserHelper.shared.isGuest() {
                                var requestModel = NiPaymentRequestModel()
                                requestModel.total = Int(totalprice)
                                requestModel.email = UserHelper.shared.getUserEmail()
                                self.makePayment(requestModel: requestModel)
                            } else {
                                RSOToastView.shared.show(response.message, duration: 2.0, position: .center)
                                 self.currentNavigationController?.popToRootViewController(animated: true)
                            }
                            self.eventHandler?(.dataLoaded)
                        }
                    case .failure(let error):
                        self.eventHandler?(.error(error))
                        //  Unsuccessful
                        RSOToastView.shared.show("\(error.localizedDescription)", duration: 2.0, position: .center)
                    }
                }
            }
    }
    func paymentDeskBookingAPI(bookingid:Int, totalprice:Double,vatamount:Double) {
        DispatchQueue.main.async {
            RSOLoader.showLoader()
        }
        let requestModel = PaymentDeskBookingRequest( booking_id: bookingid,  total_price: totalprice, vatamount: vatamount)
        print("requestModel",requestModel)
        APIManager.shared.request(
            modelType: PaymentDeskBookingResponse.self,
            type: PaymentRoomBookingEndPoint.paymentDeskbooking(requestModel: requestModel)) { response in
                DispatchQueue.main.async {
                    RSOLoader.removeLoader()
                    switch response {
                    case .success(let response):
                        if response.status.isError {
                            RSOToastView.shared.show(response.msg, duration: 2.0, position: .center)
                        } else {
                            RSOToastView.shared.show(response.msg, duration: 2.0, position: .center)
                            self.currentNavigationController?.popToRootViewController(animated: true)
                            self.eventHandler?(.dataLoaded)
                        }
                    case .failure(let error):
                        self.eventHandler?(.error(error))
                        //  Unsuccessful
                        RSOToastView.shared.show("\(error.localizedDescription)", duration: 2.0, position: .center)
                    }
                }
            }
    }
    func paymentOfficeBookingAPI(id:Int,totalprice:Double,vatamount:Double) {
        DispatchQueue.main.async {
            RSOLoader.showLoader()
        }
        let requestModel = ShortTermPaymentOfficeBookingRequestModel(id: id, total_price: totalprice, vat_amount: vatamount)
        print("requestModel",requestModel)
        APIManager.shared.request(
            modelType: PaymentOfficeBookingResponse.self,
            type: PaymentRoomBookingEndPoint.paymentOfficebooking(requestModel: requestModel)) { response in
                DispatchQueue.main.async {
                    RSOLoader.removeLoader()
                    switch response {
                    case .success(let response):
                        if response.status.isError {
                            RSOToastView.shared.show(response.msg, duration: 2.0, position: .center)
                        } else {
                            self.apiOfficeResponseData = response
                            if UserHelper.shared.isGuest() {
                                var requestModel = NiPaymentRequestModel()
                                requestModel.total = Int(totalprice)
                                requestModel.email = UserHelper.shared.getUserEmail()
                                self.makePayment(requestModel: requestModel)
                            } else {
                                RSOToastView.shared.show(response.msg, duration: 2.0, position: .center)
                                 self.currentNavigationController?.popToRootViewController(animated: true)
                            }
                            self.eventHandler?(.dataLoaded)
                        }
                    case .failure(let error):
                        self.eventHandler?(.error(error))
                        //  Unsuccessful
                        RSOToastView.shared.show("\(error.localizedDescription)", duration: 2.0, position: .center)
                    }
                }
            }
    }
    
    func makePayment(requestModel: NiPaymentRequestModel) {
        DispatchQueue.main.async {
            RSOLoader.showLoader()
        }
        APIManager.shared.request(
            modelType: PaymentResponseModel.self,
            type: PaymentRoomBookingEndPoint.payment(requestModel: requestModel)
        ) { response in
            DispatchQueue.main.async {
              RSOLoader.removeLoader()
                switch response {
                case .success(let response):
                    let orderResponse = response.data
                    self.orderResponse = orderResponse
                    self.showCardPaymentUI(orderResponse: orderResponse)
                case .failure(let error):
                    //  Unsuccessful
                    RSOToastView.shared.show("\(error.localizedDescription)", duration: 2.0, position: .center)
                }
            }
        }
    }
  func submitMembershipPayment() {
    guard let ref = self.orderResponse?.embeddedData?.payment?.first?.orderReference else { return }
    RSOLoader.showLoader()
    let inputModel = RecurringCallbackRequestModel(ref: ref)
    let requestModel = SelectedMembershipData.shared
    APIManager.shared.request(
        modelType: MembershipResponse.self,
        type: MembershipEndPoint.recurringCallback(requestModel: inputModel)) { [weak self] response in
          DispatchQueue.main.async {
            RSOLoader.removeLoader()
            guard let self = self else { return }
            switch response {
            case .success(let response):
              RSOToastView.shared.show("Membership purchased successfully", duration: 2.0, position: .center)
              self.currentNavigationController?.popToRootViewController(animated: true)
              self.eventHandler?(.dataLoaded)
            case .failure(let error):
              //  Unsuccessful
              RSOToastView.shared.show("\(error.localizedDescription)", duration: 2.0, position: .center)
            }
          }
        }
  }
  func paymentCompletionNavigation() {
    DispatchQueue.main.async {
      switch self.paymentTypeEntity {
      case .desk:
        if let bookingId = self.requestParameters?.meetingId, let totalPrice = self.requestParameters?.deskSubTotal, let vatAmount = self.requestParameters?.deskVatTotal {
          self.paymentDeskBookingAPI(bookingid: bookingId, totalprice: Double(totalPrice), vatamount: Double(vatAmount))
        }
      case .membership:
        self.submitMembershipPayment()
      default:
        RSOToastView.shared.show(self.apiResponseData?.message ?? "Payment Successful", duration: 2.0, position: .center)

        }
      }
  }
    func paymentDidComplete(with status: PaymentStatus) {
        if(status == .PaymentSuccess) {
          self.paymentCompletionNavigation()
        } else if(status == .PaymentFailed) {
            // Payment failed
            DispatchQueue.main.async {
                RSOToastView.shared.show("Payment failed", duration: 2.0, position: .center)
            }
        } else if(status == .PaymentCancelled) {
            // Payment was cancelled by user
            // Payment failed
            DispatchQueue.main.async {
                RSOToastView.shared.show("Payment cancelled", duration: 2.0, position: .center)
            }
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
        
        guard let currentViewController = currentViewController else {
            return
        }
        let sharedSDKInstance = NISdk.sharedInstance
        sharedSDKInstance.showCardPaymentViewWith(cardPaymentDelegate: self,
                                                  overParent: currentViewController,
                                                  for: orderResponse)
    }
    
    func presentApplePay(orderResponse: OrderResponse) {
        
    }
    
}

extension PaymentNetworkManager {
    enum Event {
        case dataLoaded
        case error(Error?)
    }
}
