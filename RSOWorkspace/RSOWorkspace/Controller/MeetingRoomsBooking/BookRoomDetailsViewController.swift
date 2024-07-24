//
//  BookRoomDetailsViewController.swift
//  RSOWorkspace
//
//  Created by Sumit Aquil on 01/03/24.
//

import UIKit
import IQKeyboardManagerSwift
import SwiftUI
import CoreLocation

class BookRoomDetailsViewController: UIViewController {
    
    var coordinator: RSOTabBarCordinator?
    
    var guestEmailDelegate:sendGuestEmailDelegate?
    var teamMemberNameDelegate:sendteamMemberNameDelegate?
    
    @IBOutlet weak var tableView: UITableView!
    var eventHandler: ((_ event: Event) -> Void)?
    var selectedBookingDetails = BookMeetingRoomRequestModel()
    var item: RoomDetailResponse?
    var meetingId: Int!
    var listItems: [RSOCollectionItem] = []
    var requestModel: BookMeetingRoomRequestModel!
    var displayBookingDetails = DisplayBookingDetailsModel()
    
    var guestEmailArray:[String] = [""]
    var teamMembersArray:[String] = [""]
    var dateOfBooking : String?
    var bookingTime :String?
    var seatingConfigueId: Int?
    var seatingConfigue:[String] = []
    var locationId:Int = 0
    var locationName:String = ""
    var confirmBookingDetails = ConfirmBookingRequestModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        coordinator?.hideBackButton(isHidden: false)
        coordinator?.setTitle(title: "Book a Meeting Room")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchRoomDetails(id: meetingId, requestModel: requestModel)
    }
    
    private func setupTableView() {
        tableView.register(UINib(nibName: "LocationTableViewCell", bundle: nil), forCellReuseIdentifier: "LocationTableViewCell")
        tableView.register(UINib(nibName: "DateTableViewCell", bundle: nil), forCellReuseIdentifier: "DateTableViewCell")
        tableView.register(UINib(nibName: "TimeTableViewCell", bundle: nil), forCellReuseIdentifier: "TimeTableViewCell")
        tableView.register(UINib(nibName: "SelectMeetingRoomLabelTableViewCell", bundle: nil), forCellReuseIdentifier: "SelectMeetingRoomLabelTableViewCell")
        tableView.register(UINib(nibName: "SelectMeetingRoomTableViewCell", bundle: nil), forCellReuseIdentifier: "SelectMeetingRoomTableViewCell")
        tableView.register(UINib(nibName: "SelectSeatingConfigTableViewCell", bundle: nil), forCellReuseIdentifier: "SelectSeatingConfigTableViewCell")
        tableView.register(UINib(nibName: "InviteTeamMembersTableViewCell", bundle: nil), forCellReuseIdentifier: "InviteTeamMembersTableViewCell")
        tableView.register(UINib(nibName: "InviteGuestsTableViewCell", bundle: nil), forCellReuseIdentifier: "InviteGuestsTableViewCell")
        tableView.register(UINib(nibName: "ChooseAmenitiesTableViewCell", bundle: nil), forCellReuseIdentifier: "ChooseAmenitiesTableViewCell")
        tableView.register(UINib(nibName: "ButtonBookingConfirmTableViewCell", bundle: nil), forCellReuseIdentifier: "ButtonBookingConfirmTableViewCell")
        
        tableView.dataSource = self
        tableView.delegate = self
        
        navigationController?.navigationBar.isHidden = true
    }
    func fetchRoomDetails(id: Int, requestModel: BookMeetingRoomRequestModel) {
        var startTime :String?
        var endTime:String?
        APIManager.shared.request(
            modelType: RoomDetailResponse.self,
            type: MyBookingEndPoint.getDetailsOfMeetingRooms(id: id, requestModel: requestModel)) { [weak self] response in
                
                guard let self = self else { return }
                
                switch response {
                case .success(let responseData):
                    // Handle successful response with bookings
                    self.item = responseData
                    self.confirmBookingDetails.setValues(model: responseData)
                    
                    // set formatted values for display on this details creen
                    self.confirmBookingDetails.date = displayBookingDetails.date
                    self.confirmBookingDetails.displayStartTime = displayBookingDetails.startTime
                    self.confirmBookingDetails.displayendTime = displayBookingDetails.endTime
                    // set time to calucaulate difference withou am pm from response
                    self.confirmBookingDetails.startTime = item?.datetime.startTime ?? "0.0"
                    self.confirmBookingDetails.endTime = item?.datetime.endTime ?? "0.0"
                  self.confirmBookingDetails.teamMembers = item?.members!.compactMap({ $0.email }) ?? []
                    self.confirmBookingDetails.location = item?.data.locationName  ?? ""
                    
                    self.dateOfBooking = requestModel.date
                  
                    startTime = item?.datetime.startTime
                    endTime = item?.datetime.endTime
                    bookingTime = (startTime ?? "00:00") + "-" + (endTime ?? "00:00")

                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                    self.eventHandler?(.dataLoaded)
                case .failure(let error):
                    self.eventHandler?(.error(error))
                    DispatchQueue.main.async {
                        RSOToastView.shared.show("\(error.localizedDescription)", duration: 2.0, position: .center)
                    }
                }
            }
    }
    
}
extension BookRoomDetailsViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 14
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView() // Return an empty view for the header between sections
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 12{
            return item?.amenity.count ?? 0
        }else if section == 10{
            return guestEmailArray.count
        }else if section == 8{
            return teamMembersArray.count
        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "LocationTableViewCell", for: indexPath) as! LocationTableViewCell
            cell.txtLocation.text =  self.confirmBookingDetails.location
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "DateTableViewCell", for: indexPath) as! DateTableViewCell
            cell.txtDate.text = self.confirmBookingDetails.date
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "TimeTableViewCell", for: indexPath) as! TimeTableViewCell
            var timeRange = ""
            let startTime = self.confirmBookingDetails.displayStartTime
            let endTime = self.confirmBookingDetails.displayendTime
            timeRange = "\(startTime) - \(endTime)"
            cell.txtTime.text = timeRange
            return cell
            
            // label Meeting rooms
        case 3:
            let cell = tableView.dequeueReusableCell(withIdentifier: "SelectMeetingRoomLabelTableViewCell", for: indexPath) as! SelectMeetingRoomLabelTableViewCell
            cell.lblMeetingRoom.text = "Meeting Room"
            cell.lblMeetingRoom.font = UIFont(name: "Poppins-SemiBold", size: 14.0)
            return cell
        case 4:
            let cell = tableView.dequeueReusableCell(withIdentifier: "SelectMeetingRoomTableViewCell", for: indexPath) as! SelectMeetingRoomTableViewCell
            cell.collectionView.tag = 1
            cell.collectionView.hideBookButton = true
            cell.collectionView.backActionDelegate = self
            cell.collectionView.listItems = listItems
            return cell
        case 5:
            let cell = tableView.dequeueReusableCell(withIdentifier: "SelectMeetingRoomLabelTableViewCell", for: indexPath) as! SelectMeetingRoomLabelTableViewCell
            cell.lblMeetingRoom.text = "Select Seating Config"
            cell.lblMeetingRoom.font = UIFont(name: "Poppins-SemiBold", size: 16.0)
            return cell
        case 6:
            let cell = tableView.dequeueReusableCell(withIdentifier: "SelectSeatingConfigTableViewCell", for: indexPath) as! SelectSeatingConfigTableViewCell
            cell.setData(sittingConfigurations: self.confirmBookingDetails.sittingConfig)
            cell.seatingConfigueId = self.seatingConfigueId ?? 0
            return cell
        case 7:
            let cell = tableView.dequeueReusableCell(withIdentifier: "SelectMeetingRoomLabelTableViewCell", for: indexPath) as! SelectMeetingRoomLabelTableViewCell
            cell.lblMeetingRoom.text = "Invite Team Members"
            cell.lblMeetingRoom.font = UIFont(name: "Poppins-SemiBold", size: 16.0)
            return cell
        case 8:
            let cell = tableView.dequeueReusableCell(withIdentifier: "InviteTeamMembersTableViewCell", for: indexPath) as! InviteTeamMembersTableViewCell
            cell.lblteammemberName.text = teamMembersArray[indexPath.row]
            cell.btnAdd.isHidden = !(indexPath.row == 0)
            cell.teamMemberView.isHidden = false
            if indexPath.row == 0 {
                if teamMembersArray.first == ""{
                    cell.teamMemberView.isHidden = true
                }
            }
            cell.delegate = self
            return cell
        case 9:
            let cell = tableView.dequeueReusableCell(withIdentifier: "SelectMeetingRoomLabelTableViewCell", for: indexPath) as! SelectMeetingRoomLabelTableViewCell
            cell.lblMeetingRoom.text = "Invite Guests"
            cell.lblMeetingRoom.font = UIFont(name: "Poppins-SemiBold", size: 16.0)
            return cell
        case 10:
            let cell = tableView.dequeueReusableCell(withIdentifier: "InviteGuestsTableViewCell", for: indexPath) as! InviteGuestsTableViewCell
            cell.lblGuestName.text = guestEmailArray[indexPath.row]
            cell.btnAdd.isHidden = !(indexPath.row == 0)
            cell.guestEmailView.isHidden = false
            if indexPath.row == 0 {
                if guestEmailArray.first == ""{
                    cell.guestEmailView.isHidden = true
                }
            }
            cell.delegate = self
            return cell
        case 11:
            let cell = tableView.dequeueReusableCell(withIdentifier: "SelectMeetingRoomLabelTableViewCell", for: indexPath) as! SelectMeetingRoomLabelTableViewCell
            cell.lblMeetingRoom.text = "Choose Amenities"
            cell.lblMeetingRoom.font = UIFont(name: "Poppins-SemiBold", size: 16.0)
            return cell
        case 12:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ChooseAmenitiesTableViewCell", for: indexPath) as! ChooseAmenitiesTableViewCell
            let aminity = self.confirmBookingDetails.amenityArray[indexPath.row]
            cell.lblAminityName.text = aminity.name
            cell.lblPrice.text = "AED " + (aminity.price ?? "0.0")
            return cell
            
        case 13:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ButtonBookingConfirmTableViewCell", for: indexPath) as! ButtonBookingConfirmTableViewCell
            cell.delegate = self
            return cell
            
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            return 50
        case 1:
            return 50
        case 2:
            return 50
        case 3:
            return 20
        case 4:
            return 209
        case 5:
            return 20
        case 6:
            return 120
        case 7:
            return UserHelper.shared.isGuest() ? 0: 20
        case 8:
            return UserHelper.shared.isGuest() ? 0: 60
        case 9:
            return UserHelper.shared.isGuest() ? 0: 20
        case 10:
            return UserHelper.shared.isGuest() ? 0: 50
        case 11:
            return 20
        case 12:
            return 65
        case 13:
            return 46
        default:
            return 100
        }
    }
}

