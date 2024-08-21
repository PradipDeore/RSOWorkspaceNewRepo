//
//  DeskListingViewController.swift
//  RSOWorkspace
//
//  Created by Sumit Aquil on 20/02/24.
//



import UIKit

class RoomListingViewController: UIViewController {
    
    @IBOutlet var textFieldBackground: UIView!
    @IBOutlet weak var searchBarHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var txtSearch: UITextField!
    @IBOutlet weak var collectionView: RSOMeetingRoomsCollectionView!
    var coordinator: RSOTabBarCordinator?
    @IBOutlet weak var txtSearchHeightConstraint: NSLayoutConstraint!
    
    var eventHandler: ((_ event: Event) -> Void)?
    var selectedMeetingRoomId = 0
    var isSearchEnabled = false
    var searchingText = ""
    
    var filteredItems: [RSOCollectionItem] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        coordinator?.hideBackButton(isHidden: false)
        self.collectionView.backActionDelegate = self
        
        txtSearch.delegate = self
        txtSearch.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        txtSearchHeightConstraint.constant = isSearchEnabled ? 45 : 0
        txtSearch.setUpTextFieldView(leftImageName: nil, rightImageName: "search")
        txtSearch.text = self.searchingText
        self.textFieldBackground.layer.cornerRadius = 10
        
        // Fetch search data initially with an empty search text
        fetchSearchData(searchText: "")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        coordinator?.setTitle(title: "Search Products")
    }
    
 

    private func fetchSearchData(searchText: String) {
        DispatchQueue.main.async {
            RSOLoader.showLoader()
        }
        APIManager.shared.request(
            modelType: SearchResponseModel.self,
            type: SearchEndPoint.searchItems(searchItemName: searchText)) { [weak self] response in
                DispatchQueue.main.async {
                    guard let self = self else { return }
                    switch response {
                    case .success(let response):
                        // Initialize arrays for each category
                        var meetingRooms: [RSOCollectionItem] = []
                        var desks: [RSOCollectionItem] = []
                        var offices: [RSOCollectionItem] = []

                        // Check and map each category if they exist in the response
                        if let rooms = response.rooms, !rooms.isEmpty {
                          

                            meetingRooms = rooms.map { RSOCollectionItem(roomSearchListingItem: $0) }
                        }
                        
                        if let desksList = response.desks, !desksList.isEmpty {
                            desks = desksList.map { RSOCollectionItem(deskSearchListingItem: $0) }
                        }
                        
                        if let officesList = response.offices, !officesList.isEmpty {
                            offices = officesList.map { RSOCollectionItem(officeSearchListingItem: $0) }
                        }

                        // Combine the items based on availability
                        self.filteredItems = meetingRooms + desks + offices
                        
                        // Update the collection view
                        self.collectionView.listItems = self.filteredItems
                        self.collectionView.reloadData()
                        
                    case .failure(let error):
                        self.eventHandler?(.error(error))
                    }
                    RSOLoader.removeLoader()
                }
        }
    }

    // MARK: - Filtering
    
    func filterRoomsDesksAndOffices(searchText: String) {
        if !searchText.isEmpty {
            fetchSearchData(searchText: searchText)
        } else {
            fetchSearchData(searchText: "") // Fetch default data if search text is empty
        }
    }
}
extension RoomListingViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedItem = filteredItems[indexPath.item]
        // Store the selected item ID
        self.selectedMeetingRoomId = selectedItem.id // Assuming RSOCollectionItem has an 'id' property
    }
}
extension RoomListingViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return true
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        guard let searchText = textField.text else {
            return
        }
        filterRoomsDesksAndOffices(searchText: searchText.lowercased())
    }
}

extension RoomListingViewController: BookButtonActionDelegate {
    func didSelect(selectedId: Int) {
        self.selectedMeetingRoomId = selectedId
    }
    func showBookRoomDetailsVC(meetingRoomId: Int) {
        // Implement this method
    }
    func showBookMeetingRoomsVC() {
        let bookMeetingRoomVC = UIViewController.createController(storyBoard: .Booking, ofType: BookMeetingRoomViewController.self)
        bookMeetingRoomVC.coordinator = self.coordinator
        bookMeetingRoomVC.selectedMeetingRoomId = self.selectedMeetingRoomId
        navigationController?.pushViewController(bookMeetingRoomVC, animated: true)
    }
    func showDeskBookingVC() {
        let bookDeskVC = UIViewController.createController(storyBoard: .Booking, ofType: DeskBookingViewController.self)
        bookDeskVC.coordinator = self.coordinator
        self.navigationController?.pushViewController(bookDeskVC, animated: true)
    }
    func showShortTermOfficeBookingVC(){
        let officeBookingVC = UIViewController.createController(storyBoard: .OfficeBooking, ofType: ShortTermBookAnOfficeViewController.self)
        officeBookingVC.coordinator = self.coordinator
        navigationController?.pushViewController(officeBookingVC, animated: true)
    }
    
