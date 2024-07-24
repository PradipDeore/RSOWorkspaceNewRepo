//
//  PaymentNetworkManager.swift
//  RSOWorkspace
//
//  Created by Sumit Aquil on 24/07/24.
//

import Foundation
import NISdk

class PaymentNetworkManager: CardPaymentDelegate ,ApplePayDelegate{
    
    static let shared = PaymentNetworkManager()
    private init() {}
    var eventHandler: ((_ event: Event) -> Void)?
    var apiResponseData:PaymentRoomBookingResponse?
    var requestParameters : ConfirmBookingRequestModel?
    var currentViewController : UIViewController?
    var isDeskPayment = false
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
                            /*DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                             self.navigationController?.popToRootViewController(animated: true)
                             }*/
                        } else {
                            self.apiResponseData = response
                            if UserHelper.shared.isGuest() {
                                var requestModel = NiPaymentRequestModel()
                                requestModel.total = Int(totalprice)
                                requestModel.email = UserHelper.shared.getUserEmail()
                                self.makePayment(requestModel: requestModel)
                            } else {
                                RSOToastView.shared.show(response.message, duration: 2.0, position: .center)
                                /*DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                                 self.navigationController?.popToRootViewController(animated: true)
                                 }*/
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
                            /*DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                             self.navigationController?.popToRootViewController(animated: true)
                             }*/
                        } else {
                          if self.isDeskPayment {
                            RSOToastView.shared.show(response.msg, duration: 2.0, position: .center)
                          }
                            /*DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                             self.navigationController?.popToRootViewController(animated: true)
                             }*/
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
                    self.showCardPaymentUI(orderResponse: orderResponse)
                case .failure(let error):
                    //  Unsuccessful
                    RSOToastView.shared.show("\(error.localizedDescription)", duration: 2.0, position: .center)
                }
            }
        }
    }
    
    
    func paymentDidComplete(with status: PaymentStatus) {
        if(status == .PaymentSuccess) {
            // Payment was successful
            DispatchQueue.main.async {
              if self.isDeskPayment {
                if let bookingId = self.requestParameters?.meetingId, let totalPrice = self.requestParameters?.deskSubTotal, let vatAmount = self.requestParameters?.deskVatTotal {
                  self.paymentDeskBookingAPI(bookingid: bookingId, totalprice: Double(totalPrice), vatamount: Double(vatAmount))
                }
              } else {
                RSOToastView.shared.show(self.apiResponseData?.message ?? "Payment Successful", duration: 2.0, position: .center)
              }
            }
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
