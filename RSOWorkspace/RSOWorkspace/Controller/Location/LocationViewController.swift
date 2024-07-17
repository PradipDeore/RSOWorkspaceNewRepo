//
//  LocationViewController.swift
//  RSOWorkspace
//
//  Created by Sumit Aquil on 02/04/24.
//

import UIKit

enum CellIdentifierLocation: String {
    case locationClose = "LocationCloseTableViewCell"
    case locationOpen = "LocationOpenTableViewCell"
    case btnMeetingsWorkspace = "DashboardDeskTypeTableViewCell"
    case selectMeetingRoom = "DashboardMeetingRoomsTableViewCell"
    case galleryLabel = "SelectMeetingRoomLabelTableViewCell"
    case gallery = "GalleryTableViewCell"
    
}

enum SectionTypeLocation: Int, CaseIterable {
    case locationClose
    case locationOpen
    case btnMeetingsWorkspace
    case selectMeetingRoom
    case galleryLabel
    case gallery
}

class LocationViewController: UIViewController{
    @IBOutlet weak var tableView: UITableView!
    
    var listItems: [RSOCollectionItem] = []
    var location: ApiResponse?
    var dropdownOptions: [Location] = []
    var eventHandler: ((_ event: Event) -> Void)?
    var apiRequestModelRoomListing = BookMeetingRoomRequestModel()
    var displayBookingDetailsNextScreen = DisplayBookingDetailsModel()
    var roomList : [MeetingRoomListing] = []
    var selectedMeetingRoomId = 0
    var selectedLocation = ""
    var isLocationOpenCellExpanded: Bool = false

    // var selectedMeetingRoomDate = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        fetchLocations()
    }
    @IBAction func btnBackAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
        
    }
    private func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.registertableCellsLocation()
        
        navigationController?.navigationBar.isHidden = true
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
    @objc func expandButtonTapped(_ sender: UIButton) {
            guard let cell = sender.superview?.superview as? LocationCloseTableViewCell,
                  let indexPath = tableView.indexPath(for: cell) else {
                return
            }
            
            // Toggle expansion state
            isLocationOpenCellExpanded.toggle()
            
            // Reload the table view
            tableView.reloadSections(IndexSet(integer: indexPath.section), with: .automatic)
        }
        
    
}

// MARK: - UITableViewDataSource, UITableViewDelegate

extension LocationViewController: UITableViewDataSource, UITableViewDelegate {
    
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
        if section == 0{
            return isLocationOpenCellExpanded ? 2 : 1

        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let section = SectionTypeLocation(rawValue: indexPath.section) else { return UITableViewCell() }
        
        switch section {
        case .locationClose:
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifierLocation.locationClose.rawValue, for: indexPath) as! LocationCloseTableViewCell
                cell.btnLocationArrow.addTarget(self, action: #selector(expandButtonTapped), for: .touchUpInside)
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifierLocation.locationOpen.rawValue, for: indexPath) as! LocationOpenTableViewCell
                cell.isExpanded = isLocationOpenCellExpanded

                return cell
            }
        case .locationOpen:
            let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifierLocation.locationOpen.rawValue, for: indexPath) as! LocationOpenTableViewCell
            cell.isExpanded = isLocationOpenCellExpanded

            return cell
            
        case .btnMeetingsWorkspace:
            let cell =  tableView.dequeueReusableCell(withIdentifier: CellIdentifierLocation.btnMeetingsWorkspace.rawValue, for: indexPath) as! DashboardDeskTypeTableViewCell
            cell.btnMembership.isHidden = true
            cell.delegate = self
            return cell
            
        case .galleryLabel:
            let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifierLocation.galleryLabel.rawValue, for: indexPath)as! SelectMeetingRoomLabelTableViewCell
            cell.lblMeetingRoom.text = "Gallery"
            cell.lblMeetingRoom.font = RSOFont.poppins(size: 16, type: .SemiBold)
            return cell
            
        case .selectMeetingRoom:
            let cell =  tableView.dequeueReusableCell(withIdentifier: CellIdentifierLocation.selectMeetingRoom.rawValue, for: indexPath)as! DashboardMeetingRoomsTableViewCell
            cell.collectionView.tag = 1
            cell.collectionView.backActionDelegate = self
            
            return cell
        case .gallery:
            let cell =  tableView.dequeueReusableCell(withIdentifier: CellIdentifierLocation.gallery.rawValue, for: indexPath)as! GalleryTableViewCell
            return cell
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let section = SectionTypeLocation(rawValue: indexPath.section) else { return 0 }
        
        switch section {
        case .locationClose:
            return 62
        case .locationOpen:
            return 286
        case .btnMeetingsWorkspace:
            return 35
        case .selectMeetingRoom:
            return 209
        case .galleryLabel:
            return 20
        case .gallery:
            return 209
        }
    }
}
// MARK: - SelectLocationTableViewCellDelegate

extension LocationViewController: SelectLocationTableViewCellDelegate {
    
    func dropdownButtonTapped(selectedOption: Location) {
        // Implement what you want to do with the selected option, for example:
        print("Selected option: \(selectedOption.name),\(selectedOption.id)")
        selectedMeetingRoomId = selectedOption.id
        //displayBookingDetailsNextScreen.location = selectedOption.name
        // Reload the table view to update meeting room listing
        tableView.reloadData()
    }
    
    func presentAlertController(alertController: UIAlertController) {
        // Present the alert controller from the view controller
        present(alertController, animated: true, completion: nil)
    }
}

// MARK: - Enums

extension LocationViewController {
    enum Event {
        case loading
        case stopLoading
        case dataLoaded
        case error(Error?)
    }
    
}
extension LocationViewController: DashboardDeskTypeTableViewCellDelegate {
    func buttonTapped(type: String) {
           switch type {
           case "Meetings":
               if let meetingRoomsCell = tableView.visibleCells.compactMap({ $0 as? DashboardMeetingRoomsTableViewCell }).first {
                   meetingRoomsCell.fetchRooms()
               } else {
                   print("DashboardMeetingRoomsTableViewCell not found")
               }
           case "Workspace":
               if let meetingRoomsCell = tableView.visibleCells.compactMap({ $0 as? DashboardMeetingRoomsTableViewCell }).first {
                   meetingRoomsCell.fetchOfficeDesk()
               } else {
                   print("DashboardMeetingRoomsTableViewCell not found")
               }
           default:
               break
           }
       }
    }
// MARK: - UITableView Extension
extension UITableView {
    func registertableCellsLocation() {
        let cellIdentifiers: [CellIdentifierLocation] = [.locationClose,.locationOpen, .btnMeetingsWorkspace, .selectMeetingRoom, .galleryLabel, .gallery]
        cellIdentifiers.forEach { reuseIdentifier in
            register(UINib(nibName: reuseIdentifier.rawValue, bundle: nil), forCellReuseIdentifier: reuseIdentifier.rawValue)
        }
    }
}

extension LocationViewController: BookButtonActionDelegate{
    func showBookRoomDetailsVC(meetingRoomId: Int) {
        let bookRoomDetailsVC = UIViewController.createController(storyBoard: .Booking, ofType: BookRoomDetailsViewController.self)
        bookRoomDetailsVC.meetingId = meetingRoomId
        bookRoomDetailsVC.requestModel = apiRequestModelRoomListing
        bookRoomDetailsVC.displayBookingDetails = displayBookingDetailsNextScreen
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