extension BookRoomDetailsViewController:InviteTeamMembersTableViewCellDelegate{
    func btnAddTeamMembersTappedAction() {
        let addTeamMemberVC = UIViewController.createController(storyBoard: .Booking, ofType: AddTeamMemberViewController.self)
        addTeamMemberVC.modalPresentationStyle = .overFullScreen
        addTeamMemberVC.modalTransitionStyle = .crossDissolve
        addTeamMemberVC.view.backgroundColor = UIColor.clear
        addTeamMemberVC.teamMemberNameDelegate = self
        self.present(addTeamMemberVC, animated: true)
    }
    func btnDeleteTeamMember(buttonTag: Int) {
        teamMembersArray.remove(at:buttonTag)
        if teamMembersArray.isEmpty{
            teamMembersArray.append("")
        }
        tableView.reloadData()
    }
}
extension BookRoomDetailsViewController:sendteamMemberNameDelegate{
    
    func sendteamMemberName(name: String) {
        if teamMembersArray.count == 1 && teamMembersArray.first == ""{
            teamMembersArray.remove(at: 0)
        }
        teamMembersArray.append(name)
        self.confirmBookingDetails.teamMembers = teamMembersArray
        tableView.reloadData()
    }
}
extension BookRoomDetailsViewController:InviteGuestsTableViewCellDelegate{
    func  btnInviteGuestsTappedAction(){
        let inviteGuestsVC = UIViewController.createController(storyBoard: .Booking, ofType: InviteGuestsViewController.self)
        inviteGuestsVC.modalPresentationStyle = .overFullScreen
        inviteGuestsVC.modalTransitionStyle = .crossDissolve
        inviteGuestsVC.view.backgroundColor = UIColor.clear
        inviteGuestsVC.guestEmailDelegate = self
        self.present(inviteGuestsVC, animated: true)
    }
    func btnDeleteGuest(buttonTag: Int) {
        guestEmailArray.remove(at:buttonTag)
        if guestEmailArray.isEmpty{
            guestEmailArray.append("")
        }
        tableView.reloadData()
    }
}
extension BookRoomDetailsViewController:sendGuestEmailDelegate{
    
