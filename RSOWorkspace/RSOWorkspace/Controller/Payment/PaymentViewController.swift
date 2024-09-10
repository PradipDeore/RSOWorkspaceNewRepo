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
struct orderSummaryItem{
    let title:String?
    let price:String?
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
    var totalFinalPriceOfmeetingRoom: Double = 0.0
    var totalFinalPriceOfOffice : Double = 0.0
    var officeName = ""
    var bookingType: BookingType = .meetingRoom
    var totalAmenityPrices: [Int: Float] = [:]

    var orderdetailsaArray : [orderSummaryItem] = []
   // var totalAmenityPrice: Float {
        // Initialize total price to 0
        //var totalPrice: Float = 0.0
        
//        // Iterate through the amenities array and calculate the total price
//        if let amenityArray = self.requestParameters?.amenityArray {
//            for amenity in amenityArray {
//                // Retrieve the selected hours for the current amenity
//                let selectedHours = self.requestParameters?.amenityTotalHours[amenity.id] ?? 0
//                // Calculate the price for the current amenity
//                let amenityPrice = Float(amenity.price ?? "0.0") ?? 0.0
//                // Add the total price of this amenity to the global total
//                totalPrice += amenityPrice * Float(selectedHours)
//            }
//        }
//        
//        return totalPrice
    //}
    //var couponData: CouponDetailsResponseModel?
    private var cellIdentifiers: [(CellType, CGFloat)] = [
        (.selectMeetingRoomLabel, 20.0),
        (.meetingTime, 80),
        (.amenityPrice, 50),
        (.roomBookingOrderDetails, 50),
        
        (.totalCell, 191),
        //(.discount, 60),
        (.paymentMethods, 97),
        (.buttonPayNow, 40)
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCellIdentifiers()
        setupTableView()
        coordinator?.hideBackButton(isHidden: false)
           
        if let orderDetails = requestParameters?.orderDetailsOfMeetingRoomwithAll {
                appendOrderDetailsData(orderDetails: orderDetails)
            } else {
                print("Order details are not available.")
            }
        if let orderDetailsofOffice = requestParameters?.orderDetailsfOfficewithAll {
                appendOrderDetailsDataOffice(orderDetails: orderDetailsofOffice)
            } else {
                print("office Order details are not available.")
            }
    }
    func appendOrderDetailsData(orderDetails: RoomBookingOrderDetails) {
        // Clear existing data
        orderdetailsaArray.removeAll()
        var subtotalValue: Double = 0.0

        // Main Price
        if let mainPrice = orderDetails.mainprice {
            if let subtotal = mainPrice.subtotal {
                // Remove any commas from the subtotal string
                let cleanSubtotal = subtotal.replacingOccurrences(of: ",", with: "")
                
                // Convert cleaned string to Double
                subtotalValue = Double(cleanSubtotal) ?? 0.0
                
                let subtotalItem = orderSummaryItem(title: "Subtotal", price: "AED \(subtotalValue.toStringWithTwoDecimalPlaces())")
                orderdetailsaArray.append(subtotalItem)
            }
        }
            
        // Weekday Discount
        if let weekday = orderDetails.weekday, weekday.isDiscount == "yes" {
            let discountPercentage = Double(weekday.discount?.formattedPrice ?? "0.00") ?? 0.0
            let hours = weekday.hours ?? 0
            let discountedPrice: Double
               if let discountPriceValueString = weekday.discount_amount,
                  let discountPriceValue = Double(discountPriceValueString) {
                   print("discountedPrice:", discountPriceValue)
                   discountedPrice = discountPriceValue
               } else {
                   print("discountedPrice is nil or not convertible to Double, defaulting to 0")
                   discountedPrice = 0.0
               }

            let discountDescription = "Discount (\(discountPercentage)% on \(hours) hour\(hours > 1 ? "s" : ""))"

            let discountItem = orderSummaryItem(title: discountDescription, price: "AED \(discountedPrice)")

            orderdetailsaArray.append(discountItem)
        }
        
        if let weekend = orderDetails.weekend, weekend.isCharges == "yes" {
            let weekendPercentage = Double(weekend.charges?.formattedPrice ?? "0.00") ?? 0.0
            
            // Calculate the weekend charges
            let weekendChargesAmount = subtotalValue * (weekendPercentage / 100)
            ("subtotal value",subtotalValue)
            let weekendDescription = "Weekend Charges (\(weekendPercentage)% of Subtotal)"
            let weekendItem = orderSummaryItem(title: weekendDescription, price: "AED \(weekendChargesAmount.toStringWithTwoDecimalPlaces())")
            orderdetailsaArray.append(weekendItem)
        }

        // Surcharge
            if let surcharge = orderDetails.surcharge, surcharge.isSurcharge == "yes" {
                let surchargeAmount = surcharge.surchargeAmount ?? 0
                let surchargeCharges = surcharge.charges?.formattedPrice ?? "0.00"
                let hours = surcharge.hours ?? 0
                
                // Create a descriptive surcharge string
                let surchargeDescription = "Surcharge (\(surchargeCharges) on \(hours) hour\(hours > 1 ? "s" : ""))"
                
                let surchargeItem = orderSummaryItem(title: surchargeDescription, price: "AED \(surchargeAmount)")
                orderdetailsaArray.append(surchargeItem)
            }
        // Total Price
        if let totalItems = orderDetails.total {
            for totalItem in totalItems {
                let totalName = totalItem.name
                if let totalPrice = totalItem.price {
                    totalFinalPriceOfmeetingRoom = Double(totalPrice.replacingOccurrences(of: ",", with: "")) ?? 0.0
                }
                let totalDetailItem = orderSummaryItem(title: totalName, price: "AED \(totalFinalPriceOfmeetingRoom)")
                orderdetailsaArray.append(totalDetailItem)
            }
        }
            
            
        // Reload the table view to reflect the new data
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    func appendOrderDetailsDataOffice(orderDetails: OfficeBookingOrderDetails) {
        // Clear existing data
        orderdetailsaArray.removeAll()
        var subtotalValue: Double = 0.0

        // Main Price
        if let mainPrice = orderDetails.mainprice {
            if let subtotal = mainPrice.subtotal {
                // Remove any commas from the subtotal string
                let cleanSubtotal = subtotal.replacingOccurrences(of: ",", with: "")
                
                // Convert cleaned string to Double
                subtotalValue = Double(cleanSubtotal) ?? 0.0
                
                let subtotalItem = orderSummaryItem(title: "Subtotal", price: "AED \(subtotalValue.toStringWithTwoDecimalPlaces())")
                orderdetailsaArray.append(subtotalItem)
            }
        }
            
        // Weekday Discount
        if let weekday = orderDetails.weekday, weekday.isDiscount == "yes" {
            let discountPercentage = Double(weekday.discount?.formattedPrice ?? "0.00") ?? 0.0
            let hours = weekday.hours ?? 0
            let discountedPrice: Double
               if let discountPriceValueString = weekday.discount_amount,
                  let discountPriceValue = Double(discountPriceValueString) {
                   print("discountedPrice:", discountPriceValue)
                   discountedPrice = discountPriceValue
               } else {
                   print("discountedPrice is nil or not convertible to Double, defaulting to 0")
                   discountedPrice = 0.0
               }

            let discountDescription = "Discount (\(discountPercentage)% on \(hours) hour\(hours > 1 ? "s" : ""))"

            let discountItem = orderSummaryItem(title: discountDescription, price: "AED \(discountedPrice)")

            orderdetailsaArray.append(discountItem)
        }
        
        if let weekend = orderDetails.weekend, weekend.isCharges == "yes" {
            let weekendPercentage = Double(weekend.charges?.formattedPrice ?? "0.00") ?? 0.0
            
            // Calculate the weekend charges
            let weekendChargesAmount = subtotalValue * (weekendPercentage / 100)
            ("subtotal value",subtotalValue)
            let weekendDescription = "Weekend Charges (\(weekendPercentage)% of Subtotal)"
            let weekendItem = orderSummaryItem(title: weekendDescription, price: "AED \(weekendChargesAmount.toStringWithTwoDecimalPlaces())")
            orderdetailsaArray.append(weekendItem)
        }

        // Surcharge
            if let surcharge = orderDetails.surcharge, surcharge.isSurcharge == "yes" {
                let surchargeAmount = surcharge.surchargeAmount ?? 0
                let surchargeCharges = surcharge.charges?.formattedPrice ?? "0.00"
                let hours = surcharge.hours ?? 0
                
                // Create a descriptive surcharge string
                let surchargeDescription = "Surcharge (\(surchargeCharges) on \(hours) hour\(hours > 1 ? "s" : ""))"
                
                let surchargeItem = orderSummaryItem(title: surchargeDescription, price: "AED \(surchargeAmount)")
                orderdetailsaArray.append(surchargeItem)
            }
        // Total Price
        if let totalItems = orderDetails.total {
            for totalItem in totalItems {
                let totalName = totalItem.name
                if let totalPrice = totalItem.price {
                    // Correct parsing of the total price
                    totalFinalPriceOfOffice = Double(totalPrice.replacingOccurrences(of: ",", with: "")) ?? 0.0
                }
                
                // Ensure the correct value is being assigned to the price in the UI
               // let totalDetailItem = orderSummaryItem(title: totalName, price: "AED \(totalFinalPriceOfOffice)")
                //orderdetailsaArray.append(totalDetailItem)
            }
        }
            
            
        // Reload the table view to reflect the new data
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }


    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // getCardDetails()
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
    
    //    private func applyCouponAPI(code: Int, amount:Int) {
    //        let requestModel = couponRequestModel(code: code, amount: amount)
    //        APIManager.shared.request(
    //            modelType: CouponDetailsResponseModel.self,
    //            type: PaymentRoomBookingEndPoint.applyCoupon(requestModel: requestModel)) { response in
    //                switch response {
    //                case .success(let response):
    //                    self.couponData = response
    //                    DispatchQueue.main.async {
    //                        self.tableView.reloadData()
    //                    }
    //                    self.eventHandler?(.dataLoaded)
    //                case .failure(let error):
    //                    self.eventHandler?(.error(error))
    //                }
    //            }
    //    }
    
}

extension PaymentViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return cellIdentifiers.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let cellType = cellIdentifiers[section].0
        switch cellType {
        case .amenityPrice:
            let filterAmenities = self.requestParameters?.amenityTotalHours.count ?? 0
            return filterAmenities
            
        case .meetingRoomPrice:
            if bookingType == .desk {
                return self.requestParameters?.deskList.count ?? 0
            }else if  bookingType == .meetingRoom{
                return 1
            }
            return 0
        case .roomBookingOrderDetails:
            if bookingType == .desk {
                return 0
            }else if  bookingType == .meetingRoom{
                return self.orderdetailsaArray.count
               
            }else if bookingType == .office{
              //  return self.requestParameters?.orderDetailsOfOffice.count ?? 0
                return self.orderdetailsaArray.count
            }
            
            return 0
        case .officePriceDetails:
            if bookingType == .office {
                //return 1
                return self.requestParameters?.orderDetailsOfOffice.count ?? 0
            }
            return 0
        case .paymentMethods:
            if UserHelper.shared.isUserExplorer(){
                return 0
            }
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
            cell.selectionStyle = .none
            
            if let labelCell = cell as? SelectMeetingRoomLabelTableViewCell {
                labelCell.lblMeetingRoom.text = "Payment"
                labelCell.lblMeetingRoom.font = UIFont(name: "Poppins-SemiBold", size: 20.0)
            }
            return cell
            
        case .meetingTime:
            let cell = tableView.dequeueReusableCell(withIdentifier: cellType.rawValue, for: indexPath) as! MeetingTimeTableViewCell
            cell.selectionStyle = .none
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
            cell.selectionStyle = .none
            if let obj = self.requestParameters {
                if bookingType == .desk{
                    let desk = obj.deskList[indexPath.row]
                    cell.lblMeetingRoomName.text = desk.name
                    let price = Float(desk.price )
                    //cell.lblmeetingRoomprice.text = "\(price ?? 00) "
                    cell.lbltotalPrice.text = "AED \((price ?? 0.0) * obj.timeDifferece)"
                    
                } else if  bookingType == .meetingRoom {
                    let meetingRoomName = obj.meetingRoom
                    cell.lblMeetingRoomName.text = meetingRoomName
                    let roomPrice = obj.roomprice.integerValue ?? 0
                   // cell.lblmeetingRoomprice.text = "\(roomPrice)"
                    cell.lbltotalPrice.text = "\(obj.totalOfMeetingRoom)"

                    print("roomPrice: \(roomPrice)")
                    cell.lbltotalPrice.text = "AED \(obj.totalOfMeetingRoom)"
                }
            }
            
            
            return cell
        case .officePriceDetails:
            let cell = tableView.dequeueReusableCell(withIdentifier: cellType.rawValue, for: indexPath) as! OfficeTypeTableViewCell
            cell.selectionStyle = .none
            if let obj = self.requestParameters {
                if bookingType == .office{
                    cell.lblOfficeName.text = obj.meetingRoom
                    cell.lblNoOfSeats.text = "\(obj.noOfSeats)"
                    let officePrice = obj.roomprice.integerValue ?? 0
                    cell.lblOfficeNameWithPrice.text = obj.meetingRoom
                    //cell.lblofficeHours.text = "\(obj.totalHrs)"
                    cell.lbltotalPrice.text = "AED \((officePrice))"
                }
            }
            return cell
            
        case .amenityPrice:
            let cell = tableView.dequeueReusableCell(withIdentifier: cellType.rawValue, for: indexPath) as! AmenityPriceTableViewCell
            cell.selectionStyle = .none
            if let amenity = self.requestParameters?.amenityArray[indexPath.row] {
                cell.lblAmenityName.text = amenity.name
                let amenityPriceInt = amenity.price?.integerValue ?? 0
                cell.lblAmenityPrice.text = "\(amenityPriceInt)"
                // Retrieve the selected hours for this amenity from amenityTotalHours
                let selectedHours = self.requestParameters?.amenityTotalHours[amenity.id] ?? 0
                //cell.lblHours.text = "\(selectedHours)"
                
                // Calculate total price for the amenity
                        let amenityPrice = Float(amenity.price ?? "0.0") ?? 0.0
                        let totalAmenityPrice = amenityPrice * Float(selectedHours)
                        cell.lblTotal.text = "AED  \(totalAmenityPrice)"
               
                // Store the total price for the amenity globally
                self.totalAmenityPrices[amenity.id] = totalAmenityPrice
                
            }
            return cell
            
        case .totalCell:
            let cell = tableView.dequeueReusableCell(withIdentifier: cellType.rawValue, for: indexPath) as! TotalTableViewCell
            cell.selectionStyle = .none
            if let obj = self.requestParameters {
                switch bookingType {
                case .desk:
                    cell.lblVat.text = "\(obj.deskVatTotal)"
                    vatAmountDesk = Double(obj.deskVatTotal)
                    cell.lblTotalPrice.text = "\(obj.deskFinalTotal)"
                    totalPriceDesk = Double(obj.deskFinalTotal)
                case .office:
                    
                    let grossTotalOffice = Double(totalFinalPriceOfOffice)
                    let vatPercentage: Double = 0.05
                    let vatAmount = grossTotalOffice * vatPercentage
                    print("vatAmount",vatAmount)
                    let totalPriceWithVAT = grossTotalOffice + vatAmount
                    print("totalPriceWithVAT",totalPriceWithVAT)
                    cell.lblVat.text = "AED \(vatAmount.toStringWithTwoDecimalPlaces())"

                    cell.lblTotalPrice.text = "\(totalPriceWithVAT.toStringWithTwoDecimalPlaces())"
                    vatAmountOffice = vatAmount
                    totalPriceOffice = totalPriceWithVAT
                    //totalFinalPriceOfOffice
                 
                default:
                    let grossTotalMeetingRoom = Double(totalFinalPriceOfmeetingRoom)
                    print("totalFinalPriceOfmeetingRoom", totalFinalPriceOfmeetingRoom)
                    print("grossTotalMeetingRoom", grossTotalMeetingRoom)
                    let vatPercentage: Double = 0.05
                    let vatAmount = grossTotalMeetingRoom * vatPercentage
                    // Sum all the values in totalAmenityPrices
                    // Sum all the values in totalAmenityPrices (convert Float to Double)
                    let totalAmenityPriceSum = Double(self.totalAmenityPrices.values.reduce(0, +))
                    let totalPriceWithVAT = grossTotalMeetingRoom + vatAmount + totalAmenityPriceSum
                    cell.lblVat.text = "AED \(vatAmount.toStringWithTwoDecimalPlaces())"
                    cell.lblTotalPrice.text = "\(totalPriceWithVAT.toStringWithTwoDecimalPlaces())"
                    vatAmountMeetingRoom = vatAmount
                    totalPriceMeetingRoom = totalPriceWithVAT
                }
            }
            return cell
            
            //        case .discount:
            //            let cell = tableView.dequeueReusableCell(withIdentifier: cellType.rawValue, for: indexPath) as! DiscountCodeTableViewCell
            //            if !couponData.isEmpty {
            //                let coupon = couponData[indexPath.row]
            //                cell.setData(item: coupon)
            //                cell.applyCouponAction = {
            //                    self.applyCouponAPI(code: coupon., amount: <#T##Int#>)
            //                }
            //            } else {
            //                cell.applyCouponAction = {
            //                    guard let couponCode = cell.txtDiscount.text, !couponCode.isEmpty else {
            //                        // Handle empty text field
            //                        return
            //                    }
            //                    self.applyCouponAPI(couponCode: couponCode)
            //                }
            //            }
            //            return cell
            
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
        case .roomBookingOrderDetails:
            let cell = tableView.dequeueReusableCell(withIdentifier: cellType.rawValue, for: indexPath) as! OrderDetailTableViewCell2
            cell.selectionStyle = .none
            if let obj = self.requestParameters {
                switch bookingType {
                case .desk:
                    break

                case .office:
                    let item = orderdetailsaArray[indexPath.item]
                    cell.lbltitle.text = item.title
                    cell.lblPrice.text = item.price
                default:
                    let item = orderdetailsaArray[indexPath.item]
                    cell.lbltitle.text = item.title
                    cell.lblPrice.text = item.price
                }
            }
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
        //case discount = "DiscountCodeTableViewCell"
        case paymentMethods = "PaymentMethodTableViewCell"
        case buttonPayNow = "ButtonPayNowTableViewCell"
        case roomBookingOrderDetails = "OrderDetailTableViewCell2"
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


