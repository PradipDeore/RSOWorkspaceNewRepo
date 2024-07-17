
//BookMeetingRoomViewController.swift
//  RSOWorkspace
//
//  Created by Sumit Aquil on 29/02/24.


import UIKit
import SwiftUI
import Toast_Swift

enum CellIdentifier: String {
    case selectLocation = "SelectLocationTableViewCell"
    case selectDate = "SelectDateTableViewCell"
    case selectTime = "SelectTimeTableViewCell"
    case btnGetRooms = "GetRoomsBtnTableViewCell"
    case selectMeetingRoomLabel = "SelectMeetingRoomLabelTableViewCell"
    case selectMeetingRoom = "SelectMeetingRoomTableViewCell"
}

enum SectionType: Int, CaseIterable {
    case selectLocation
    case selectDate
    case selectTime
    case btnGetRooms
    case selectMeetingRoomLabel
    case selectMeetingRoom
}


class BookMeetingRoomViewController: UIViewController{
    var coordinator: RSOTabBarCordinator?
    
    @IBOutlet weak var tableView: UITableView!
    var listItems: [RSOCollectionItem] = []
    var location: ApiResponse?
    var dropdownOptions: [Location] = []
    var eventHandler: ((_ event: Event) -> Void)?
    var apiRequestModelRoomListing = BookMeetingRoomRequestModel()
    var displayBookingDetailsNextScreen = DisplayBookingDetailsModel()
    
    var selectedMeetingRoomId = 0
    var selectedLocation = ""
    var locationId:Int = 0

    // var selectedMeetingRoomDate = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        self.coordinator?.hideBackButton(isHidden: false)
        self.coordinator?.setTitle(title: "Book a Meeting Room")

        setupTableView()
        fetchLocations()
    }
    
    private func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.registerCells()
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

extension BookMeetingRoomViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return SectionType.allCases.count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let section = SectionType(rawValue: indexPath.section) else { return UITableViewCell() }
        
        switch section {
        case .selectLocation:
            let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.selectLocation.rawValue, for: indexPath) as! SelectLocationTableViewCell
            cell.delegate = self
            cell.dropdownOptions = dropdownOptions
            return cell
        case .selectDate:
            let  cell =  tableView.dequeueReusableCell(withIdentifier: CellIdentifier.selectDate.rawValue, for: indexPath) as! SelectDateTableViewCell
            cell.delegate = self
            return cell
        case .selectTime:
            let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.selectTime.rawValue, for: indexPath) as! SelectTimeTableViewCell
            cell.delegate = self
            return cell
        case .btnGetRooms:
            let cell =  tableView.dequeueReusableCell(withIdentifier: CellIdentifier.btnGetRooms.rawValue, for: indexPath) as! GetRoomsBtnTableViewCell
            cell.delegate = self
            return cell
        case .selectMeetingRoomLabel:
            return tableView.dequeueReusableCell(withIdentifier: CellIdentifier.selectMeetingRoomLabel.rawValue, for: indexPath)
        case .selectMeetingRoom:
            let cell =  tableView.dequeueReusableCell(withIdentifier: CellIdentifier.selectMeetingRoom.rawValue, for: indexPath)as! SelectMeetingRoomTableViewCell
            cell.collectionView.tag = 1
            cell.collectionView.backActionDelegate = self
            
            cell.eventHandler = { [weak self] event in
                // Handle events here based on the event type
                switch event {
                case .dataLoaded:
                    // Handle data loaded event
                    self?.listItems = cell.collectionView.listItems
                    print("cell.collectionView.listItems=",cell.collectionView.listItems)
                default:
                    print("default")
                }
            }
            if selectedMeetingRoomId > 0{
                cell.fetchmeetingRooms(id: selectedMeetingRoomId,
                                       requestModel: apiRequestModelRoomListing)
                
            }
            return cell
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let section = SectionType(rawValue: indexPath.section) else { return 0 }
        
        switch section {
        case .selectLocation:
            return 100
        case .selectDate:
            return 334
        case .selectTime:
            return 80
        case .selectMeetingRoomLabel:
            return 20
        case .selectMeetingRoom:
            return 209
        case .btnGetRooms:
            return 46
        }
    }
}
// MARK: - SelectLocationTableViewCellDelegate

