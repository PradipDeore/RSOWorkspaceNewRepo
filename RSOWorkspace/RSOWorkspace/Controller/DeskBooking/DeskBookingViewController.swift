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
    var location: [LocationDetails] = []
    var dropdownOptions: [LocationDetails] = []
    var eventHandler: ((_ event: Event) -> Void)?
    var apiRequestModelDeskListing = DeskRequestModel()
    var displayBookingDetailsNextScreen = ConfirmDeskBookingDetailsModel()
    var deskList:[RSOCollectionItem] = []
    var selectedDeskList:[RSOCollectionItem] = []
    var viewFloorPlanSeatingConfig:[RoomConfiguration] = []
    var teamMembersArray:[String] = [""]
    var freeAmenitiesArrayDesk:[BookingDeskDetailsFreeAmenity] = []
    var deskbookingConfirmDetails = StoreDeskBookingRequest()
    var selectedDeskId = 0
    var locationId = 0
    var selectedLocation = ""
    var selectedDeskNo = ""
    var selectedDeskTypeId = 0
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
        RSOLoader.showLoader()
        self.locationId = 0
        self.displayBookingDetailsNextScreen.location = ""
        self.clearDeskCellData()
        APIManager.shared.request(
            modelType: LocationResponse.self, // Assuming your API returns an array of locations
            type: LocationEndPoint.locations) { response in
                DispatchQueue.main.async {
                    RSOLoader.removeLoader()
                    switch response {
                    case .success(let response):
                        self.dropdownOptions = response.data ?? []
                        if let selectedOption = self.dropdownOptions.first {
                            self.locationId = selectedOption.id ?? 1
                            self.selectedDeskId = selectedOption.id ?? 1
                            self.apiRequestModelDeskListing.locationid = selectedOption.id ?? 1
                            self.displayBookingDetailsNextScreen.location = selectedOption.name ?? "Reef Tower"
                            self.fetchDesksList()
                            self.tableView.reloadData()
                            self.eventHandler?(.dataLoaded)
                        }
                    case .failure(let error):
                        self.eventHandler?(.error(error))
                    }
                }
            }
    }
    private func fetchDesksList() {
        if selectedDeskId > 0{
            self.tableView.reloadData()
        }
    }
    func fetchDesksDetails(id: Int) {
        DispatchQueue.main.async {
            RSOLoader.showLoader()
            self.clearDeskCellData()
        }
        APIManager.shared.request(
            modelType: DeskDetailsResponseModel.self,
            type: DeskBookingEndPoint.DeskDetails(deskId: id)) { [weak self] response in
                DispatchQueue.main.async {
                    RSOLoader.removeLoader()
                    guard let self = self else { return }
                    switch response {
                    case .success(let responseData):
                        // Handle successful response with bookings
                        self.freeAmenitiesArrayDesk = responseData.freeAmenities ?? []
                        print("free amenities desk",self.freeAmenitiesArrayDesk)

                        if let errorMessage = responseData.message, errorMessage.isEmpty == false {
                            self.eventHandler?(.error(errorMessage as? Error))
                            //  Unsuccessful
                            RSOToastView.shared.show("\(errorMessage)", duration: 2.0, position: .center)
                        } else {
                            self.viewFloorPlanSeatingConfig = responseData.roomConfiguration ?? []
                            if let deskList = responseData.deskTypes {
                                let listItems: [RSOCollectionItem] = deskList.map { RSOCollectionItem(deskType: $0) }
                                print("fetchDesk list",listItems)
                                self.deskList = listItems
                                let indexpath1 = IndexPath(row: 0, section: SectionTypeDeskBooking.selectDesks.rawValue)
                                let indexpath2 = IndexPath(row: 0, section: SectionTypeDeskBooking.buttonbookingConfirm.rawValue)
                               
                                self.tableView.reloadRows(at: [indexpath1,indexpath2], with: .automatic)
                                self.showAmenitiesAlert(amenities: self.freeAmenitiesArrayDesk, title: "Desk Amenities Information")
                            }
                            self.eventHandler?(.dataLoaded)
                            
                        }
                    case .failure(let error):
                        self.eventHandler?(.error(error))
                        RSOToastView.shared.show("\(error.localizedDescription)", duration: 2.0, position: .center)
                    }
                }
            }
    }
    func clearDeskCellData() {
        self.deskList = []
        self.deskbookingConfirmDetails.desk_id = []
        self.displayBookingDetailsNextScreen.selected_desk_no = []
        self.selectedDeskList = []
        self.deskbookingConfirmDetails.desk_id = []
        self.viewFloorPlanSeatingConfig = []
        let indexpath1 = IndexPath(row: 0, section: SectionTypeDeskBooking.selectDesks.rawValue)
        let indexpath2 = IndexPath(row: 0, section: SectionTypeDeskBooking.buttonbookingConfirm.rawValue)
        self.tableView.reloadRows(at: [indexpath1,indexpath2], with: .automatic)
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate

extension DeskBookingViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return SectionTypeDeskBooking.allCases.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 3{
            return teamMembersArray.count
        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 3 {
            return UserHelper.shared.isGuest() ? 0: 0
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = SectionHeaderView(reuseIdentifier: "SectionHeaderView")
        if section == 3 {
            headerView.sectionLabel.text = "Add Team Members"
            headerView.sectionLabel.font = RSOFont.poppins(size: 16.0, type: .Medium)
        }  else {
            return nil
        }
        return headerView
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let section = SectionTypeDeskBooking(rawValue: indexPath.section) else { return UITableViewCell() }
        
        switch section {
        case .selectLocation:
            let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifierDeskBooking.selectLocation.rawValue, for: indexPath) as! SelectLocationTableViewCell
            cell.delegate = self
            cell.dropdownOptions = dropdownOptions
            let selectedLocation = self.displayBookingDetailsNextScreen.location
            cell.txtLocation.text = selectedLocation
            cell.selectionStyle = .none
            return cell
        case .selectDate:
            let  cell =  tableView.dequeueReusableCell(withIdentifier: CellIdentifierDeskBooking.selectDate.rawValue, for: indexPath) as! SelectDateTableViewCell
            cell.delegate = self
            cell.bookingTypeSelectTime = .desk

            cell.selectionStyle = .none
            return cell
        case .selectTime:
            let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifierDeskBooking.selectTime.rawValue, for: indexPath) as! SelectTimeTableViewCell
            cell.delegate = self
            cell.bookingTypeSelectTime = .desk
            cell.selectionStyle = .none
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
            cell.selectionStyle = .none
            return cell
        
        case .selectMeetingRoomLabel:
            let cell =  tableView.dequeueReusableCell(withIdentifier: CellIdentifierDeskBooking.selectMeetingRoomLabel.rawValue, for: indexPath) as! SelectMeetingRoomLabelTableViewCell
            cell.lblMeetingRoom.text = "Select Desk Type"
            cell.lblMeetingRoom.font = UIFont(name: "Poppins-SemiBold", size: 14)
            cell.selectionStyle = .none
            return cell
        case .selectDesksType:
            let cell =  tableView.dequeueReusableCell(withIdentifier: CellIdentifierDeskBooking.selectDesksType.rawValue, for: indexPath)as! SelectMeetingRoomTableViewCell
            cell.collectionView.tag = 1
            cell.collectionView.backActionDelegate = self
            cell.collectionView.hideBookButton = true
            cell.eventHandler = { [weak self] event, list in
                
                guard let self = self else { return }
                switch event {
                case .dataLoaded:
                    if list?.isEmpty == true {
                        
                        RSOToastView.shared.show("No Desks Available", duration: 2.0, position: .center)
                    }
                case .error(let error):
                    RSOToastView.shared.show("Error: \(error.localizedDescription)", duration: 2.0, position: .center)
                }
                self.listItems = list ?? []
                print("eventHandler listItems", self.listItems)
            }
            if selectedDeskId > 0{
                cell.fetchDesks(id: selectedDeskId,
                                requestModel: apiRequestModelDeskListing)
                
            }
            cell.selectionStyle = .none
            return cell
        case .selectDesks:
            let cell =  tableView.dequeueReusableCell(withIdentifier: CellIdentifierDeskBooking.selectDesks.rawValue, for: indexPath) as! SelectDesksTableViewCell
            cell.deskList = self.deskList
            cell.btnViewFloorPlan.isUserInteractionEnabled = true
            cell.btnViewFloorPlan.alpha = 1.0
            if viewFloorPlanSeatingConfig.isEmpty {
                cell.btnViewFloorPlan.isUserInteractionEnabled = false
                cell.btnViewFloorPlan.alpha = 0.5
            }
            cell.collectionView.reloadData()
            cell.delegate = self
            cell.selectionStyle = .none
            return cell
        case .buttonbookingConfirm:
            let cell =  tableView.dequeueReusableCell(withIdentifier: CellIdentifierDeskBooking.buttonbookingConfirm.rawValue, for: indexPath) as! ButtonBookingConfirmTableViewCell
            cell.delegate = self
            cell.btnConfirm.setTitle("Confirm Booking", for: .normal)
            let isItemSelected = !selectedDeskList.isEmpty
            cell.btnConfirm.isEnabled = !self.deskList.isEmpty && isItemSelected
            cell.btnConfirm.alpha = cell.btnConfirm.isEnabled ? 1.0 : 0.4
            cell.selectionStyle = .none
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
            return UserHelper.shared.isGuest() ? 0: 0
        case .selectMeetingRoomLabel:
            return 20
        case .selectDesksType:
            return 209
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
        let cellIdentifiers: [CellIdentifierDeskBooking] = [.selectLocation, .selectDate, .selectTime, .addTeamMembers, .selectMeetingRoomLabel, .selectDesksType,.selectDesks,.buttonbookingConfirm]
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
        confirmDeskBookingDetailsVC.deskList = selectedDeskList
        confirmDeskBookingDetailsVC.confirmdeskBookingResponse = displayBookingDetailsNextScreen
        confirmDeskBookingDetailsVC.deskbookingConfirmDetails = self.deskbookingConfirmDetails
        //self.present(confirmDeskBookingDetailsVC,animated: true)
        self.navigationController?.pushViewController(confirmDeskBookingDetailsVC, animated: true)
        
    }
    
}
extension DeskBookingViewController: SelectLocationTableViewCellDelegate {
    
