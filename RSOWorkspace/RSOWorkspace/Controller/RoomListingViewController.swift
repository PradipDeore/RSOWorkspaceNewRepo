//
//  DeskListingViewController.swift
//  RSOWorkspace
//
//  Created by Sumit Aquil on 20/02/24.
//

import UIKit

//class DeskListingViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
//    @IBOutlet weak var searchBarHeightConstraint: NSLayoutConstraint!
//    
//    @IBOutlet weak var collectionView: UICollectionView!
//    // Define the scroll direction
//    var scrollDirection: UICollectionView.ScrollDirection = .vertical
//    var listItems: [DeskListItem] = []
//    var eventHandler: ((_ event: Event) -> Void)? // Data Binding Closure
//   var isSearchEnabled = false
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        
//        // Register custom cell
//        collectionView.register(UINib(nibName: "DeskCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "DeskCollectionViewCell")
//        
//        // Set collection view delegate and data source
//        collectionView.delegate = self
//        collectionView.dataSource = self
//        
//        // Configure the scroll direction
//        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
//            layout.scrollDirection = scrollDirection
//        }
//        fetchRooms()
//        //collectionView.reloadData()
//    }
//    
//    override func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(animated)
//        
//        if isSearchEnabled {
//            self.searchBarHeightConstraint.constant = 50
//        } else {
//            self.searchBarHeightConstraint.constant = 0
//        }
//    }
//    
//    func fetchRooms() {
//        self.eventHandler?(.loading)
//        APIManager.shared.request(
//            modelType: ResponseData.self,
//            type: DeskEndPoint.meetingRooms) { response in
//                self.eventHandler?(.stopLoading)
//                switch response {
//                case .success(let response):
//                    self.listItems = response.data
//                    DispatchQueue.main.async {
//                        self.collectionView.reloadData()
//                    }
//                    self.eventHandler?(.dataLoaded)
//                case .failure(let error):
//                    self.eventHandler?(.error(error))
//                }
//            }
//    }
//    
//    @objc func bookAction(sender: UIButton) {
//        if let _ = RSOToken.shared.getToken(){
//            print("Show Booking screen")
//        }else{
//            let loginVC = UIViewController.createController(storyBoard: .GetStarted, ofType: LogInViewController.self)
//            self.navigationController?.pushViewController(loginVC, animated: true)
//        }
//    }
//    
//    // MARK: - UICollectionViewDataSource
//    
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        // Return the number of items in your collection view
//        return listItems.count // Change this as per your requirement
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DeskCollectionViewCell", for: indexPath) as! DeskCollectionViewCell
//        
//        cell.customizeCell()
//        let item = listItems[indexPath.row]
//        cell.setData(item: item)
//        cell.btnBook.addTarget(self, action: #selector(bookAction), for: .touchUpInside)
//        return cell
//    }
//    
//    // MARK: - UICollectionViewDelegateFlowLayout
//    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        // Set size for items in collection view
//        if scrollDirection == .vertical{
//            return CGSize(width: collectionView.bounds.width - 20, height: 225) // Adjust height and width as needed
//        }else{
//            return CGSize(width: collectionView.bounds.width - 10, height: 225) // Adjust height and width as needed
//        }
//        
//    }
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
//        return 20.0
//    }
//    
//    // Add more delegate methods as needed
//}
//extension DeskListingViewController {
//    enum Event {
//        case loading
//        case stopLoading
//        case dataLoaded
//        case error(Error?)
//    }
//}

class RoomListingViewController: UIViewController {
    
    @IBOutlet weak var searchBarHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var txtSearch: RSOTextField!
    @IBOutlet weak var collectionView: RSOMeetingRoomsCollectionView!
    
    @IBOutlet weak var txtSearchHeightConstraint: NSLayoutConstraint!
    
    var isSearchEnabled = false
    var searchMeetingRooms = ""
    var listItems: [MeetingRoomsItem] = [] // Declaring listItems here
    var filteredItems: [MeetingRoomsItem] = []


    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.collectionView.backActionDelegate = self
        fetchRooms()
        
        txtSearch.delegate = self
        // Hide or show search bar based on isSearchEnabled
        txtSearchHeightConstraint.constant = isSearchEnabled ? 45 : 0
        txtSearch.setUpTextFieldView(leftImageName: nil, rightImageName: "search")
        txtSearch.customBorderWidth = 0.0
        //txtSearch.text = self.searchMeetingRooms
    }
   
    // MARK: - Data Fetching
    
    func fetchRooms() {
        collectionView.eventHandler?(.loading)
        APIManager.shared.request(
            modelType: ResponseData.self,
            type: DeskEndPoint.meetingRooms) { response in
                self.collectionView.eventHandler?(.stopLoading)
                switch response {
                case .success(let response):
                    let roomList = response.data
                    let listItems: [RSOCollectionItem] = roomList.map { RSOCollectionItem(meetingRoomItem: $0) }
                    self.collectionView.listItems = listItems
                   
//                    self.filteredItems = self.listItems // Initially, filtered items are same as list items
//                    DispatchQueue.main.async {
//                        self.collectionView.reloadData()
//
//                    }

                    self.collectionView.eventHandler?(.dataLoaded)
                case .failure(let error):
                    self.collectionView.eventHandler?(.error(error))
                }
            }
    }
    func gettxtSearchValue(searchValue :String){
        if let txtSearch = txtSearch.text, !txtSearch.isEmpty{
            let searchValue = txtSearch
        }
    }
}
extension RoomListingViewController {
    enum Event {
        case loading
        case stopLoading
        case dataLoaded
        case error(Error?)
    }
}
extension  RoomListingViewController: BookButtonActionDelegate {
    func showBookRoomDetailsVC(meetingRoomId: Int) {
        
    }
    
    func showBookMeetingRoomsVC() {
        
    }
    
    func showLogInVC() {
       /* guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let sceneDelegate = windowScene.delegate as? SceneDelegate else {
            return
        }
        let loginVC = UIViewController.createController(storyBoard: .GetStarted, ofType: LogInViewController.self)
        sceneDelegate.window?.rootViewController?.present(loginVC, animated: true, completion: nil)*/
        let logInVC = UIViewController.createController(storyBoard: .GetStarted, ofType: LogInViewController.self)
        self.navigationController?.pushViewController(logInVC, animated: true)
   
    }
    
}
extension RoomListingViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let searchText = (textField.text as NSString?)?.replacingCharacters(in: range, with: string) else {
            return true
        }
        filterMeetingRooms(searchText: searchText.lowercased())
        return true
    }
    
    func filterMeetingRooms(searchText: String) {
        if searchText.isEmpty {
            filteredItems = listItems // If search text is empty, show all items
        } else {
            filteredItems = listItems.filter { $0.roomName.lowercased().contains(searchText) } // Filter based on room name
        }
        collectionView.reloadData() // Reload collection view to reflect filtered data
    }
}
