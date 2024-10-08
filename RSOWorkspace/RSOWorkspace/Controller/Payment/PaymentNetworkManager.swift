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
    var paymentRoomBookingRequestModel: PaymentRoomBookingRequest?
    var orderReference = ""
    var paymnetCallBackResponse:PaymentCallBacklResponse?
    var bookingId: Int = 0
    var totalPrice: Double = 0.0
    var vatAmount: Double = 0.0
    func paymentRoomBookingAPI(additionalrequirements :[String], bookingid:Int, requirementdetails:String,totalprice:Double,vatamount:Double) {
        self.paymentRoomBookingRequestModel = PaymentRoomBookingRequest(additional_requirements: additionalrequirements, booking_id: bookingid, requirement_details: requirementdetails, total: totalprice, vatamount: vatamount)
        
        DispatchQueue.main.async {
            RSOLoader.showLoader()
            if UserHelper.shared.isGuest() || UserHelper.shared.isSocialLoginUser() {
                var requestModel = NiPaymentRequestModel()
                requestModel.total = Int(totalprice)
                requestModel.email = UserHelper.shared.getUserEmail()
                self.makePayment(requestModel: requestModel)
            } else {
                self.submitRoomBooking()
            }
        }
    }
    
    func submitRoomBooking() {
        guard let requestModel = self.paymentRoomBookingRequestModel else  {
            return
        }
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
                            RSOToastView.shared.show(response.message, duration: 2.0, position: .center)
                            if UserHelper.shared.isGuest() || UserHelper.shared.isSocialLoginUser() {
                                self.paymentCallBack(orderRef:self.orderReference)
                                let paymentSuccessVC = UIViewController.createController(storyBoard: .Payment, ofType: PaymentSuccessViewController.self)
                                self.currentNavigationController?.present(paymentSuccessVC, animated: true)
                            }else{
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
        let requestModel = PaymentDeskBookingRequest( bookingid: bookingid,  total_amount: totalprice, vat_amount: vatamount)
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
                            if UserHelper.shared.isGuest() || UserHelper.shared.isSocialLoginUser() {
                                self.paymentCallBack(orderRef:self.orderReference)
                                let paymentSuccessVC = UIViewController.createController(storyBoard: .Payment, ofType: PaymentSuccessViewController.self)
                                self.currentNavigationController?.present(paymentSuccessVC, animated: true)
                            }else{
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
                            RSOToastView.shared.show(response.msg, duration: 2.0, position: .center)
                            if UserHelper.shared.isGuest() || UserHelper.shared.isSocialLoginUser() {
                                self.paymentCallBack(orderRef:self.orderReference)
                                let paymentSuccessVC = UIViewController.createController(storyBoard: .Payment, ofType: PaymentSuccessViewController.self)
                                self.currentNavigationController?.present(paymentSuccessVC, animated: true)
                            }else{
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
                        // Accessing orderReference from the payment object within embeddedData
                        if let paymentData = orderResponse.embeddedData?.payment?.first {
                            self.orderReference = paymentData.orderReference ?? ""
                        } else {
                            self.orderReference = "" // Handle case where payment data is not available
                        }
                        self.showCardPaymentUI(orderResponse: orderResponse)
                    case .failure(let error):
                        RSOToastView.shared.show("\(error.localizedDescription)", duration: 2.0, position: .center)
                    }
                }
            }
        }
    }
    // after payment desk, meeting and room booking call this api
    func paymentCallBack(orderRef:String) {
        let requestModel = PaymentCallBackRequest(ref: orderRef)
      
        DispatchQueue.main.async {
            RSOLoader.showLoader()
            APIManager.shared.request(
                modelType: PaymentCallBacklResponse.self,
                type: PaymentRoomBookingEndPoint.paymentCallBack(requestModel: requestModel)
            ) { response in
                DispatchQueue.main.async {
                    RSOLoader.removeLoader()
                    switch response {
                    case .success(let response):
                        let responsePaymentCallback = response
                        RSOToastView.shared.show(responsePaymentCallback.message, duration: 2.0, position: .center)
                    case .failure(let error):
                        RSOToastView.shared.show("\(error.localizedDescription)", duration: 2.0, position: .center)
                    }
                }
            }
        }
    }
    func submitMembershipPayment() {
        DispatchQueue.main.async {
            RSOLoader.showLoader()
        }
        guard let ref = self.orderResponse?.embeddedData?.payment?.first?.orderReference else { return }
        let membershipDetails = SelectedMembershipData.shared
        let agreementLength = String(membershipDetails.agreementLength)
        let startDate = membershipDetails.startDate
        let inputModel = RecurringCallbackRequestModel(reference: ref, agreementLength: agreementLength, startDate: startDate)
        APIManager.shared.request(
            modelType: RecurringCallBackResponseModel.self,
            type: MembershipEndPoint.recurringCallback(requestModel: inputModel)) { [weak self] response in
                DispatchQueue.main.async {
                    RSOLoader.removeLoader()
                    guard let self = self else { return }
                    switch response {
                    case .success(let response):
                        RSOToastView.shared.show("Membership purchased successfully", duration: 2.0, position: .center)
                        let paymentSuccessVC = UIViewController.createController(storyBoard: .Payment, ofType: PaymentSuccessViewController.self)
                        self.currentNavigationController?.present(paymentSuccessVC, animated: true)
                        //                            self.currentNavigationController?.popToRootViewController(animated: true)
                        //                            self.eventHandler?(.dataLoaded)
                        
                        
                    case .failure(let error):
                        // Unsuccessful
                        RSOToastView.shared.show("\(error.localizedDescription)", duration: 2.0, position: .center)
                    }
                }
            }
    }
    
    func paymentCompletionNavigation() {
        DispatchQueue.main.async {
            switch self.paymentTypeEntity {
            case .desk:
                let bookingId = self.bookingId
                let totalPrice = self.totalPrice
                let vatAmount = self.vatAmount
                self.paymentDeskBookingAPI(bookingid: bookingId, totalprice: totalPrice, vatamount: vatAmount)
            case .membership:
                self.submitMembershipPayment()
            case .room:
                self.submitRoomBooking()
            case .office:
                let bookingId = self.bookingId
                let totalPrice = self.totalPrice
                let vatAmount = self.vatAmount
                self.paymentOfficeBookingAPI(id: bookingId, totalprice:totalPrice, vatamount: vatAmount)
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
    
    //   On creating an order, call the following method to show the card payment UI
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