extension BookMeetingRoomViewController: SelectLocationTableViewCellDelegate {
    
    func dropdownButtonTapped(selectedOption: Location) {
        // Implement what you want to do with the selected option, for example:
        print("Selected option: \(selectedOption.name),\(selectedOption.id)")
        selectedMeetingRoomId = selectedOption.id
        locationId = selectedOption.id
        displayBookingDetailsNextScreen.location = selectedOption.name
    }
    
    func presentAlertController(alertController: UIAlertController) {
        // Present the alert controller from the view controller
        present(alertController, animated: true, completion: nil)
    }
}
extension BookMeetingRoomViewController: SelectDateTableViewCellDelegate {
    func didSelectDate(_ actualFormatOfDate: Date) {
        // on date change save api formatted date for this vc model and next vc model
        let apiDate = Date.formatSelectedDate(format: .yyyyMMdd, date: actualFormatOfDate)
        apiRequestModelRoomListing.date = apiDate
        // save formated date to show in next screen
        let displayDate = Date.formatSelectedDate(format: .EEEEddMMMMyyyy, date: actualFormatOfDate)
        displayBookingDetailsNextScreen.date = displayDate
        
    }
}
extension BookMeetingRoomViewController: SelectTimeTableViewCellDelegate{
    func didSelectStartTime(_ startTime: Date) {
        // for api request
        let apiStartTime = Date.formatSelectedDate(format: .HHmm, date: startTime)
        apiRequestModelRoomListing.startTime = apiStartTime
        //display in next vc
        let displayStartTime = Date.formatSelectedDate(format: .hhmma, date: startTime)
        displayBookingDetailsNextScreen.startTime = displayStartTime
    }
    
    func didSelectEndTime(_ endTime: Date) {
        // for api request
        let apiEndTime = Date.formatSelectedDate(format: .HHmm, date: endTime)
        apiRequestModelRoomListing.endTime = apiEndTime
        //display in next vc
        let displayEndTime = Date.formatSelectedDate(format: .hhmma, date: endTime)
        displayBookingDetailsNextScreen.endTime = displayEndTime
        
    }
}
extension BookMeetingRoomViewController: GetRoomsBtnTableViewCellDelegate {
    func getMeetingRooms() {
        if selectedMeetingRoomId > 0{
            self.tableView.reloadData()
        }
        else{
            self.view.makeToast("No Rooms Available", duration: 2.0, position: .bottom)
        }
    }
}

// MARK: - Enums

extension BookMeetingRoomViewController {
    enum Event {
        case loading
        case stopLoading
        case dataLoaded
        case error(Error?)
    }
}

// MARK: - UITableView Extension

extension UITableView {
    func registerCells() {
        let cellIdentifiers: [CellIdentifier] = [.selectLocation, .selectDate, .selectTime, .btnGetRooms, .selectMeetingRoomLabel, .selectMeetingRoom]
        cellIdentifiers.forEach { reuseIdentifier in
            register(UINib(nibName: reuseIdentifier.rawValue, bundle: nil), forCellReuseIdentifier: reuseIdentifier.rawValue)
        }
    }
}
extension BookMeetingRoomViewController: BookButtonActionDelegate{
    func showBookRoomDetailsVC(meetingRoomId: Int) {
        let bookRoomDetailsVC = UIViewController.createController(storyBoard: .Booking, ofType: BookRoomDetailsViewController.self)
        bookRoomDetailsVC.meetingId = meetingRoomId
        bookRoomDetailsVC.requestModel = apiRequestModelRoomListing
        bookRoomDetailsVC.displayBookingDetails = displayBookingDetailsNextScreen
        bookRoomDetailsVC.coordinator = self.coordinator
        bookRoomDetailsVC.locationId = locationId
        bookRoomDetailsVC.listItems = listItems.filter({ $0.id == meetingRoomId })
        self.navigationController?.pushViewController(bookRoomDetailsVC, animated: true)
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