    func showLogInVC() {
        let logInVC = UIViewController.createController(storyBoard: .GetStarted, ofType: LogInViewController.self)
        self.navigationController?.pushViewController(logInVC, animated: true)
    }
}

extension RoomListingViewController {
    enum Event {
        case dataLoaded
        case error(Error?)
    }
}



// old code without searh api


//
//  DeskListingViewController.swift
//  RSOWorkspace
//
//  Created by Sumit Aquil on 20/02/24.
//

//import UIKit
//
//
//class RoomListingViewController: UIViewController {
// 
// @IBOutlet var textFieldBackground: UIView!
// @IBOutlet weak var searchBarHeightConstraint: NSLayoutConstraint!
// @IBOutlet weak var txtSearch: UITextField!
// @IBOutlet weak var collectionView: RSOMeetingRoomsCollectionView!
// var coordinator: RSOTabBarCordinator?
// @IBOutlet weak var txtSearchHeightConstraint: NSLayoutConstraint!
// var eventHandler: ((_ event: Event) -> Void)?
//
// var isSearchEnabled = false
// var searchingText = ""
// 
// var meetingRoomItems: [MeetingRoomsItem] = []
// var officeDeskItems: [Office] = []
// var combinedListItems: [RSOCollectionItem] = []
// var filteredItems: [RSOCollectionItem] = []
// 
// var requestModel = MeetingRoomItemRequestModel()
// var requestModelOffice = BookOfficeRequestModel()
// var requestModelDesk = DeskRequestModel()
// var deskItems: [DeskListingItem] = []
// 
//
// 
// override func viewDidLoad() {
//     super.viewDidLoad()
//     coordinator?.hideBackButton(isHidden: false)
//     self.collectionView.backActionDelegate = self
//     
//     txtSearch.delegate = self
//     txtSearch.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
//     // Hide or show search bar based on isSearchEnabled
//     txtSearchHeightConstraint.constant = isSearchEnabled ? 45 : 0
//     txtSearch.setUpTextFieldView(leftImageName: nil, rightImageName: "search")
//     txtSearch.text = self.searchingText
//     self.textFieldBackground.layer.cornerRadius = 10
//     
//     // Fetch both Meeting Rooms and Office Desks
//     fetchRooms(id: 1, requestModel: requestModel)
//     fetchOfficeDesk(id: 1, requestModel: requestModelOffice)
//     fetchDesks(id: 1, requestModel: requestModelDesk)
// }
// 
// override func viewWillAppear(_ animated: Bool) {
//     super.viewWillAppear(animated)
//     coordinator?.setTitle(title: "Search Products")
// }
// 
// // MARK: - Data Fetching
// 
// func fetchRooms(id: Int?, requestModel: MeetingRoomItemRequestModel?) {
//     RSOLoader.showLoader()
//     APIManager.shared.request(
//         modelType: ResponseData.self,
//         type: DeskEndPoint.meetingRooms(id: id, requestModel: requestModel)) { response in
//             DispatchQueue.main.async {
//                 switch response {
//                 case .success(let response):
//                     self.meetingRoomItems = response.data
//                     self.combineAndFilterItems()
//                 case .failure(let error):
//                     self.collectionView.eventHandler?(.error(error))
//                 }
//                 RSOLoader.removeLoader()
//             }
//         }
// }
// 
// func fetchOfficeDesk(id: Int?, requestModel: BookOfficeRequestModel?) {
//     RSOLoader.showLoader()
//     APIManager.shared.request(
//         modelType: OfficeItemsResponse.self,
//         type: DeskBookingEndPoint.offices(id: id, requestModel: requestModelOffice)) { response in
//             DispatchQueue.main.async {
//                 RSOLoader.removeLoader()
//                 switch response {
//                 case .success(let response):
//                     if let officeList = response.data {
//                         self.officeDeskItems = officeList
//                         self.combineAndFilterItems()
//                         self.collectionView.tag = 0
//                         self.collectionView.backActionDelegate = self
//                     }
//                 case .failure(let error):
//                     self.collectionView.eventHandler?(.error(error))
//                 }
//             }
//         }
// }
// func fetchDesks(id: Int, requestModel: DeskRequestModel) {
//     APIManager.shared.request(
//         modelType: DeskListingResponse.self,
//         type: DeskBookingEndPoint.getDesksLisiting(id: id, requestModel: requestModel)) { [weak self] response in
//             DispatchQueue.main.async {
//                 guard let self = self else { return }
//                 switch response {
//                 case .success(let responseData):
//                     // Handle successful response with bookings
//                     let deskList = responseData.data
//                     self.deskItems = deskList
//                     self.collectionView.hideBookButton = false
//                     self.collectionView.tag = 0
//                     
//                     self.collectionView.backActionDelegate = self
//                     self.combineAndFilterItems()
//                 case .failure(let error):
//                     self.collectionView.eventHandler?(.error(error))
//                 }
//             }
//         }
// }
// 
// 
// // Combine both Meeting Rooms and Office Desks into a single list
// func combineAndFilterItems() {
//     let meetingRoomListItems = meetingRoomItems.map { RSOCollectionItem(meetingRoomItem: $0) }
//     let officeDeskListItems = officeDeskItems.map { RSOCollectionItem(deskItem: $0) }
//     let deskListItems = deskItems.map { RSOCollectionItem(deskLisitngItem: $0) }
//     
//     // Debugging: Print combined items
//     print("Combined List Items: ",deskListItems)
//     self.combinedListItems = meetingRoomListItems + officeDeskListItems + deskListItems
//     
//     if !self.searchingText.isEmpty {
//         filterRoomsDesksAndOffices(searchText: self.searchingText)
//     } else {
//         self.collectionView.listItems = self.combinedListItems
//         self.collectionView.reloadData()
//     }
// }
// 
// // MARK: - Filtering
// 
// func filterRoomsDesksAndOffices(searchText: String) {
//     if !searchText.isEmpty {
//         filteredItems = self.combinedListItems.filter { $0.roomName.lowercased().contains(searchText.lowercased()) }
//         //      if filteredItems.isEmpty {
//         //        // Show toast if no records are found
//         //        DispatchQueue.main.async {
//         //          self.view.makeToast("Record Not Found", duration: 1.5, position: .center)
//         //        }
//         //      }
//     } else {
//         filteredItems = self.combinedListItems
//     }
//     
//     self.collectionView.listItems = filteredItems
//     self.collectionView.reloadData()
//     self.searchingText = searchText
// }
//}
//
//extension RoomListingViewController: UITextFieldDelegate {
// func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
//     return true
// }
// 
// @objc func textFieldDidChange(_ textField: UITextField) {
//     guard let searchText = textField.text else {
//         return
//     }
//     filterRoomsDesksAndOffices(searchText: searchText.lowercased())
// }
//}
//
//
//extension  RoomListingViewController: BookButtonActionDelegate {
// func showBookRoomDetailsVC(meetingRoomId: Int) {
//     
// }
// func showBookMeetingRoomsVC() {
//     let bookMeetingRoomVC = UIViewController.createController(storyBoard: .Booking, ofType: BookMeetingRoomViewController.self)
//     bookMeetingRoomVC.coordinator = self.coordinator
//     navigationController?.pushViewController(bookMeetingRoomVC, animated: true)
// }
// func showDeskBookingVC() {
//     let bookDeskVC = UIViewController.createController(storyBoard: .Booking, ofType: DeskBookingViewController.self)
//     bookDeskVC.coordinator = self.coordinator
//     self.navigationController?.pushViewController(bookDeskVC, animated: true)
// }
// func showShortTermOfficeBookingVC(){
//     let officeBookingVC = UIViewController.createController(storyBoard: .OfficeBooking, ofType: ShortTermBookAnOfficeViewController.self)
//     officeBookingVC.coordinator = self.coordinator
//     navigationController?.pushViewController(officeBookingVC, animated: true)
// }
// 
// func showLogInVC() {
//     let logInVC = UIViewController.createController(storyBoard: .GetStarted, ofType: LogInViewController.self)
//     self.navigationController?.pushViewController(logInVC, animated: true)
//     
// }
// 
//}
//
//extension RoomListingViewController {
// enum Event {
//     case dataLoaded
//     case error(Error?)
// }
//}
//


