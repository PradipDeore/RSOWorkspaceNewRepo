//
//  PaymentViewController.swift
//  RSOWorkspace
//
//  Created by Sumit Aquil on 06/03/24.
//

import UIKit

class PaymentViewController: UIViewController {
    
    var coordinator: RSOTabBarCordinator?
    var bookingId: Int = 0
    @IBOutlet weak var tableView: UITableView!
    var eventHandler: ((_ event: Event) -> Void)?
    
    var requestParameters : ConfirmBookingRequestModel?
    var intHours = 0
    var totalPrice:Double = 0.0
    var vatAmount:Double = 0.0
    var couponData : [CouponDetails] = []
    private let cellIdentifiers: [(CellType,CGFloat)] = [(.selectMeetingRoomLabel,20.0),(.meetingTime,80),(.meetingRoomPrice,40),(.amenityPrice,50),(.totalCell,191),(.discount,60),(.paywithrewardPoints,157),(.buttonPayNow,40)]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        coordinator?.hideBackButton(isHidden: false)
        
    }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    self.tableView.reloadData()
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
}
extension PaymentViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return cellIdentifiers.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let cellType = cellIdentifiers[section].0
        switch cellType{
        case .amenityPrice:
            return self.requestParameters?.amenityArray.count ?? 0
        case .discount:
            return couponData.isEmpty ? 1 : couponData.count
          
        case .meetingRoomPrice:
          let deskCount = self.requestParameters?.deskList.count ?? 0
          if deskCount > 0 {
            return deskCount
          }
          return 1
        default:
            return 1
        }
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellType = cellIdentifiers[indexPath.section].0
        
        switch cellType{
        case .selectMeetingRoomLabel: break
            
        case .meetingTime:
            let cell = tableView.dequeueReusableCell(withIdentifier: cellType.rawValue, for: indexPath) as! MeetingTimeTableViewCell
            var timeRange = ""
            if let startTime = self.requestParameters?.displayStartTime, let endTime = self.requestParameters?.displayendTime {
                timeRange = "\(startTime) - \(endTime)"
                cell.txtTime.text = timeRange
                
            } else {
                cell.txtTime.text = "Unavailable"
            }
            if let floathours = self.requestParameters?.timeDifferece{
                intHours = Int(floathours)
            }
            cell.lblHours.text = "\(intHours)"
            return cell
            
        case .meetingRoomPrice:
            let cell = tableView.dequeueReusableCell(withIdentifier: cellType.rawValue, for: indexPath) as! MeetingRoomPriceTableViewCell
            
            if let obj = self.requestParameters {
              let deskCount = self.requestParameters?.deskList.count ?? 0
              if deskCount > 0 {
                let desk = self.requestParameters?.deskList[indexPath.row]
                let roomPrice = desk?.price ?? "0.0"
                //print("roomPrice",roomPrice)
                let roomPriceFloat = Float(roomPrice) ?? 0.0
                cell.lblmeetingRoomprice.text = "\(roomPrice)"
                cell.lblHours.text = "\(Int(obj.timeDifferece))" // endtime - starttime
                let totalRoomPrice = roomPriceFloat * obj.timeDifferece
                cell.lbltotalPrice.text = "\(totalRoomPrice)"
                
              } else {
                let roomPrice = obj.roomprice.integerValue ?? 0
                //print("roomPrice",roomPrice)
                cell.lblmeetingRoomprice.text = "\(roomPrice)"
                cell.lblHours.text = "\(Int(obj.timeDifferece))" // endtime - starttime
                cell.lbltotalPrice.text = "\(obj.totalOfMeetingRoom)"
              }
            }
            return cell
        case .amenityPrice:
            let cell = tableView.dequeueReusableCell(withIdentifier: cellType.rawValue, for: indexPath) as! AmenityPriceTableViewCell
            
            if let obj = self.requestParameters {
                let amenity = obj.amenityArray[indexPath.row]
                cell.lblAmenityName.text = amenity.name
                
                let amenityPriceInt =  amenity.price?.integerValue ?? 0
                //print("amenityPriceInt",amenityPriceInt)
                cell.lblAmenityPrice.text = "\(amenityPriceInt)"
                
                cell.lblHours.text = "\(Int(obj.timeDifferece))" // endtime - starttime
                
                cell.lblTotal.text = "\(obj.totalOfAmenity)"
            }
            return cell
            
        case .totalCell:
            let cell = tableView.dequeueReusableCell(withIdentifier: cellType.rawValue, for: indexPath) as! TotalTableViewCell
            if let obj = self.requestParameters{
              let deskCount = self.requestParameters?.deskList.count ?? 0
              if deskCount > 0 {
                if let deskList = self.requestParameters?.deskList {
                  cell.lblSubTotal.text = "\(obj.deskSubTotal)"
                  cell.lblVat.text = "\(obj.deskVatTotal)"
                  vatAmount = Double(obj.deskVatTotal)
                  cell.lblTotalPrice.text = "\(obj.deskFinalTotal)" // subttotal + vat
                  totalPrice = Double(obj.deskFinalTotal)
                }
              } else {
                cell.lblSubTotal.text = "\(obj.subTotal)"
                cell.lblVat.text = "\(obj.calculatedVat)"
                vatAmount = Double(obj.calculatedVat)
                cell.lblTotalPrice.text = "\(obj.finalTotal)" // subttotal + vat
                totalPrice = Double(obj.finalTotal)
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
            return cell
//        case .paywithrewardPoints:
//            let cell = tableView.dequeueReusableCell(withIdentifier: cellType.rawValue, for: indexPath) as! PayWithRewardPointsTableViewCell
           // return cell
        case .buttonPayNow:
            let buttonPayNowCell = tableView.dequeueReusableCell(withIdentifier: cellType.rawValue, for: indexPath) as! ButtonPayNowTableViewCell
            buttonPayNowCell.delegate = self
            return buttonPayNowCell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellType.rawValue, for: indexPath)
        cell.selectionStyle = .none
        
        if let labelCell = cell as? SelectMeetingRoomLabelTableViewCell {
            labelCell.lblMeetingRoom.text = "Payment"
            labelCell.lblMeetingRoom.font = UIFont(name: "Poppins-SemiBold", size: 20.0)
            return labelCell
        }
        return cell
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
        case amenityPrice = "AmenityPriceTableViewCell"
        case totalCell = "TotalTableViewCell"
        case discount = "DiscountCodeTableViewCell"
       // case paywithrewardPoints = "PayWithRewardPointsTableViewCell"
        case paymentMethods = "PaymentMethodTableViewCell"
        case buttonPayNow = "ButtonPayNowTableViewCell"
        
    }
}
extension PaymentViewController:ButtonPayNowTableViewCellDelegate{
    
    func btnPayNowTappedAction() {
        let additionalServicesVC = UIViewController.createController(storyBoard: .Payment, ofType: ChooseAdditionalServicesViewController.self)
        additionalServicesVC.vatAmount = self.vatAmount
        additionalServicesVC.totalPrice = self.totalPrice
        additionalServicesVC.bookingId = self.bookingId
        self.navigationController?.pushViewController(additionalServicesVC, animated: true)
        
    }
    
}