    func sendGuestEmail(email: String) {
        if guestEmailArray.count == 1 && guestEmailArray.first == ""{
            guestEmailArray.remove(at: 0)
        }
        guestEmailArray.append(email)
        self.confirmBookingDetails.guest = guestEmailArray
        tableView.reloadData()
    }
}
extension BookRoomDetailsViewController:ButtonBookingConfirmTableViewCellDelegate{
    func btnConfirmTappedAction() {
        let amenityNames = self.confirmBookingDetails.amenityArray.map { $0.name ?? ""}
        let bookingConfirmVC = UIViewController.createController(storyBoard: .Booking, ofType: BookingConfirmedViewController.self)
        bookingConfirmVC.bookingConfirmDetails = self.confirmBookingDetails
        bookingConfirmVC.coordinator = self.coordinator
        bookingConfirmVC.guestEmailArray = self.guestEmailArray.filter { $0 != "" }
        bookingConfirmVC.roomId = self.confirmBookingDetails.meetingId
        bookingConfirmVC.seatingConfigueId = self.seatingConfigueId ?? 0
        bookingConfirmVC.teamMembersArray = self.teamMembersArray.filter { $0 != "" }
        bookingConfirmVC.locationName = self.confirmBookingDetails.location
        bookingConfirmVC.locationId = self.locationId
        bookingConfirmVC.amenitiesArray = [] //amenityNames.filter { $0 != "" }
        bookingConfirmVC.dateOfBooking = dateOfBooking ?? ""
        bookingConfirmVC.modalPresentationStyle = .overFullScreen
        bookingConfirmVC.modalTransitionStyle = .crossDissolve
        bookingConfirmVC.view.backgroundColor = UIColor.clear
        //self.present(bookingConfirmVC, animated: true)
        self.navigationController?.pushViewController(bookingConfirmVC, animated: false)
    }
}
extension BookRoomDetailsViewController {
    enum Event {
        
        case dataLoaded
        case error(Error?)
    }
}
extension BookRoomDetailsViewController:BookButtonActionDelegate{
    func showBookRoomDetailsVC(meetingRoomId: Int) {
    }
    func showBookMeetingRoomsVC() {
    }
    func showLogInVC() {
        
    }
}

