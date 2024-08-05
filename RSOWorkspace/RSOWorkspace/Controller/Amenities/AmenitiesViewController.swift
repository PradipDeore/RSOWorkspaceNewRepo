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
class AmenitiesViewController: UIViewController{
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
 var locationId = 0
  
  // var selectedMeetingRoomDate = ""
  override func viewDidLoad() {
    super.viewDidLoad()
    setupTableView()
    fetchLocations()
    fetchMeetingRoomsAndReloadTable()
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
      modelType: ApiResponse.self, // Assuming your API returns an array of locations
      type: LocationEndPoint.locations) { response in
        switch response {
        case .success(let response):
          self.dropdownOptions = response.data
            
          DispatchQueue.main.async {
            if let selectedOption = self.dropdownOptions.last {
                  self.locationId = selectedOption.id
                 self.selectedLocation = selectedOption.name
                  self.selectedMeetingRoomId = selectedOption.id
                  self.fetchGallery()
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
  //to display meeting rooms on load also not working
  private func fetchMeetingRoomsAndReloadTable() {
    RSOLoader.showLoader()
    fetchmeetingRooms(id: selectedMeetingRoomId, requestModel: apiRequestModelRoomListing)
    tableView.reloadData()
  }
  func fetchmeetingRooms(id: Int, requestModel: BookMeetingRoomRequestModel) {
    
    APIManager.shared.request(
      modelType: MeetingRoomListingResponse.self,
      type: MyBookingEndPoint.getAvailableMeetingRoomListing(id: id, requestModel: requestModel)) { [weak self] response in
        DispatchQueue.main.async {
          guard let self = self else { return }
          RSOLoader.removeLoader()
          switch response {
          case .success(let responseData):
            // Handle successful response with bookings
            self.roomList = responseData.data
            
            self.tableView.reloadData()
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
            if shouldUseDashboardCell { // Add your condition here
                        let cell = tableView.dequeueReusableCell(withIdentifier: "DashboardMeetingRoomsTableViewCell", for: indexPath) as! DashboardMeetingRoomsTableViewCell
                        cell.collectionView.tag = 1
                        cell.selectionStyle = .none
                        cell.collectionView.backActionDelegate = self
                        if selectedMeetingRoomId > 0 {
                            cell.fetchmeetingRooms(id: selectedMeetingRoomId, requestModel: apiRequestModelRoomListing)
                        }
                        return cell
            } else {
                        let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifierAmenities.selectMeetingRoom.rawValue, for: indexPath) as! SelectMeetingRoomTableViewCell
                        cell.collectionView.tag = 1
                        cell.collectionView.backActionDelegate = self
                        cell.selectionStyle = .none
                        if selectedMeetingRoomId > 0 {
                            cell.fetchmeetingRooms(id: selectedMeetingRoomId, requestModel: apiRequestModelRoomListing)
                        }
                        return cell
                    }
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
    
    func dropdownButtonTapped(selectedOption: Location) {
        // Implement what you want to do with the selected option, for example:
        print("Selected option: \(selectedOption.name),\(selectedOption.id)")
        self.selectedLocation = selectedOption.name
        selectedMeetingRoomId = selectedOption.id
        self.locationId = selectedOption.id
        // Reload the table view to update meeting room listing
        tableView.reloadData()
    }
    
    func presentAlertController(alertController: UIAlertController) {
        // Present the alert controller from the view controller
        present(alertController, animated: true, completion: nil)
    }
}

extension AmenitiesViewController: DashboardDeskTypeTableViewCellDelegate {
    func buttonTapped(type: DashboardOption) {
           switch type {
           case .meetingRooms:
               if let meetingRoomsCell = tableView.visibleCells.compactMap({ $0 as? DashboardMeetingRoomsTableViewCell }).first {
                   meetingRoomsCell.fetchmeetingRooms(id: nil, requestModel: nil)
               } else {
                   print("DashboardMeetingRoomsTableViewCell not found")
               }
           case .workspace:
               if let meetingRoomsCell = tableView.visibleCells.compactMap({ $0 as? DashboardMeetingRoomsTableViewCell }).first {
                   meetingRoomsCell.fetchOfficeDesk(id: nil, requestModel: nil)
               } else {
                   print("DashboardMeetingRoomsTableViewCell not found")
               }
           default:
               break
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
