//
//  DeskListingViewController.swift
//  RSOWorkspace
//
//  Created by Sumit Aquil on 17/04/24.
//

import UIKit


class DeskListingViewController: UIViewController {
    
    @IBOutlet weak var collectionView: RSOMeetingRoomsCollectionView!
    
    var listItems: [Office] = [] // Declaring listItems here
    var filteredItems: [Office] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.collectionView.backActionDelegate = self
        fetchOfficeDesk()
    }
   
    // MARK: - Data Fetching
    
    func fetchOfficeDesk() {
        collectionView.eventHandler?(.loading)
        APIManager.shared.request(
            modelType: OfficeItemsResponse.self,
            type: DeskBookingEndPoint.desks) { response in
                self.collectionView.eventHandler?(.stopLoading)
                switch response {
                case .success(let response):
                    let deskList = response.data
                    let listItems: [RSOCollectionItem] = deskList.map { RSOCollectionItem(deskItem: $0) }
                    self.collectionView.listItems = listItems
                    self.collectionView.eventHandler?(.dataLoaded)
                case .failure(let error):
                    self.collectionView.eventHandler?(.error(error))
                }
            }
    }
//    func gettxtSearchValue(searchValue :String){
//        if let txtSearch = txtSearch.text, !txtSearch.isEmpty{
//            let searchValue = txtSearch
//        }
//    }
}
extension DeskListingViewController {
    enum Event {
        case loading
        case stopLoading
        case dataLoaded
        case error(Error?)
    }
}
extension  DeskListingViewController: BookButtonActionDelegate {
    func showBookRoomDetailsVC(meetingRoomId: Int) {
        
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
//extension DeskListingViewController: UITextFieldDelegate {
//    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
//        guard let searchText = (textField.text as NSString?)?.replacingCharacters(in: range, with: string) else {
//            return true
//        }
//        filterMeetingRooms(searchText: searchText.lowercased())
//        return true
//    }
//    
//    func filterMeetingRooms(searchText: String) {
//        if searchText.isEmpty {
//            filteredItems = listItems // If search text is empty, show all items
//        } else {
//            filteredItems = listItems.filter { $0.roomName.lowercased().contains(searchText) } // Filter based on room name
//        }
//        collectionView.reloadData() // Reload collection view to reflect filtered data
//    }
//}
