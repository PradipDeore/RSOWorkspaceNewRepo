//
//  BookingConfirmedViewController.swift
//  RSOWorkspace
//
//  Created by Sumit Aquil on 05/03/24.
//

import UIKit
import SwiftUI

class BookingConfirmedViewController: UIViewController{
    
    var coordinator: RSOTabBarCordinator?
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var containerView: UIView!
    var cornerRadius: CGFloat = 10.0
    
    var eventHandler: ((_ event: Event) -> Void)?
    var apiResponseData:StoreRoomBookingResponse?
    
    private let cellIdentifiers: [CellType] = [ .confirmedLocation, .confirmedMeetingRoom, .confirmedTime, .confirmedDate,  .confirmedTeamMembers, .confirmedGuests, .confirmAndProceedToPayment, .buttonEdit]
    
    private let cellHeights: [CGFloat] = [ 70, 70, 70, 70, 60, 50, 40, 40]
    
    var bookingConfirmDetails : ConfirmBookingRequestModel?
    var roomId: Int = 0
    var roomPrice = ""
    var amenityName = ""
    var amenityPrice = ""
    var guestEmailArray:[String] = [""]
    var teamMembersArray:[String] = [""]
    var amenitiesArray:[String] = [""]
    var locationName :String = ""
    var locationId: Int = 0
    var seatingConfigueId: Int = 0
    var timeRange = ""
    var dateOfBooking = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        customizeCell()
    }
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    self.tableView.reloadData()
  }
    private func customizeCell(){
        containerView.layer.cornerRadius = cornerRadius
        containerView.layer.masksToBounds = true
        
        let shadowColor = UIColor.black.withAlphaComponent(0.5)
        containerView.layer.shadowColor = shadowColor.cgColor
        containerView.layer.shadowOffset = CGSize(width: 0, height: 4.0)
        containerView.layer.shadowRadius = 10.0
        containerView.layer.shadowOpacity = 0.19
        containerView.layer.masksToBounds = false
        containerView.layer.shadowPath = UIBezierPath(roundedRect:  CGRect(x: 0, y: containerView.bounds.height - 4, width: containerView.bounds.width, height: 4), cornerRadius: containerView.layer.cornerRadius).cgPath
    }
    
    @IBAction func btnHideViewTappedAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    private func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        
        navigationController?.navigationBar.isHidden = true
        
        for type in cellIdentifiers {
            tableView.register(UINib(nibName: type.rawValue, bundle: nil), forCellReuseIdentifier: type.rawValue)
        }
    }
    func storeRoomBookingAPI(requestModel: StoreRoomBookingRequest) {
        self.eventHandler?(.loading)
        
        APIManager.shared.request(
            modelType: StoreRoomBookingResponse.self,
            type: PaymentRoomBookingEndPoint.getStoreRoomBooking(requestModel: requestModel)) { response in
                self.eventHandler?(.stopLoading)
                switch response {
                case .success(let response):
                    
                    self.apiResponseData = response
                    DispatchQueue.main.async {
                        let paymentVC = UIViewController.createController(storyBoard: .Payment, ofType: PaymentViewController.self)
                        paymentVC.requestParameters = self.bookingConfirmDetails
                        paymentVC.coordinator = self.coordinator
                        paymentVC.bookingId = response.booking_id ?? 0
                        self.navigationController?.pushViewController(paymentVC, animated: true)
                    }
                    self.eventHandler?(.dataLoaded)
                case .failure(let error):
                    self.eventHandler?(.error(error))
                    DispatchQueue.main.async {
                        //  Unsuccessful
                        self.view.makeToast("\(error.localizedDescription)", duration: 2.0, position: .center)
                    }
                }
            }
    }
}

