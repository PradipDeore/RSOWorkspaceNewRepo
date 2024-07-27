//
//  ShortTermBookAnOfficeViewController.swift
//  RSOWorkspace
//
//  Created by Sumit Aquil on 25/07/24.
//

import Foundation
import UIKit

enum CellIdentifierOfficeBooking: String {
  case selectLocation = "SelectLocationTableViewCell"
  case selectDate = "SelectDateTableViewCell"
  case selectTime = "SelectTimeTableViewCell"
  case selectMeetingRoomLabel = "SelectMeetingRoomLabelTableViewCell"
  case selectOfficeType = "SelectMeetingRoomTableViewCell"
  case buttonbookingConfirm = "ButtonBookingConfirmTableViewCell"
}

enum SectionTypeOfficeBooking: Int, CaseIterable {
  case selectLocation
  case selectDate
  case selectTime
  case selectMeetingRoomLabel
  case selectOfficeType
  case buttonbookingConfirm
}

class ShortTermBookAnOfficeViewController: UIViewController{
  
  var coordinator: RSOTabBarCordinator?
  var teamMemberNameDelegate:sendteamMemberNameDelegate?
  
  @IBOutlet weak var tableView: UITableView!
  var listItems: [RSOCollectionItem] = []
  var location: ApiResponse?
  var dropdownOptions: [Location] = []
  var eventHandler: ((_ event: Event) -> Void)?
  var apiRequestModelOfficeListing = BookOfficeRequestModel()
  var displayBookingDetailsNextScreen = ConfirmDeskBookingDetailsModel()
  var officeList:[RSOCollectionItem] = []
  var selectedOfficeList:[RSOCollectionItem] = []
  var viewFloorPlanSeatingConfig:[RoomConfiguration] = []
  var deskbookingConfirmDetails = StoreDeskBookingRequest()
  var selectedOfficeId = 0
  var locationId = 0
  var selectedLocation = ""
  var selectedDeskNo = ""
  var selectedOfficeTypeId = 0
  // var selectedMeetingRoomDate = ""
  override func viewDidLoad() {
    super.viewDidLoad()
    self.coordinator?.hideBackButton(isHidden: false)
    self.coordinator?.setTitle(title: "Book a Office")
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
    APIManager.shared.request(
      modelType: ApiResponse.self, // Assuming your API returns an array of locations
      type: LocationEndPoint.locations) { response in
        DispatchQueue.main.async {
          RSOLoader.removeLoader()
          switch response {
          case .success(let response):
            self.dropdownOptions = response.data
            if let selectedOption = self.dropdownOptions.last {
              self.locationId = selectedOption.id
              self.selectedOfficeId = selectedOption.id
             // self.apiRequestModelDeskListing.locationid = selectedOption.id
              self.displayBookingDetailsNextScreen.location = selectedOption.name
                self.fetchOfficeList()
              self.tableView.reloadData()
              self.eventHandler?(.dataLoaded)
            }
          case .failure(let error):
            self.eventHandler?(.error(error))
          }
        }
      }
  }
    
    private func fetchOfficeList() {
          if selectedOfficeId > 0{
            self.tableView.reloadData()
        }
    }
 
}

// MARK: - UITableViewDataSource, UITableViewDelegate

extension ShortTermBookAnOfficeViewController: UITableViewDataSource, UITableViewDelegate {
  
