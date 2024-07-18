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
  
  var isSearchEnabled = false
  var searchingText = ""
  var listItems: [MeetingRoomsItem] = [] // Declaring listItems here
  var roomList : [RSOCollectionItem] = []
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    coordinator?.hideBackButton(isHidden: false)
    
    self.collectionView.backActionDelegate = self
    
    txtSearch.delegate = self
    txtSearch.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
    // Hide or show search bar based on isSearchEnabled
    txtSearchHeightConstraint.constant = isSearchEnabled ? 45 : 0
    txtSearch.setUpTextFieldView(leftImageName: nil, rightImageName: "search")
    txtSearch.text = self.searchingText
    self.textFieldBackground.layer.cornerRadius = 10
    fetchRooms()

  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    coordinator?.setTitle(title: "Meeting Rooms")
  }
  
  // MARK: - Data Fetching
  
  func fetchRooms() {
    RSOLoader.showLoader()
    APIManager.shared.request(
      modelType: ResponseData.self,
      type: DeskEndPoint.meetingRooms) { response in
        DispatchQueue.main.async {
          switch response {
          case .success(let response):
            let roomList = response.data
            let listItems: [RSOCollectionItem] = roomList.map { RSOCollectionItem(meetingRoomItem: $0) }
            self.collectionView.listItems = listItems
            self.roomList = listItems
            if !self.searchingText.isEmpty {
              self.filterMeetingRooms(searchText: self.searchingText)
            }
            DispatchQueue.main.async {
              RSOLoader.removeLoader()
            }
            self.collectionView.eventHandler?(.dataLoaded)
          case .failure(let error):
            self.collectionView.eventHandler?(.error(error))
            DispatchQueue.main.async {
              RSOLoader.removeLoader()
            }
          }
        }
      }
  }
}
extension RoomListingViewController {
    enum Event {
        case dataLoaded
        case error(Error?)
    }
}
extension  RoomListingViewController: BookButtonActionDelegate {
    func showBookRoomDetailsVC(meetingRoomId: Int) {
        
    }
    
    func showBookMeetingRoomsVC() {
      let bookMeetingRoomVC = UIViewController.createController(storyBoard: .Booking, ofType: BookMeetingRoomViewController.self)
      bookMeetingRoomVC.coordinator = self.coordinator
      navigationController?.pushViewController(bookMeetingRoomVC, animated: true)
    }
    
    func showLogInVC() {
        let logInVC = UIViewController.createController(storyBoard: .GetStarted, ofType: LogInViewController.self)
        self.navigationController?.pushViewController(logInVC, animated: true)
   
    }
    
}
extension RoomListingViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return true
    }
  @objc func textFieldDidChange(_ textField: UITextField) {
    guard let searchText = textField.text, !searchText.isEmpty else {
      // Clear search and reload original products
      filterMeetingRooms(searchText: "")
      return
    }
    filterMeetingRooms(searchText: searchText.lowercased())
  }
    
    func filterMeetingRooms(searchText: String) {
        if !searchText.isEmpty {
          self.collectionView.listItems = self.collectionView.listItems.filter { $0.roomName.lowercased().contains(searchText.lowercased()) } // Filter based on room name
        } else {
          self.collectionView.listItems = self.roomList
        }
      self.searchingText = searchText
        collectionView.reloadData() // Reload collection view to reflect filtered data
    }
}