    func dropdownButtonTapped(selectedOption: LocationDetails) {
        // Implement what you want to do with the selected option, for example:
        print("Selected option: \(selectedOption.name),\(selectedOption.id)")
        selectedDeskId = selectedOption.id ?? 1
        apiRequestModelDeskListing.locationid = selectedOption.id ?? 1
        displayBookingDetailsNextScreen.location = selectedOption.name ?? "Reef Tower"
        fetchDesksList()
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
        self.deskbookingConfirmDetails.date = apiDate
        fetchDesksList()
        
    }
}
extension DeskBookingViewController: SelectTimeTableViewCellDelegate{
    func selectFulldayStatus(_ isFullDay: Bool) {
        apiRequestModelDeskListing.isFullDay =  isFullDay ? "Yes" : "No"
    }
    
    func didSelectStartTime(_ startTime: Date) {
        // for api request
        let apiStartTime = Date.formatSelectedDate(format: .HHmm, date: startTime)
        apiRequestModelDeskListing.startTime = apiStartTime
        //display in next vc
        let displayStartTime = Date.formatSelectedDate(format: .hhmma, date: startTime)
        displayBookingDetailsNextScreen.startTime = displayStartTime
        self.deskbookingConfirmDetails.start_time = apiStartTime
        fetchDesksList()
        
    }
    