  func numberOfSections(in tableView: UITableView) -> Int {
    return SectionTypeDeskBooking.allCases.count
  }
  
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
          return 1
    }
  
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
      return 10
  }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let section = SectionTypeOfficeBooking(rawValue: indexPath.section) else { return UITableViewCell() }
    
    switch section {
    case .selectLocation:
      let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifierOfficeBooking.selectLocation.rawValue, for: indexPath) as! SelectLocationTableViewCell
      cell.delegate = self
      cell.dropdownOptions = dropdownOptions
      let selectedLocation = self.displayBookingDetailsNextScreen.location
      cell.txtLocation.text = selectedLocation
      cell.selectionStyle = .none
      return cell
    case .selectDate:
      let  cell =  tableView.dequeueReusableCell(withIdentifier: CellIdentifierOfficeBooking.selectDate.rawValue, for: indexPath) as! SelectDateTableViewCell
      cell.delegate = self
      cell.selectionStyle = .none
      return cell
    case .selectTime:
      let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifierOfficeBooking.selectTime.rawValue, for: indexPath) as! SelectTimeTableViewCell
      cell.delegate = self
      cell.selectionStyle = .none
      return cell
   
    case .selectMeetingRoomLabel:
      let cell =  tableView.dequeueReusableCell(withIdentifier: CellIdentifierOfficeBooking.selectMeetingRoomLabel.rawValue, for: indexPath) as! SelectMeetingRoomLabelTableViewCell
      cell.lblMeetingRoom.text = "Select Office Type"
      cell.lblMeetingRoom.font = UIFont(name: "Poppins-SemiBold", size: 14)
      cell.selectionStyle = .none
      return cell
    case .selectOfficeType:
      let cell =  tableView.dequeueReusableCell(withIdentifier: CellIdentifierOfficeBooking.selectOfficeType.rawValue, for: indexPath)as! SelectMeetingRoomTableViewCell
      cell.collectionView.tag = 1
      cell.collectionView.hideBookButton = true
      cell.collectionView.backActionDelegate = self
      cell.eventHandler = { [weak self] event, list in
            guard let self = self else { return }
            switch event {
            case .dataLoaded:
                if list?.isEmpty == true {
                    RSOToastView.shared.show("No Offices Available", duration: 2.0, position: .center)
                }
            case .error(let error):
                RSOToastView.shared.show("Error: \(error.localizedDescription)", duration: 2.0, position: .center)
            }
            self.listItems = list ?? []
            print("eventHandler listItems", self.listItems)
        }
      if selectedOfficeId > 0{
        cell.fetchOfficeDesk(id: selectedOfficeId,
                        requestModel: apiRequestModelOfficeListing)
        
      }
      cell.selectionStyle = .none
      return cell

    case .buttonbookingConfirm:
      let cell =  tableView.dequeueReusableCell(withIdentifier: CellIdentifierOfficeBooking.buttonbookingConfirm.rawValue, for: indexPath) as! ButtonBookingConfirmTableViewCell
      cell.delegate = self
      cell.btnConfirm.setTitle("Confirm Booking", for: .normal)
      let isItemSelected = self.selectedOfficeTypeId > 0
      cell.btnConfirm.isEnabled =  isItemSelected
      cell.btnConfirm.alpha = cell.btnConfirm.isEnabled ? 1.0 : 0.4
      cell.selectionStyle = .none
      return cell
   
    }
  }
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    guard let section = SectionTypeOfficeBooking(rawValue: indexPath.section) else { return 0 }
    
    switch section {
    case .selectLocation:
      return 100
    case .selectDate:
      return 334
    case .selectTime:
      return 80
    case .selectMeetingRoomLabel:
      return 20
    case .selectOfficeType:
      return 209
    case .buttonbookingConfirm:
      return 50
    }
  }
}
// MARK: - UITableView Extension

extension UITableView {
  func registerCellsOfficeBooking() {
    let cellIdentifiers: [CellIdentifierOfficeBooking] = [.selectLocation, .selectDate, .selectTime,.selectMeetingRoomLabel, .selectOfficeType,.buttonbookingConfirm]
    cellIdentifiers.forEach { reuseIdentifier in
      register(UINib(nibName: reuseIdentifier.rawValue, bundle: nil), forCellReuseIdentifier: reuseIdentifier.rawValue)
    }
  }
}
// MARK: - SelectLocationTableViewCellDelegate
extension ShortTermBookAnOfficeViewController:ButtonBookingConfirmTableViewCellDelegate{
  func btnConfirmTappedAction() {
    let confirmOfficeBookingDetailsVC = UIViewController.createController(storyBoard: .Booking, ofType: ConfirmShortTermBookingViewController.self)
    // confirmDeskBookingDetailsVC.meetingId = meetingRoomId
    //confirmDeskBookingDetailsVC.requestModel = apiRequestModelDeskListing
      confirmOfficeBookingDetailsVC.deskList = selectedOfficeList
      confirmOfficeBookingDetailsVC.confirmdeskBookingResponse = displayBookingDetailsNextScreen
      confirmOfficeBookingDetailsVC.deskbookingConfirmDetails = self.deskbookingConfirmDetails
    //self.present(confirmDeskBookingDetailsVC,animated: true)
    self.navigationController?.pushViewController(confirmOfficeBookingDetailsVC, animated: true)
    
  }
  
}
extension ShortTermBookAnOfficeViewController: SelectLocationTableViewCellDelegate {
  
