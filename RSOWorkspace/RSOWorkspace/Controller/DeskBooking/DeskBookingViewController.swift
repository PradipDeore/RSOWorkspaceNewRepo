//
//  DeskBookingViewController.swift
//  RSOWorkspace
//
//  Created by Sumit Aquil on 12/04/24.
//

import UIKit

enum CellIdentifierDeskBooking: String {
    case selectLocation = "SelectLocationTableViewCell"
    case selectDate = "SelectDateTableViewCell"
    case selectTime = "SelectTimeTableViewCell"
    case addTeamMembers = "InviteTeamMembersTableViewCell"
    case btnGetRooms = "GetRoomsBtnTableViewCell"
    case selectMeetingRoomLabel = "SelectMeetingRoomLabelTableViewCell"
    case selectDesksType = "SelectMeetingRoomTableViewCell"
    case selectDesks = "SelectDesksTableViewCell"
    case buttonbookingConfirm = "ButtonBookingConfirmTableViewCell"
}

enum SectionTypeDeskBooking: Int, CaseIterable {
    case selectLocation
    case selectDate
    case selectTime
    case addTeamMembers
    case btnGetRooms
    case selectMeetingRoomLabel
    case selectDesksType
    case selectDesks
    case buttonbookingConfirm
}
class DeskBookingViewController: UIViewController{
    
    var coordinator: RSOTabBarCordinator?
    var teamMemberNameDelegate:sendteamMemberNameDelegate?
   
    @IBOutlet weak var tableView: UITableView!
    var listItems: [RSOCollectionItem] = []
    var location: ApiResponse?
    var dropdownOptions: [Location] = []
    var eventHandler: ((_ event: Event) -> Void)?
    var apiRequestModelDeskListing = DeskRequestModel()
    var displayBookingDetailsNextScreen = ConfirmDeskBookingDetailsModel()
  
    var teamMembersArray:[String] = [""]

    var selectedDeskId = 0
    var selectedLocation = ""
    var selectedDeskNo = ""
    // var selectedMeetingRoomDate = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        self.coordinator?.hideBackButton(isHidden: false)
        self.coordinator?.setTitle(title: "Book a Desk")

        setupTableView()
        fetchLocations()
       
    }
  
    private func setupTableView() {
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.registerCellsDeskBooking()
    }
    
    private func fetchLocations() {
        self.eventHandler?(.loading)
        APIManager.shared.request(
            modelType: ApiResponse.self, // Assuming your API returns an array of locations
            type: LocationEndPoint.locations) { response in
                self.eventHandler?(.stopLoading)
                switch response {
                case .success(let response):
                    self.dropdownOptions = response.data
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

// MARK: - UITableViewDataSource, UITableViewDelegate

extension DeskBookingViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return SectionTypeDeskBooking.allCases.count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 3{
            return teamMembersArray.count
        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let section = SectionTypeDeskBooking(rawValue: indexPath.section) else { return UITableViewCell() }
        
        switch section {
        case .selectLocation:
            let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifierDeskBooking.selectLocation.rawValue, for: indexPath) as! SelectLocationTableViewCell
            cell.delegate = self
            cell.dropdownOptions = dropdownOptions
            return cell
        case .selectDate:
            let  cell =  tableView.dequeueReusableCell(withIdentifier: CellIdentifierDeskBooking.selectDate.rawValue, for: indexPath) as! SelectDateTableViewCell
            cell.delegate = self
            return cell
        case .selectTime:
            let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifierDeskBooking.selectTime.rawValue, for: indexPath) as! SelectTimeTableViewCell
            cell.delegate = self
            return cell
        case .addTeamMembers:
            let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifierDeskBooking.addTeamMembers.rawValue, for: indexPath) as! InviteTeamMembersTableViewCell
            cell.delegate = self
            
            cell.lblteammemberName.text = teamMembersArray[indexPath.row]
            cell.btnAdd.isHidden = !(indexPath.row == 0)
            cell.teamMemberView.isHidden = false
            if indexPath.row == 0 {
                if teamMembersArray.first == ""{
                    cell.teamMemberView.isHidden = true
                }
            }
            return cell
        case .btnGetRooms:
            let cell =  tableView.dequeueReusableCell(withIdentifier: CellIdentifierDeskBooking.btnGetRooms.rawValue, for: indexPath) as! GetRoomsBtnTableViewCell
            cell.delegate = self
            return cell
        case .selectMeetingRoomLabel:
            let cell =  tableView.dequeueReusableCell(withIdentifier: CellIdentifierDeskBooking.selectMeetingRoomLabel.rawValue, for: indexPath) as! SelectMeetingRoomLabelTableViewCell
            cell.lblMeetingRoom.text = "Select Desk Type"
            cell.lblMeetingRoom.font = UIFont(name: "Poppins-SemiBold", size: 14)
            return cell
        case .selectDesksType:
            let cell =  tableView.dequeueReusableCell(withIdentifier: CellIdentifierDeskBooking.selectDesksType.rawValue, for: indexPath)as! SelectMeetingRoomTableViewCell
            cell.collectionView.tag = 1
            cell.collectionView.backActionDelegate = self
            
//                        cell.eventHandler = { [weak self] event in
//                            // Handle events here based on the event type
//                            switch event {
//                            case .dataLoaded:
//                                // Handle data loaded event
//                                self?.listItems = cell.collectionView.listItems
//                                if self?.selectedDeskId == 1{
//                                    cell.collectionView.reloadData()
//                                }
//                            default:
//                                print("default")
//                            }
//                        }
            if selectedDeskId > 0{
                cell.fetchDesks(id: selectedDeskId,
                                requestModel: apiRequestModelDeskListing)
                
            }
            return cell
        case .selectDesks:
            let cell =  tableView.dequeueReusableCell(withIdentifier: CellIdentifierDeskBooking.selectDesks.rawValue, for: indexPath) as! SelectDesksTableViewCell
            cell.delegate = self
            return cell
        case .buttonbookingConfirm:
            let cell =  tableView.dequeueReusableCell(withIdentifier: CellIdentifierDeskBooking.buttonbookingConfirm.rawValue, for: indexPath) as! ButtonBookingConfirmTableViewCell
            cell.delegate = self
            cell.btnConfirm.setTitle("Confirm Booking", for: .normal)
            
            return cell
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let section = SectionTypeDeskBooking(rawValue: indexPath.section) else { return 0 }
        
        switch section {
        case .selectLocation:
            return 100
        case .selectDate:
            return 334
        case .selectTime:
            return 80
        case .addTeamMembers:
            return 60
        case .selectMeetingRoomLabel:
            return 20
        case .selectDesksType:
            return 209
        case .btnGetRooms:
            return 46
        case .selectDesks:
            return 80
        case .buttonbookingConfirm:
            return 50
        }
    }
}
// MARK: - UITableView Extension

