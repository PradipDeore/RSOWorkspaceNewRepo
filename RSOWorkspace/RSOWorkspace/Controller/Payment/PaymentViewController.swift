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
    private let cellIdentifiers: [(CellType,CGFloat)] = [(.selectMeetingRoomLabel,20.0),(.meetingTime,80),(.meetingRoomPrice,40),(.amenityPrice,50),(.totalCell,191),(.discount,60),(.paywithrewardPoints,157),(.buttonPayNow,40)]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        coordinator?.hideBackButton(isHidden: false)
        
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
       
        default:
            return 1
        }
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView()
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
                let roomPrice = obj.roomprice.integerValue ?? 0
                //print("roomPrice",roomPrice)
                cell.lblmeetingRoomprice.text = "\(roomPrice)"
                
                cell.lblHours.text = "\(Int(obj.timeDifferece))" // endtime - starttime
                cell.lbltotalPrice.text = "\(obj.totalOfMeetingRoom)"
                
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
                cell.lblSubTotal.text = "\(obj.subTotal)"
                
                cell.lblVat.text = "\(obj.calculatedVat)"
                vatAmount = Double(obj.calculatedVat)
                cell.lblTotalPrice.text = "\(obj.finalTotal)" // subttotal + vat
                totalPrice = Double(obj.finalTotal)
                
            }
            return cell
        case .discount:
            let cell = tableView.dequeueReusableCell(withIdentifier: cellType.rawValue, for: indexPath) as! DiscountCodeTableViewCell
            return cell
        case .paywithrewardPoints:
            let cell = tableView.dequeueReusableCell(withIdentifier: cellType.rawValue, for: indexPath) as! PayWithRewardPointsTableViewCell
            return cell
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
        case paywithrewardPoints = "PayWithRewardPointsTableViewCell"
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