  func dropdownButtonTapped(selectedOption: Location) {
    // Implement what you want to do with the selected option, for example:
    print("Selected option: \(selectedOption.name),\(selectedOption.id)")
    selectedOfficeId = selectedOption.id
    //apiRequestModelDeskListing.locationid = selectedOption.id
    displayBookingDetailsNextScreen.location = selectedOption.name
      self.fetchOfficeList()
  }
  
  func presentAlertController(alertController: UIAlertController) {
    // Present the alert controller from the view controller
    present(alertController, animated: true, completion: nil)
  }
}
extension ShortTermBookAnOfficeViewController: SelectDateTableViewCellDelegate {
  func didSelectDate(_ actualFormatOfDate: Date) {
    // on date change save api formatted date for this vc model and next vc model
    let apiDate = Date.formatSelectedDate(format: .yyyyMMdd, date: actualFormatOfDate)
    apiRequestModelOfficeListing.date = apiDate
    // save formated date to show in next screen
    let displayDate = Date.formatSelectedDate(format: .EEEEddMMMMyyyy, date: actualFormatOfDate)
    displayBookingDetailsNextScreen.date = displayDate
    self.deskbookingConfirmDetails.date = apiDate
      self.fetchOfficeList()
  }
}
extension ShortTermBookAnOfficeViewController: SelectTimeTableViewCellDelegate{
  func selectFulldayStatus(_ isFullDay: Bool) {
    apiRequestModelOfficeListing.isFullDay =  isFullDay ? "Yes" : "No"
  }
  
  func didSelectStartTime(_ startTime: Date) {
    // for api request
    let apiStartTime = Date.formatSelectedDate(format: .HHmm, date: startTime)
    apiRequestModelOfficeListing.startTime = apiStartTime
    //display in next vc
    let displayStartTime = Date.formatSelectedDate(format: .hhmma, date: startTime)
    displayBookingDetailsNextScreen.startTime = displayStartTime
    self.deskbookingConfirmDetails.start_time = apiStartTime
      self.fetchOfficeList()
    
  }
  
  func didSelectEndTime(_ endTime: Date) {
    // for api request
    let apiEndTime = Date.formatSelectedDate(format: .HHmm, date: endTime)
    apiRequestModelOfficeListing.endTime = apiEndTime
    //display in next vc
    let displayEndTime = Date.formatSelectedDate(format: .hhmma, date: endTime)
    displayBookingDetailsNextScreen.endTime = displayEndTime
    self.deskbookingConfirmDetails.end_time = apiEndTime
      self.fetchOfficeList()
  }
}


extension ShortTermBookAnOfficeViewController {
  enum Event {
    case dataLoaded
    case error(Error?)
  }
}

extension ShortTermBookAnOfficeViewController: BookButtonActionDelegate{
  func showBookRoomDetailsVC(meetingRoomId: Int) {
      let confirmDeskBookingDetailsVC = UIViewController.createController(storyBoard: .Booking, ofType: ConfirmedDeskBookingViewController.self)
      // confirmDeskBookingDetailsVC.meetingId = meetingRoomId
      //confirmDeskBookingDetailsVC.requestModel = apiRequestModelDeskListing
      confirmDeskBookingDetailsVC.deskList = self.officeList
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
      DispatchQueue.main.async{
          self.selectedOfficeTypeId = selectedId
          print("selected office type:", selectedId)
          self.displayBookingDetailsNextScreen.deskId = selectedId
          self.deskbookingConfirmDetails.desktype = selectedId
          let indexpath = IndexPath(row: 0, section: SectionTypeOfficeBooking.buttonbookingConfirm.rawValue)
          self.tableView.reloadRows(at: [indexpath], with: .automatic)
      }
  }
}
