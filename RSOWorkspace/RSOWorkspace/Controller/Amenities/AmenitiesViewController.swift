//
//  AmenitiesViewController.swift
//  RSOWorkspace
//
//  Created by Sumit Aquil on 02/04/24.
//

import UIKit
enum CellIdentifierAmenities: String {
    case selectLocation = "SelectLocationTableViewCell"
    case btnMeetingsWorkspace = "DashboardDeskTypeTableViewCell"
    case selectMeetingRoom = "SelectMeetingRoomTableViewCell"
    case galleryLabel = "SelectMeetingRoomLabelTableViewCell"
    case gallery = "GalleryTableViewCell"

}

enum SectionTypeAmenities: Int, CaseIterable {
    case selectLocation
    case btnMeetingsWorkspace
    case selectMeetingRoom
    case galleryLabel
    case gallery
}


class AmenitiesViewController: UIViewController,RSOTabCoordinated{
  @IBOutlet weak var tableView: UITableView!
  
  var listItems: [RSOCollectionItem] = []
    var location: [LocationDetails] = []
    var dropdownOptions: [LocationDetails] = []
    var coordinator: RSOTabBarCordinator?

  var eventHandler: ((_ event: Event) -> Void)?
    var selectedButtonType: DashboardOption = .meetingRooms

  var apiRequestModelRoomListing = BookMeetingRoomRequestModel()
  var displayBookingDetailsNextScreen = DisplayBookingDetailsModel()
  var roomList : [MeetingRoomListing] = []
    var requestModel = MeetingRoomItemRequestModel()


  var selectedMeetingRoomId = 0
  var selectedLocation = ""
 var locationId = 0
  
  // var selectedMeetingRoomDate = ""
  override func viewDidLoad() {
    super.viewDidLoad()
    setupTableView()
    fetchLocations()
    fetchRoomsOnPageLoad()
  }
  @IBAction func btnBackAction(_ sender: Any) {
    self.navigationController?.popViewController(animated: true)
    
  }
  private func setupTableView() {
    tableView.dataSource = self
    tableView.delegate = self
    tableView.registertableCells()
    tableView.register(UINib(nibName: "DashboardMeetingRoomsTableViewCell", bundle: nil), forCellReuseIdentifier: "DashboardMeetingRoomsTableViewCell")
    navigationController?.navigationBar.isHidden = true
  }
  
  private func fetchLocations() {
    APIManager.shared.request(
      modelType: LocationResponse.self, // Assuming your API returns an array of locations
      type: LocationEndPoint.locations) { response in
        switch response {
        case .success(let response):
            self.dropdownOptions = response.data ?? []
            
          DispatchQueue.main.async {
            if let selectedOption = self.dropdownOptions.first {
                  self.locationId = selectedOption.id ?? 1
                 self.selectedLocation = selectedOption.name ?? "Reef Tower"
                  self.selectedMeetingRoomId = selectedOption.id ?? 1
                  //self.fetchGallery()
              }
            self.tableView.reloadData()
          }
          self.eventHandler?(.dataLoaded)
        case .failure(let error):
          self.eventHandler?(.error(error))
        }
      }
  }
    private func fetchGallery() {
        if locationId > 0 {
            self.tableView.reloadData()
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
        if let meetingRoomsCell = tableView.cellForRow(at: IndexPath(row: 0, section: SectionTypeAmenities.selectMeetingRoom.rawValue)) as? DashboardMeetingRoomsTableViewCell {
            meetingRoomsCell.fetchRooms(id: 1, requestModel: requestModel)
        } else {
            // Optionally, you can reload the table view and then fetch data
            tableView.reloadSections(IndexSet(integer: SectionTypeAmenities.btnMeetingsWorkspace.rawValue), with: .none)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                // Ensure the cell is available for fetching data after the reload
                if let meetingRoomsCell = self.tableView.cellForRow(at: IndexPath(row: 0, section: SectionTypeAmenities.selectMeetingRoom.rawValue)) as? DashboardMeetingRoomsTableViewCell {
                    meetingRoomsCell.fetchRooms(id: 1, requestModel: self.requestModel)
                } else {
                    print("DashboardMeetingRoomsTableViewCell not found after reload.")
                }
            }
        }
    }
      
}

// MARK: - UITableViewDataSource, UITableViewDelegate

extension AmenitiesViewController: UITableViewDataSource, UITableViewDelegate {
    
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
        guard let section = SectionTypeAmenities(rawValue: indexPath.section) else { return UITableViewCell() }
        
