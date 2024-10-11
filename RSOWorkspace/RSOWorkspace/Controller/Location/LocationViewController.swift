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
    case btnMeetingsWorkspace
    case selectMeetingRoom
    case galleryLabel
    case gallery
}

class LocationViewController: UIViewController,RSOTabCoordinated {
    @IBOutlet weak var tableView: UITableView!
    var coordinator: RSOTabBarCordinator?
    var selectedButtonType: DashboardOption = .meetingRooms

    var listItems: [RSOCollectionItem] = []
    var location: [LocationDetails] = []
    var dropdownOptions: [LocationDetails] = []
    var eventHandler: ((_ event: Event) -> Void)?
    var apiRequestModelRoomListing = BookMeetingRoomRequestModel()
    var displayBookingDetailsNextScreen = DisplayBookingDetailsModel()
    var roomList: [MeetingRoomListing] = []
    var selectedMeetingRoomId = 0
    var selectedLocation = ""
    var locationId = 0
    var expandedIndexPath: IndexPath?
    var requestModel = MeetingRoomItemRequestModel()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        fetchLocations()
        fetchRoomsOnPageLoad()
    }
    override func viewWillAppear(_ animated: Bool) {
      super.viewWillAppear(animated)
      print("dashboard view controller view will appear called")
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
        APIManager.shared.request(
            modelType: LocationResponse.self,
            type: LocationEndPoint.locations) { response in
                switch response {
                case .success(let response):
                    self.dropdownOptions = response.data ?? []
                    if let firstLocation = self.dropdownOptions.first {
                        self.selectedLocation = firstLocation.name ?? "Reef Tower"
                        self.locationId = firstLocation.id ?? 1
                        self.selectedMeetingRoomId = firstLocation.id ?? 1
                        self.updateGalleryForLocation(locationId: self.locationId)
                    }

                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                    self.eventHandler?(.dataLoaded)
                case .failure(let error):
                    print("fetch location get failed",error.localizedDescription)
                    self.eventHandler?(.error(error))
                }
            }
    }
    // Method to update gallery based on selected location ID
    func updateGalleryForLocation(locationId: Int) {
        DispatchQueue.main.async {
            guard let galleryCell = self.tableView.cellForRow(at: IndexPath(row: 0, section: SectionTypeLocation.gallery.rawValue)) as? GalleryTableViewCell else {
                return
            }
            galleryCell.setLocationID(locationId)
        }
        
    }
    private func fetchRoomsOnPageLoad() {
            // Ensure the fetch method is called immediately
            if selectedButtonType == .meetingRooms {
                fetchMeetingRooms()
            }
        }
    private func fetchMeetingRooms() {
        // Fetch meeting rooms data directly
        if let meetingRoomsCell = tableView.cellForRow(at: IndexPath(row: 0, section: SectionTypeLocation.selectMeetingRoom.rawValue)) as? DashboardMeetingRoomsTableViewCell {
            meetingRoomsCell.fetchRooms(id: 1, requestModel: requestModel)
        } else {
            // Optionally, you can reload the table view and then fetch data
            tableView.reloadSections(IndexSet(integer: SectionTypeAmenities.btnMeetingsWorkspace.rawValue), with: .none)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                // Ensure the cell is available for fetching data after the reload
                if let meetingRoomsCell = self.tableView.cellForRow(at: IndexPath(row: 0, section: SectionTypeLocation.selectMeetingRoom.rawValue)) as? DashboardMeetingRoomsTableViewCell {
                    meetingRoomsCell.fetchRooms(id: 1, requestModel: self.requestModel)
                } else {
                    print("DashboardMeetingRoomsTableViewCell not found after reload.")
                }
            }
        }
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate
extension LocationViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return SectionTypeLocation.allCases.count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionType = SectionTypeLocation(rawValue: section)!
        switch sectionType {
        case .locationClose:
            return dropdownOptions.count
        case .btnMeetingsWorkspace, .selectMeetingRoom, .galleryLabel, .gallery:
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let sectionType = SectionTypeLocation(rawValue: indexPath.section)!
        
        switch sectionType {
        case .locationClose:
            let isExpanded = expandedIndexPath == indexPath
            if isExpanded {
                let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifierLocation.locationOpen.rawValue, for: indexPath) as! LocationOpenTableViewCell
                cell.lblLocation.text = dropdownOptions[indexPath.row].name
                cell.lblAddress1.text = dropdownOptions[indexPath.row].address1
                cell.lblPhoneNumber.text = dropdownOptions[indexPath.row].phone
                cell.lblGeoLocation.text = dropdownOptions[indexPath.row].geoLocation
                
                cell.selectionStyle = .none
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifierLocation.locationClose.rawValue, for: indexPath) as! LocationCloseTableViewCell
                cell.lblLocation.text = dropdownOptions[indexPath.row].name
                cell.btnLocationArrow.tag = indexPath.row
                cell.btnLocationArrow.addTarget(self, action: #selector(toggleLocationCell(_:)), for: .touchUpInside)
                cell.selectionStyle = .none
                return cell
            }
        case .btnMeetingsWorkspace:
            let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifierLocation.btnMeetingsWorkspace.rawValue, for: indexPath) as! DashboardDeskTypeTableViewCell
            cell.btnMembership.isHidden = true
            cell.delegate = self
            cell.selectionStyle = .none
            return cell
        case .selectMeetingRoom:
            let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifierLocation.selectMeetingRoom.rawValue, for: indexPath) as! DashboardMeetingRoomsTableViewCell
            cell.collectionView.tag = 0
            cell.collectionView.backActionDelegate = self
            cell.selectionStyle = .none
            return cell
        case .galleryLabel:
            let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifierLocation.galleryLabel.rawValue, for: indexPath) as! SelectMeetingRoomLabelTableViewCell
            cell.lblMeetingRoom.text = "Gallery"
            cell.lblMeetingRoom.font = RSOFont.poppins(size: 16, type: .SemiBold)
            cell.selectionStyle = .none
            return cell
        case .gallery:
            let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifierLocation.gallery.rawValue, for: indexPath) as! GalleryTableViewCell
            cell.setLocationID(locationId)
            cell.selectionStyle = .none
            return cell
        }
    }
    
    @objc func toggleLocationCell(_ sender: UIButton) {
        let section = SectionTypeLocation.locationClose.rawValue
        let indexPath = IndexPath(row: sender.tag, section: section)
        
        if expandedIndexPath == indexPath {
            expandedIndexPath = nil
        } else {
            self.updateGalleryForLocation(locationId: self.locationId)
            expandedIndexPath = indexPath
        }
        
        tableView.reloadSections(IndexSet(integer: section), with: .automatic)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Handle cell selection if needed
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let sectionType = SectionTypeLocation(rawValue: indexPath.section)!
        switch sectionType {
        case .locationClose:
            return expandedIndexPath == indexPath ? 286 : 62
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
    func dropdownButtonTapped(selectedOption: LocationDetails) {
        // Implement what you want to do with the selected option
        print("Selected option: \(selectedOption.name),\(selectedOption.id)")
        selectedMeetingRoomId = selectedOption.id ?? 1
        self.locationId = selectedOption.id ?? 1
        tableView.reloadData()
        updateGalleryForLocation(locationId: selectedOption.id ?? 1)
        
    }
    
    func presentAlertController(alertController: UIAlertController) {
        present(alertController, animated: true, completion: nil)
    }
}

// MARK: - DashboardDeskTypeTableViewCellDelegate
extension LocationViewController: DashboardDeskTypeTableViewCellDelegate {
    func buttonTapped(type: DashboardOption) {

    DispatchQueue.main.async {
        self.selectedButtonType = DashboardOption(rawValue: type.rawValue) ?? .meetingRooms
        self.tableView.reloadSections(IndexSet(integer: 2), with: .automatic)
        
        switch type {
        case .meetingRooms:
            if let meetingRoomsCell = self.tableView.visibleCells.compactMap({ $0 as? DashboardMeetingRoomsTableViewCell }).first {
                meetingRoomsCell.fetchRooms(id: 1, requestModel: self.requestModel)
            } else {
                print("DashboardMeetingRoomsTableViewCell not found")
            }
        case .workspace:
            if let meetingRoomsCell = self.tableView.visibleCells.compactMap({ $0 as? DashboardMeetingRoomsTableViewCell }).first {
                meetingRoomsCell.fetchOfficeDesk(id: nil, requestModel: nil)
            } else {
                print("DashboardMeetingRoomsTableViewCell not found")
            }
        case .membership:
            // Handle membership case if needed
            break
        }
    }
}
}

// MARK: - UITableView Extension
extension UITableView {
    func registertableCellsLocation() {
        let cellIdentifiers: [CellIdentifierLocation] = [.locationClose, .locationOpen, .btnMeetingsWorkspace, .selectMeetingRoom, .galleryLabel, .gallery]
        cellIdentifiers.forEach { reuseIdentifier in
            register(UINib(nibName: reuseIdentifier.rawValue, bundle: nil), forCellReuseIdentifier: reuseIdentifier.rawValue)
        }
    }
}

// MARK: - BookButtonActionDelegate
extension LocationViewController: BookButtonActionDelegate {
    func showShortTermOfficeBookingVC(){
        let bookOfficeVC = UIViewController.createController(storyBoard: .OfficeBooking, ofType: ShortTermBookAnOfficeViewController.self)
        bookOfficeVC.coordinator = self.coordinator
        self.navigationController?.pushViewController(bookOfficeVC, animated: true)
    }
    func showBookRoomDetailsVC(meetingRoomId: Int) {

    }
    // not used
    func showDeskBookingVC() {
    }
        func showBookMeetingRoomsVC() {
            print("from amenities")
                    if self.selectedButtonType == .meetingRooms {
              let bookMeetingRoomVC = UIViewController.createController(storyBoard: .Booking, ofType: BookMeetingRoomViewController.self)
              bookMeetingRoomVC.coordinator = self.coordinator
              self.navigationController?.pushViewController(bookMeetingRoomVC, animated: true)
            } else {
              let bookOfficeVC = UIViewController.createController(storyBoard: .OfficeBooking, ofType: ShortTermBookAnOfficeViewController.self)
              bookOfficeVC.coordinator = self.coordinator
              self.navigationController?.pushViewController(bookOfficeVC, animated: true)
            }
          
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

// MARK: - Enums
extension LocationViewController {
    enum Event {
        
        case dataLoaded
        case error(Error?)
    }
}