extension UITableView {
    func registerCellsDeskBooking() {
        let cellIdentifiers: [CellIdentifierDeskBooking] = [.selectLocation, .selectDate, .selectTime, .addTeamMembers,.btnGetRooms, .selectMeetingRoomLabel, .selectDesksType,.selectDesks,.buttonbookingConfirm]
        cellIdentifiers.forEach { reuseIdentifier in
            register(UINib(nibName: reuseIdentifier.rawValue, bundle: nil), forCellReuseIdentifier: reuseIdentifier.rawValue)
        }
    }
}
// MARK: - SelectLocationTableViewCellDelegate
extension DeskBookingViewController:ButtonBookingConfirmTableViewCellDelegate{
    func btnConfirmTappedAction() {
        let confirmDeskBookingDetailsVC = UIViewController.createController(storyBoard: .Booking, ofType: ConfirmedDeskBookingViewController.self)
       // confirmDeskBookingDetailsVC.meetingId = meetingRoomId
        //confirmDeskBookingDetailsVC.requestModel = apiRequestModelDeskListing
        confirmDeskBookingDetailsVC.confirmdeskBookingResponse = displayBookingDetailsNextScreen
        self.present(confirmDeskBookingDetailsVC,animated: true)
    }
    
   
   
}
extension DeskBookingViewController: SelectLocationTableViewCellDelegate {
    
    func dropdownButtonTapped(selectedOption: Location) {
        // Implement what you want to do with the selected option, for example:
        print("Selected option: \(selectedOption.name),\(selectedOption.id)")
      
        selectedDeskId = selectedOption.id
        apiRequestModelDeskListing.locationid = selectedOption.id
        displayBookingDetailsNextScreen.location = selectedOption.name

    }
    