        switch section {
        case .selectLocation:
            let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifierAmenities.selectLocation.rawValue, for: indexPath) as! SelectLocationTableViewCell
            cell.delegate = self
            cell.dropdownOptions = dropdownOptions
            cell.selectionStyle = .none
            cell.txtLocation.text = selectedLocation
            return cell
        
        case .btnMeetingsWorkspace:
            let cell =  tableView.dequeueReusableCell(withIdentifier: CellIdentifierAmenities.btnMeetingsWorkspace.rawValue, for: indexPath) as! DashboardDeskTypeTableViewCell
            cell.btnMembership.isHidden = true
            cell.delegate = self
            cell.selectionStyle = .none

            return cell
        case .galleryLabel:
            let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifierAmenities.galleryLabel.rawValue, for: indexPath)as! SelectMeetingRoomLabelTableViewCell
            cell.lblMeetingRoom.text = "Gallery"
            cell.selectionStyle = .none
            cell.lblMeetingRoom.font = RSOFont.poppins(size: 16, type: .SemiBold)
            return cell
            
        case .selectMeetingRoom:
            let cell = tableView.dequeueReusableCell(withIdentifier: "DashboardMeetingRoomsTableViewCell", for: indexPath) as! DashboardMeetingRoomsTableViewCell
                cell.collectionView.tag = 0
                cell.selectionStyle = .none
                cell.collectionView.backActionDelegate = self
                return cell
        case .gallery:
            let cell =  tableView.dequeueReusableCell(withIdentifier: CellIdentifierAmenities.gallery.rawValue, for: indexPath)as! GalleryTableViewCell
            cell.setLocationID(locationId)
            cell.selectionStyle = .none
            return cell
        }
    }
    var shouldUseDashboardCell: Bool {
        // Add your condition here
        return true // or false based on your logic
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let section = SectionTypeAmenities(rawValue: indexPath.section) else { return 0 }
        
        switch section {
        case .selectLocation:
            return 100
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

extension AmenitiesViewController: SelectLocationTableViewCellDelegate {
    
    func dropdownButtonTapped(selectedOption: LocationDetails) {
        // Implement what you want to do with the selected option, for example:
        print("Selected option: \(selectedOption.name),\(selectedOption.id)")
        self.selectedLocation = selectedOption.name ?? "Reef Tower"
        selectedMeetingRoomId = selectedOption.id ?? 1
        self.locationId = selectedOption.id ?? 1
        // Reload the table view to update meeting room listing
        // Fetch gallery data with the updated locationId
           fetchGallery()
        tableView.reloadData()
    }
    
    func presentAlertController(alertController: UIAlertController) {
        // Present the alert controller from the view controller
        present(alertController, animated: true, completion: nil)
    }
}

extension AmenitiesViewController: DashboardDeskTypeTableViewCellDelegate {
    
    func buttonTapped(type: DashboardOption) {
        DispatchQueue.main.async {
            self.selectedButtonType = type
            // self.tableView.reloadSections(IndexSet(integer: 3), with: .automatic)
            self.tableView.reloadSections(IndexSet(integer: SectionTypeAmenities.btnMeetingsWorkspace.rawValue), with: .automatic)
            
            switch type {
            case .meetingRooms:
                print("Meeting Rooms button tapped")
                
                if let meetingRoomsCell = self.tableView.visibleCells.compactMap({ $0 as? DashboardMeetingRoomsTableViewCell }).first {
                    meetingRoomsCell.fetchRooms(id: 1, requestModel: self.requestModel)
                    
                } else {
                    print("DashboardMeetingRoomsTableViewCell not found")
                }
            case .workspace:
                print("Workspace button tapped")
                
                if let meetingRoomsCell = self.tableView.visibleCells.compactMap({ $0 as? DashboardMeetingRoomsTableViewCell }).first {
                    meetingRoomsCell.fetchOfficeDesk(id: nil, requestModel: nil)
                } else {
                    print("DashboardMeetingRoomsTableViewCell not found")
                }
            case .membership: break
            }
        }
    }
}




// MARK: - Enums

extension AmenitiesViewController {
    enum Event {
        case dataLoaded
        case error(Error?)
    }
   
}

// MARK: - UITableView Extension
    extension UITableView {
        func registertableCells() {
            let cellIdentifiers: [CellIdentifierAmenities] = [.selectLocation, .btnMeetingsWorkspace, .selectMeetingRoom, .galleryLabel, .gallery]
            cellIdentifiers.forEach { reuseIdentifier in
                register(UINib(nibName: reuseIdentifier.rawValue, bundle: nil), forCellReuseIdentifier: reuseIdentifier.rawValue)
            }
        }
    }

extension AmenitiesViewController: BookButtonActionDelegate{
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