    func didSelectEndTime(_ endTime: Date) {
        // for api request
        let apiEndTime = Date.formatSelectedDate(format: .HHmm, date: endTime)
        apiRequestModelDeskListing.endTime = apiEndTime
        //display in next vc
        let displayEndTime = Date.formatSelectedDate(format: .hhmma, date: endTime)
        displayBookingDetailsNextScreen.endTime = displayEndTime
        self.deskbookingConfirmDetails.end_time = apiEndTime
        fetchDesksList()
        
        
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
    func sendteamMemberName(member: TeamMembersList) {
        sendteamMemberName(name: member.fullName)
    }
    
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
    func viewFloorPlan() {
        let viewFloorPlanVC = UIViewController.createController(storyBoard: .Booking, ofType: ViewFloorPlanViewController.self)
        viewFloorPlanVC.floorPlansSeatingConfig = self.viewFloorPlanSeatingConfig
        self.navigationController?.pushViewController(viewFloorPlanVC, animated: true)
    }
    
    func getselectedDeskNo(selectedDeskNo: [Int], selectedDeskList: [RSOCollectionItem]) {
       // apiRequestModelDeskListing.desk_id = selectedDeskNo
        deskbookingConfirmDetails.desk_id = selectedDeskNo
        displayBookingDetailsNextScreen.selected_desk_no = selectedDeskNo
        self.selectedDeskList = selectedDeskList
        self.displayBookingDetailsNextScreen.selected_desk_no = selectedDeskNo
        self.deskbookingConfirmDetails.desk_id = selectedDeskNo
        DispatchQueue.main.async {
            let indexpath = IndexPath(row: 0, section: SectionTypeDeskBooking.buttonbookingConfirm.rawValue)
            self.tableView.reloadRows(at: [indexpath], with: .automatic)
        }
    }
    
}

extension DeskBookingViewController:ViewFloorPlanDelegate {
    
       func didSelectConfiguration(_ configuration: RoomConfiguration) {
           print("Selected Configuration: \(configuration)")
       }
}
extension DeskBookingViewController {
    enum Event {
        case dataLoaded
        case error(Error?)
    }
}

extension DeskBookingViewController: BookButtonActionDelegate{
    func showBookRoomDetailsVC(meetingRoomId: Int) {
        let confirmDeskBookingDetailsVC = UIViewController.createController(storyBoard: .Booking, ofType: ConfirmedDeskBookingViewController.self)
        // confirmDeskBookingDetailsVC.meetingId = meetingRoomId
        //confirmDeskBookingDetailsVC.requestModel = apiRequestModelDeskListing
        confirmDeskBookingDetailsVC.deskList = self.deskList
        confirmDeskBookingDetailsVC.confirmdeskBookingResponse = displayBookingDetailsNextScreen
        
        confirmDeskBookingDetailsVC.coordinator = self.coordinator
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
    
    func didSelect(selectedId: Int) {
        self.selectedDeskTypeId = selectedId
        print("selected desk type:", selectedId)
        displayBookingDetailsNextScreen.deskId = selectedId
        deskbookingConfirmDetails.desktype = selectedId
        fetchDesksDetails(id: selectedId)
    }
}