    func presentAlertController(alertController: UIAlertController) {
        // Present the alert controller from the view controller
        present(alertController, animated: true, completion: nil)
    }
}
extension DeskBookingViewController: SelectDateTableViewCellDelegate {
    func didSelectDate(_ actualFormatOfDate: Date) {
        // on date change save api formatted date for this vc model and next vc model
        let apiDate = Date.formatSelectedDate(format: .yyyyMMdd, date: actualFormatOfDate)
        apiRequestModelDeskListing.date = apiDate
        // save formated date to show in next screen
        let displayDate = Date.formatSelectedDate(format: .EEEEddMMMMyyyy, date: actualFormatOfDate)
        displayBookingDetailsNextScreen.date = displayDate
        
    }
}
extension DeskBookingViewController: SelectTimeTableViewCellDelegate{
    func didSelectStartTime(_ startTime: Date) {
        // for api request
        let apiStartTime = Date.formatSelectedDate(format: .HHmm, date: startTime)
        apiRequestModelDeskListing.startTime = apiStartTime
        //display in next vc
        let displayStartTime = Date.formatSelectedDate(format: .hhmma, date: startTime)
        displayBookingDetailsNextScreen.startTime = displayStartTime
    }
    
    func didSelectEndTime(_ endTime: Date) {
        // for api request
        let apiEndTime = Date.formatSelectedDate(format: .HHmm, date: endTime)
        apiRequestModelDeskListing.endTime = apiEndTime
        //display in next vc
        let displayEndTime = Date.formatSelectedDate(format: .hhmma, date: endTime)
        displayBookingDetailsNextScreen.endTime = displayEndTime
        
    }
}
extension DeskBookingViewController:InviteTeamMembersTableViewCellDelegate{
    func btnDeleteTeamMember(buttonTag: Int) {
        teamMembersArray.remove(at:buttonTag)
        if teamMembersArray.isEmpty{
            teamMembersArray.append("")
        }
        tableView.reloadData()
    }
    func btnAddTeamMembersTappedAction() {
            let addTeamMemberVC = UIViewController.createController(storyBoard: .Booking, ofType: AddTeamMemberViewController.self)
            addTeamMemberVC.modalPresentationStyle = .overFullScreen
            addTeamMemberVC.modalTransitionStyle = .crossDissolve
            addTeamMemberVC.view.backgroundColor = UIColor.clear
            addTeamMemberVC.teamMemberNameDelegate = self
            self.present(addTeamMemberVC, animated: true)
        }
}
extension DeskBookingViewController:sendteamMemberNameDelegate{
        
    func sendteamMemberName(name: String) {
            if teamMembersArray.count == 1 && teamMembersArray.first == ""{
                teamMembersArray.remove(at: 0)
            }
            teamMembersArray.append(name)
            //self.confirmBookingDetails.teamMembers = teamMembersArray
       // apiRequestModelDeskListing.teammembers = teamMembersArray
        self.displayBookingDetailsNextScreen.teamMembersArray = teamMembersArray
            tableView.reloadData()
        }
}
extension DeskBookingViewController:SelectedDeskTableViewCellDelegate{
    func getselectedDeskNo(selectedDeskNo: [Int]) {
        //let selectedDeskNoInt = Int(selectedDeskNo)
       // apiRequestModelDeskListing.desk_id = selectedDeskNoInt
        self.displayBookingDetailsNextScreen.teamMembersArray = teamMembersArray
    }
    
    
}
extension DeskBookingViewController: GetRoomsBtnTableViewCellDelegate {
    func getMeetingRooms() {
        if selectedDeskId > 0{
            self.tableView.reloadData()
        }
        else{
            self.view.makeToast("No Rooms Available", duration: 2.0, position: .bottom)
        }
    }
}

// MARK: - Enums

extension DeskBookingViewController {
    enum Event {
        case loading
        case stopLoading
        case dataLoaded
        case error(Error?)
    }
}


extension DeskBookingViewController: BookButtonActionDelegate{
    func showBookRoomDetailsVC(meetingRoomId: Int) {
        let confirmDeskBookingDetailsVC = UIViewController.createController(storyBoard: .Booking, ofType: ConfirmedDeskBookingViewController.self)
       // confirmDeskBookingDetailsVC.meetingId = meetingRoomId
        //confirmDeskBookingDetailsVC.requestModel = apiRequestModelDeskListing
        confirmDeskBookingDetailsVC.confirmdeskBookingResponse = displayBookingDetailsNextScreen
       // confirmDeskBookingDetailsVC.coordinator = self.coordinator
        self.navigationController?.pushViewController(confirmDeskBookingDetailsVC, animated: true)
        
    }
    func showBookMeetingRoomsVC() {
    }
    
    func showLogInVC() {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let sceneDelegate = windowScene.delegate as? SceneDelegate else {
            return
        }
        let loginVC = UIViewController.createController(storyBoard: .GetStarted, ofType: LogInViewController.self)
        sceneDelegate.window?.rootViewController?.present(loginVC, animated: true, completion: nil)
    }
}