extension BookingConfirmedViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return cellIdentifiers.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 4{
            return  bookingConfirmDetails?.teamMembers.count ?? 0
        }else if section == 5{
            return guestEmailArray.count
        }
        return 1
    }
   
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = SectionHeaderView(reuseIdentifier: "SectionHeaderView")
            if section == 0 {
                headerView.sectionLabel.text = "Booking Confirmed"
                headerView.sectionLabel.font = RSOFont.poppins(size: 20.0, type: .SemiBold)
            } else if section == 4 {
                headerView.sectionLabel.text = "Team Members"
                headerView.labelHeight = 15 // Set a different height for this section
            } else if section == 5 {
                headerView.sectionLabel.text = "Guests"
                headerView.labelHeight = 15 // Set a different height for this section
            } else {
                return nil
            }
            return headerView
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellType = cellIdentifiers[indexPath.section]
        switch cellType {
        case .confirmedLocation:
            let cell = tableView.dequeueReusableCell(withIdentifier: cellType.rawValue, for: indexPath) as! BookingConfirmedLocationTableViewCell
            cell.txtLocation.text = bookingConfirmDetails?.location
            cell.selectionStyle = .none

            return cell
        case .confirmedMeetingRoom:
            let cell = tableView.dequeueReusableCell(withIdentifier: cellType.rawValue, for: indexPath) as! BookingConfirmedMeetingRoomTableViewCell
            cell.lblRoomName.text = bookingConfirmDetails?.meetingRoom
            cell.selectionStyle = .none

            return cell
       
        case .confirmedDate:
            let cell = tableView.dequeueReusableCell(withIdentifier: cellType.rawValue, for: indexPath) as! BookingConfirmedDateTableViewCell
            cell.lblDate.text = bookingConfirmDetails?.date
            cell.selectionStyle = .none

            return cell
            
        case .confirmedTime:
            let cell = tableView.dequeueReusableCell(withIdentifier: cellType.rawValue, for: indexPath) as! BookingConfirmedTimeTableViewCell

            if let startTime = self.bookingConfirmDetails?.displayStartTime, let endTime = self.bookingConfirmDetails?.displayendTime {
                timeRange = "\(startTime) - \(endTime)"
                cell.txtTime.text = timeRange
               
            } else {
                cell.txtTime.text = "Unavailable"
            }
            cell.selectionStyle = .none

            return cell
        case .confirmedTeamMembers:
            let cell = tableView.dequeueReusableCell(withIdentifier: cellType.rawValue, for: indexPath) as! BookingConfirmedTeamMembersTableViewCell
            
            cell.selectionStyle = .none
            if let teamMember = bookingConfirmDetails?.teamMembers[indexPath.row]{
                cell.lblName.text = teamMember
                teamMembersArray.append(teamMember)
            }
            cell.selectionStyle = .none

            return cell
            
        case .confirmedGuests:
            let cell = tableView.dequeueReusableCell(withIdentifier: cellType.rawValue, for: indexPath) as! BookingConfirmedGuestsTableViewCell
            cell.selectionStyle = .none
            let guest = guestEmailArray[indexPath.row]
            cell.lblEmail.text = guest
            cell.selectionStyle = .none

            return cell
            
        case .confirmAndProceedToPayment:
            let cell = tableView.dequeueReusableCell(withIdentifier: cellType.rawValue, for: indexPath) as! ConfirmAndProceedToPayementTableViewCell
          cell.btnConfirmAndProceed.isEnabled = true
            cell.delegate = self
            cell.selectionStyle = .none

            return cell
        case .buttonEdit:
            let cell = tableView.dequeueReusableCell(withIdentifier: cellType.rawValue, for: indexPath) as! ButtonEditTableViewCell
            cell.delegate = self
            cell.selectionStyle = .none

            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: cellType.rawValue, for: indexPath)
            cell.selectionStyle = .none
            
//            if let labelCell = cell as? SelectMeetingRoomLabelTableViewCell {
//                labelCell.lblMeetingRoom.text = "Booking Confirmed"
//                
//                return labelCell
//            }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeights[indexPath.section]
    }
}

extension BookingConfirmedViewController {
    enum Event {
        case loading
        case stopLoading
        case dataLoaded
        case error(Error?)
    }
    
    enum CellType: String {
        //case selectMeetingRoom = "SelectMeetingRoomLabelTableViewCell"
        case confirmedLocation = "BookingConfirmedLocationTableViewCell"
        case confirmedMeetingRoom = "BookingConfirmedMeetingRoomTableViewCell"
        case confirmedTime = "BookingConfirmedTimeTableViewCell"
        case confirmedDate = "BookingConfirmedDateTableViewCell"
        case confirmedTeamMembers = "BookingConfirmedTeamMembersTableViewCell"
        case confirmedGuests = "BookingConfirmedGuestsTableViewCell"
        case confirmAndProceedToPayment = "ConfirmAndProceedToPayementTableViewCell"
        case buttonEdit = "ButtonEditTableViewCell"
    }
}
extension BookingConfirmedViewController:ButtonEditTableViewCellDelegate{
    func navigateToBookingDetails() {
        //self.dismiss(animated:true)
      self.navigationController?.popViewController(animated: true)
    }
}
extension BookingConfirmedViewController:ConfirmAndProceedToPayementTableViewCellDelegate{
    func btnConfirmAndProceedTappedAction() {
       
        let startTime = self.bookingConfirmDetails?.startTime
        let endTime = self.bookingConfirmDetails?.endTime
        let BookingTime = "\(startTime ?? "00:00") - \(endTime ?? "00:00")"
        let locationId = String(locationId)
        let location = StoreRoomLocation(id: locationId, name: locationName)

        let requestModel = StoreRoomBookingRequest(amenities: amenitiesArray, configurations_id: seatingConfigueId, date: dateOfBooking, guestList: guestEmailArray, location: location, memberList: teamMembersArray, roomId: roomId, time: BookingTime)
        print("parameters",requestModel)
        storeRoomBookingAPI(requestModel: requestModel)

    }
  
}
