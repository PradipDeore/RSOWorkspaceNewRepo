//
//  PaymentViewController.swift
//  RSOWorkspace
//
//  Created by Sumit Aquil on 06/03/24.
//

import UIKit

//
//  PaymentViewController.swift
//  RSOWorkspace
//
//  Created by Sumit Aquil on 06/03/24.
//

import UIKit

enum BookingType {
    case meetingRoom
    case desk
    case office
}
class PaymentViewController: UIViewController {
    
    var coordinator: RSOTabBarCordinator?
    var bookingId: Int = 0
    @IBOutlet weak var tableView: UITableView!
    var getCardDetailsResponseData: [GetCardDetails] = []
    var eventHandler: ((_ event: Event) -> Void)?
    var paymentServiceManager = PaymentNetworkManager.shared
    var requestParameters: ConfirmBookingRequestModel?
    var intHoursMeetingRoom = 0
    var totalPriceMeetingRoom: Double = 0.0
    var vatAmountMeetingRoom: Double = 0.0
    var intHoursDesk = 0
    var totalPriceDesk: Double = 0.0
    var vatAmountDesk: Double = 0.0
    var intHoursOffice = 0
    var totalPriceOffice: Double = 0.0
    var vatAmountOffice: Double = 0.0
    
    var officeName = ""
    var bookingType: BookingType = .meetingRoom
    var couponData: [CouponDetails] = []
    private var cellIdentifiers: [(CellType, CGFloat)] = [
        (.selectMeetingRoomLabel, 20.0),
        (.meetingTime, 80),
        (.amenityPrice, 50),
        (.totalCell, 191),
        (.discount, 60),
        (.paymentMethods, 97),
        (.buttonPayNow, 40)
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCellIdentifiers()
        setupTableView()
        coordinator?.hideBackButton(isHidden: false)
        getCardDetails()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tableView.reloadData()
    }
    private func setupCellIdentifiers() {
        switch bookingType {
        case .office:
            cellIdentifiers.insert((.officePriceDetails, 185), at: 2)
        case .desk, .meetingRoom:
            cellIdentifiers.insert((.meetingRoomPrice, 40), at: 2)
        }
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
    
    private func applyCouponAPI(couponCode: String) {
        APIManager.shared.request(
            modelType: CouponDetailsResponseModel.self,
            type: PaymentRoomBookingEndPoint.applyCoupon) { response in
                switch response {
                case .success(let response):
                    self.couponData = response.data
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                    self.eventHandler?(.dataLoaded)
                case .failure(let error):
                    self.eventHandler?(.error(error))
                }
            }
    }
    private func getCardDetails() {
      DispatchQueue.main.async {
        RSOLoader.showLoader()
      }
        APIManager.shared.request(
            modelType: GetCardDetailsResponseModel.self,
            type: PaymentMethodEndPoint.getCardDetail) { response in
                switch response {
                case .success(let response):
                    self.getCardDetailsResponseData = response.data ?? []
                    print ("getCardDetailsResponseData",self.getCardDetailsResponseData)
                    DispatchQueue.main.async {
                      RSOLoader.removeLoader()
                        self.tableView.reloadData()
                    }
                    self.eventHandler?(.dataLoaded)
                case .failure(let error):
                    self.eventHandler?(.error(error))
                  DispatchQueue.main.async {
                    RSOLoader.removeLoader()
                  }
                }
            }
    }
}

extension PaymentViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return cellIdentifiers.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let cellType = cellIdentifiers[section].0
        switch cellType {
        case .amenityPrice:
            return self.requestParameters?.amenityArray.count ?? 0
        case .discount:
            return couponData.isEmpty ? 1 : couponData.count
        case .meetingRoomPrice:
            if bookingType == .desk {
                return self.requestParameters?.deskList.count ?? 0
            }else if  bookingType == .meetingRoom{
                return 1
            }
            return 0
        case .officePriceDetails:
            if bookingType == .office {
                return 1
            }
            return 0
        case .paymentMethods:
                return !UserHelper.shared.isGuest() ? 0 : 1
        default:
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellType = cellIdentifiers[indexPath.section].0
        
        switch cellType {
        case .selectMeetingRoomLabel:
            let cell = tableView.dequeueReusableCell(withIdentifier: cellType.rawValue, for: indexPath)
            if let labelCell = cell as? SelectMeetingRoomLabelTableViewCell {
                labelCell.lblMeetingRoom.text = "Payment"
                labelCell.lblMeetingRoom.font = UIFont(name: "Poppins-SemiBold", size: 20.0)
            }
            return cell
            
        case .meetingTime:
            let cell = tableView.dequeueReusableCell(withIdentifier: cellType.rawValue, for: indexPath) as! MeetingTimeTableViewCell
            if let startTime = self.requestParameters?.displayStartTime, let endTime = self.requestParameters?.displayendTime {
                cell.txtTime.text = "\(startTime) - \(endTime)"
            } else {
                cell.txtTime.text = "Unavailable"
            }
            if let floathours = self.requestParameters?.timeDifferece {
                intHoursMeetingRoom = Int(floathours)
            }
            cell.lblHours.text = "\(intHoursMeetingRoom)"
            return cell
            
        case .meetingRoomPrice:
            let cell = tableView.dequeueReusableCell(withIdentifier: cellType.rawValue, for: indexPath) as! MeetingRoomPriceTableViewCell
            if let obj = self.requestParameters {
                if bookingType == .desk{
                    let desk = obj.deskList[indexPath.row]
                    cell.lblMeetingRoomName.text = desk.name
                    let price = Float(desk.price )
                    cell.lblmeetingRoomprice.text = "\(price ?? 00) "
                    cell.lblHours.text = "\(Int(obj.timeDifferece))"
                    cell.lbltotalPrice.text = "\((price ?? 0.0) * obj.timeDifferece)"
                    
                } else {
                    let meetingRoomName = obj.meetingRoom
                    cell.lblMeetingRoomName.text = meetingRoomName
                    let roomPrice = obj.roomprice.integerValue ?? 0
                    cell.lblmeetingRoomprice.text = "\(roomPrice)"
                    cell.lblHours.text = "\(Int(obj.timeDifferece))"
                    cell.lbltotalPrice.text = "\(obj.totalOfMeetingRoom)"
                }
            }
            return cell
        case .officePriceDetails:
            let cell = tableView.dequeueReusableCell(withIdentifier: cellType.rawValue, for: indexPath) as! OfficeTypeTableViewCell
            if let obj = self.requestParameters {
                if bookingType == .office{
                    cell.lblOfficeName.text = obj.meetingRoom
                    cell.lblNoOfSeats.text = "\(obj.noOfSeats)"
                    let officePrice = obj.roomprice.integerValue ?? 0
                    cell.lblOfficePrice.text = "\(officePrice)"
                    cell.lblofficeHours.text = "\(obj.totalHrs)"
                    cell.lbltotalPrice.text = "\((officePrice) * obj.totalHrs)"
                }
            }
            return cell
            
        case .amenityPrice:
            let cell = tableView.dequeueReusableCell(withIdentifier: cellType.rawValue, for: indexPath) as! AmenityPriceTableViewCell
            if let amenity = self.requestParameters?.amenityArray[indexPath.row] {
                cell.lblAmenityName.text = amenity.name
                let amenityPriceInt = amenity.price?.integerValue ?? 0
                cell.lblAmenityPrice.text = "\(amenityPriceInt)"
                cell.lblHours.text = "\(Int(self.requestParameters?.timeDifferece ?? 0))"
                cell.lblTotal.text = "\(self.requestParameters?.totalOfAmenity ?? 0)"
            }
            return cell
            
        case .totalCell:
            let cell = tableView.dequeueReusableCell(withIdentifier: cellType.rawValue, for: indexPath) as! TotalTableViewCell
            if let obj = self.requestParameters {
                switch bookingType {
                case .desk:
                    cell.lblSubTotal.text = "\(obj.deskSubTotal)"
                    cell.lblVat.text = "\(obj.deskVatTotal)"
                    vatAmountDesk = Double(obj.deskVatTotal)
                    cell.lblTotalPrice.text = "\(obj.deskFinalTotal)"
                    totalPriceDesk = Double(obj.deskFinalTotal)
                case .office:
                    cell.lblSubTotal.text = "\(obj.officeSubTotal)"
                    cell.lblVat.text = "\(obj.officeVatTotal)"
                    vatAmountOffice = Double(obj.officeVatTotal)
                    cell.lblTotalPrice.text = "\(obj.officeFinalTotal)"
                    totalPriceOffice = Double(obj.officeFinalTotal)
                default:
                    cell.lblSubTotal.text = "\(obj.subTotal)"
                    cell.lblVat.text = "\(obj.calculatedVat)"
                    vatAmountMeetingRoom = Double(obj.calculatedVat)
                    cell.lblTotalPrice.text = "\(obj.finalTotal)"
                    totalPriceMeetingRoom = Double(obj.finalTotal)
                }
            }
            return cell
            
        case .discount:
            let cell = tableView.dequeueReusableCell(withIdentifier: cellType.rawValue, for: indexPath) as! DiscountCodeTableViewCell
            if !couponData.isEmpty {
                let coupon = couponData[indexPath.row]
                cell.setData(item: coupon)
                cell.applyCouponAction = {
                    self.applyCouponAPI(couponCode: coupon.couponCode)
                }
            } else {
                cell.applyCouponAction = {
                    guard let couponCode = cell.txtDiscount.text, !couponCode.isEmpty else {
                        // Handle empty text field
                        return
                    }
                    self.applyCouponAPI(couponCode: couponCode)
                }
            }
            return cell
            
        case .paymentMethods:
            let cell = tableView.dequeueReusableCell(withIdentifier: cellType.rawValue, for: indexPath) as! PaymentMethodTableViewCell
            cell.selectionStyle = .none
            cell.cardDetails = getCardDetailsResponseData // Pass the fetched card details
            return cell
            
        case .buttonPayNow:
            let cell = tableView.dequeueReusableCell(withIdentifier: cellType.rawValue, for: indexPath) as! ButtonPayNowTableViewCell
            cell.delegate = self
            if !UserHelper.shared.isGuest(){
                cell.btnPayNow.setTitle("Generate Invoice", for: .normal)
            }else{
                cell.btnPayNow.setTitle("Pay Now", for: .normal)
            }
            cell.selectionStyle = .none
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellIdentifiers[indexPath.section].1
    }
}

extension PaymentViewController {
    enum Event {
        case dataLoaded
        case error(Error?)
    }
    
