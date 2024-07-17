//
//  DashboardViewController.swift
//  RSOWorkspace
//
//  Created by Sumit Aquil on 23/02/24.
//

import UIKit
import Toast_Swift

class DashboardViewController: UIViewController, RSOTabCoordinated {
    
    var coordinator: RSOTabBarCordinator?
    var selectedIndexPath: IndexPath?

    @IBOutlet weak var tableView: UITableView!
    var myBookingResponseData: MyBookingResponse?
    var eventHandler: ((_ event: Event) -> Void)?
    var pagetitle = RSOGreetings.greetingForCurrentTime()
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        coordinator?.hideBackButton(isHidden: true)
        coordinator?.setTitle(title: pagetitle)

    }
    
    private func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        navigationController?.navigationBar.isHidden = true
        registerTableCells()
    }
    
    private func registerTableCells() {
        let cellIdentifiers = ["MyBookingCloseTableViewCell", "DashboardMarketPlaceTableViewCell", "DashboardDeskTypeTableViewCell", "DashboardMeetingRoomsTableViewCell"]
       
        for identifier in cellIdentifiers {
            tableView.register(UINib(nibName: identifier, bundle: nil), forCellReuseIdentifier: identifier)
        }
    }
    
    func myBookingListingAPI() {
        eventHandler?(.loading)
        APIManager.shared.request(
            modelType: MyBookingResponse.self,
            type: MyBookingEndPoint.myBookingListing) { [weak self] response in
                guard let self = self else { return }
                self.eventHandler?(.stopLoading)
                
                switch response {
                case .success(let responseData):
                    let bookings = responseData
                        DispatchQueue.main.async {
                            let myBookingVC = UIViewController.createController(storyBoard: .Booking, ofType: MyBookingViewController.self)
                            myBookingVC.myBookingResponseData = bookings
                            myBookingVC.coordinator = self.coordinator
                            self.navigationController?.pushViewController(myBookingVC, animated: true)
                        }
                        self.eventHandler?(.dataLoaded)
                    if responseData.status == false {
                        DispatchQueue.main.async {
                            self.view.makeToast("No Future Booking", duration: 2.0, position: .center)
                        }
                    }
                case .failure(let error):
                    self.eventHandler?(.error(error))
                    DispatchQueue.main.async {
                        self.view.makeToast("\(error.localizedDescription)", duration: 2.0, position: .center)
                    }
                }
            }
    }
    
    @objc func btnBookingTappedAction(_ sender: Any) {
        
        myBookingListingAPI()
    }
}

extension DashboardViewController: UITableViewDataSource, UITableViewDelegate {
    
    enum SectionType: Int, CaseIterable {
        case myBookingClose = 0
        case marketPlace
        case deskType
        case meetingRooms
        
        var cellIdentifier: String {
            switch self {
            case .myBookingClose: return "MyBookingCloseTableViewCell"
            case .marketPlace: return "DashboardMarketPlaceTableViewCell"
            case .deskType: return "DashboardDeskTypeTableViewCell"
            case .meetingRooms: return "DashboardMeetingRoomsTableViewCell"
            }
        }
        
        var heightForRow: CGFloat {
            switch self {
            case .myBookingClose: return 45
            case .marketPlace, .meetingRooms: return 209
            case .deskType: return 35
            }
        }
    }
    
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
        guard let section = SectionType(rawValue: indexPath.section) else {
            return UITableViewCell()
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: section.cellIdentifier, for: indexPath)
        
        switch section {
        case .myBookingClose:
            if let myBookingCell = cell as? MyBookingCloseTableViewCell {
                myBookingCell.btnBooking.addTarget(self, action: #selector(btnBookingTappedAction), for: .touchUpInside)
            }
        case .meetingRooms:
            if let meetingRoomsCell = cell as? DashboardMeetingRoomsTableViewCell {
                meetingRoomsCell.collectionView.tag = 0
                meetingRoomsCell.collectionView.backActionDelegate = self

            }
        case .deskType:
            if let deskTypeCell = cell as? DashboardDeskTypeTableViewCell {
                      deskTypeCell.delegate = self
                  }
        default:
            break
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let section = SectionType(rawValue: indexPath.section) else {
            return 100
        }
        return section.heightForRow
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
           selectedIndexPath = indexPath
       }
       
}

extension DashboardViewController {
    enum Event {
        case loading
        case stopLoading
        case dataLoaded
        case error(Error?)
    }
}

extension DashboardViewController: BookButtonActionDelegate {
    func showBookRoomDetailsVC(meetingRoomId: Int) {
        // Implement your logic here
    }
    
    func showBookMeetingRoomsVC() {
        let bookMeetingRoomVC = UIViewController.createController(storyBoard: .Booking, ofType: BookMeetingRoomViewController.self)
        bookMeetingRoomVC.coordinator = self.coordinator
        navigationController?.pushViewController(bookMeetingRoomVC, animated: true)
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
extension DashboardViewController: DashboardDeskTypeTableViewCellDelegate {
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

// OLD CODE AFTER UPDATION
//import UIKit
//
//class DashboardViewController: UIViewController {
//    
//    @IBOutlet weak var tableView: UITableView!
//    
//    var eventHandler: ((_ event: Event) -> Void)? // Data Binding Closure
//    var myBookingResponseData: BookingResponse?
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        setupTableView()
//    }
//    
//    private func setupTableView() {
//        tableView.register(UINib(nibName: "MyBookingCloseTableViewCell", bundle: nil), forCellReuseIdentifier: "MyBookingCloseTableViewCell")
//        tableView.register(UINib(nibName: "MyBookingOpenTableViewCell", bundle: nil), forCellReuseIdentifier: "MyBookingOpenTableViewCell")
//        tableView.register(UINib(nibName: "DashboardMarketPlaceTableViewCell", bundle: nil), forCellReuseIdentifier: "DashboardMarketPlaceTableViewCell")
//        tableView.register(UINib(nibName: "DashboardDeskTypeTableViewCell", bundle: nil), forCellReuseIdentifier: "DashboardDeskTypeTableViewCell")
//        tableView.register(UINib(nibName: "DashboardMeetingRoomsTableViewCell", bundle: nil), forCellReuseIdentifier: "DashboardMeetingRoomsTableViewCell")
//        
//        tableView.dataSource = self
//        tableView.delegate = self
//        
//        navigationController?.navigationBar.isHidden = true
//    }
//    func myBookingListingAPI(type: String, limit: Int) {
//        self.eventHandler?(.loading)
//        APIManager.shared.request(
//            modelType: BookingResponse.self,
//            type: MyBookingEndPoint.myBookingListing(type: type, limit: limit)) { [weak self] response in
//                
//                guard let self = self else { return }
//                self.eventHandler?(.stopLoading)
//                
//                switch response {
//                case .success(let responseData):
//                    // Check if there are no future bookings
//                    if responseData.status == false, responseData.msg == "No Future Booking." {
//                        DispatchQueue.main.async {
//                            self.view.makeToast("No Future Booking", duration: 2.0, position: .center)
//                        }
//                        return
//                    }
//                    
//                    // Handle successful response with bookings
//                    let bookings = responseData.resultData
//                    print("Booking data: \(bookings)")
//                    DispatchQueue.main.async {
//                        let myBookingVC = UIViewController.createController(storyBoard: .Booking, ofType: MyBookingViewController.self)
//                        myBookingVC.myBookingResponseData = bookings ?? []
//                        self.navigationController?.pushViewController(myBookingVC, animated: true)
//                    }
//                    self.eventHandler?(.dataLoaded)
//                case .failure(let error):
//                    self.eventHandler?(.error(error))
//                    DispatchQueue.main.async {
//                        self.view.makeToast("\(error.localizedDescription)", duration: 2.0, position: .center)
//                    }
//                }
//            }
//    }
//    
//    
//    @objc func btnBookingTappedAction(_ sender: Any) {
//        
//        myBookingListingAPI(type: "all", limit: 1)
//        
//    }
//}
//
//extension DashboardViewController: UITableViewDataSource, UITableViewDelegate {
//    
//    func numberOfSections(in tableView: UITableView) -> Int {
//        return 4
//    }
//    
//    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        return 10
//    }
//    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        return UIView() // Return an empty view for the header between sections
//    }
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return 1
//    }
//    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        switch indexPath.section {
//        case 0:
//            let cell = tableView.dequeueReusableCell(withIdentifier: "MyBookingCloseTableViewCell", for: indexPath) as! MyBookingCloseTableViewCell
//            cell.btnBooking.addTarget(self, action: #selector(btnBookingTappedAction), for: .touchUpInside)
//            return cell
//        case 1:
//            return tableView.dequeueReusableCell(withIdentifier: "DashboardMarketPlaceTableViewCell", for: indexPath) as! DashboardMarketPlaceTableViewCell
//        case 2:
//            return tableView.dequeueReusableCell(withIdentifier: "DashboardDeskTypeTableViewCell", for: indexPath) as! DashboardDeskTypeTableViewCell
//        case 3:
//           let cell = tableView.dequeueReusableCell(withIdentifier: "DashboardMeetingRoomsTableViewCell", for: indexPath) as! DashboardMeetingRoomsTableViewCell
//            cell.collectionView.tag = 0
//            cell.collectionView.backActionDelegate = self
//            return cell
//          
//        default:
//            return UITableViewCell()
//        }
//    }
//    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        switch indexPath.section {
//        case 0:
//            return 45
//        case 1, 3:
//            return 209
//        case 2:
//            return 35
//        default:
//            return 100
//        }
//    }
//}
//extension DashboardViewController {
//    enum Event {
//        case loading
//        case stopLoading
//        case dataLoaded
//        case error(Error?)
//    }
//}
//extension DashboardViewController: BookButtonActionDelegate{
//    func showBookRoomDetailsVC(meetingRoomId: Int) {
//        
//    }
// 
//    func showBookMeetingRoomsVC() {
//        let bookMeetingRoomVC = UIViewController.createController(storyBoard: .Booking, ofType: BookMeetingRoomViewController.self)
//        self.navigationController?.pushViewController(bookMeetingRoomVC, animated: true)
//    }
//    
//    func showLogInVC() {
//        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
//              let sceneDelegate = windowScene.delegate as? SceneDelegate else {
//            return
//        }
//        let loginVC = UIViewController.createController(storyBoard: .GetStarted, ofType: LogInViewController.self)
//        sceneDelegate.window?.rootViewController?.present(loginVC, animated: true, completion: nil)
//    }
//   
//}