    enum CellType: String {
        case selectMeetingRoomLabel = "SelectMeetingRoomLabelTableViewCell"
        case meetingTime = "MeetingTimeTableViewCell"
        case meetingRoomPrice = "MeetingRoomPriceTableViewCell"
        case officePriceDetails = "OfficeTypeTableViewCell"
        case amenityPrice = "AmenityPriceTableViewCell"
        case totalCell = "TotalTableViewCell"
        case discount = "DiscountCodeTableViewCell"
        case paymentMethods = "PaymentMethodTableViewCell"
        case buttonPayNow = "ButtonPayNowTableViewCell"
    }
}

extension PaymentViewController: ButtonPayNowTableViewCellDelegate {
    func btnPayNowTappedAction() {
      
      if bookingType != .meetingRoom {
         if UserHelper.shared.isUserExplorer() {
          CurrentLoginType.shared.loginScreenDelegate = self
          LogInViewController.showLoginViewController()
          return
        }
      }
        guard let obj = self.requestParameters else { return }
        
        switch bookingType {
        case .desk:
            let deskCount = obj.deskList.count
            if deskCount > 0 {
                var requestModel = NiPaymentRequestModel()
                requestModel.total = Int(totalPriceDesk)
                requestModel.email = UserHelper.shared.getUserEmail()
                paymentServiceManager.currentViewController = self
                paymentServiceManager.currentNavigationController = self.navigationController
                paymentServiceManager.paymentTypeEntity = .desk
                paymentServiceManager.bookingId = bookingId
                paymentServiceManager.totalPrice = totalPriceDesk
                paymentServiceManager.vatAmount = vatAmountDesk
                if UserHelper.shared.isGuest() {
                  paymentServiceManager.makePayment(requestModel: requestModel)
                } else {
                  paymentServiceManager.paymentDeskBookingAPI(bookingid: bookingId, totalprice: totalPriceDesk, vatamount: vatAmountDesk)
                }
            }
        case .meetingRoom:
            let additionalServicesVC = UIViewController.createController(storyBoard: .Payment, ofType: ChooseAdditionalServicesViewController.self)
            additionalServicesVC.vatAmount = self.vatAmountMeetingRoom
            additionalServicesVC.totalPrice = self.totalPriceMeetingRoom
            additionalServicesVC.bookingId = self.bookingId
            self.navigationController?.pushViewController(additionalServicesVC, animated: true)
            
        case .office:
            paymentServiceManager.currentViewController = self
            paymentServiceManager.currentNavigationController = self.navigationController
            paymentServiceManager.paymentTypeEntity = .office
            paymentServiceManager.bookingId = bookingId
            paymentServiceManager.totalPrice = totalPriceOffice
            paymentServiceManager.vatAmount = vatAmountOffice
            var requestModel = NiPaymentRequestModel()
            requestModel.total = Int(totalPriceOffice)
            requestModel.email = UserHelper.shared.getUserEmail()
            if UserHelper.shared.isGuest() {
              paymentServiceManager.makePayment(requestModel: requestModel)
            } else {
              paymentServiceManager.paymentOfficeBookingAPI(id: bookingId, totalprice: totalPriceOffice, vatamount:  vatAmountOffice)
            }
        }
    }
}
extension PaymentViewController: LoginScreenActionDelegate {
  func loginScreenDismissed() {
    DispatchQueue.main.async {
      self.btnPayNowTappedAction()
    }
  }
}
