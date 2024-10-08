//
//  DashboardViewController.swift
//  RSOWorkspace
//
//  Created by Sumit Aquil on 23/02/24.
//

import UIKit
import Toast_Swift
enum DashboardOption: String {
    case meetingRooms = "Meeting Rooms"
    case workspace = "Workspace"
    case membership = "Membership"
}

class DashboardViewController: UIViewController, RSOTabCoordinated {
  var membershipViewController: MembershipViewController?
  var coordinator: RSOTabBarCordinator?
  var selectedButtonType: DashboardOption = .meetingRooms
  @IBOutlet weak var tableView: UITableView!
  var myBookingResponseData: MyBookingResponse?
  var eventHandler: ((_ event: Event) -> Void)?
  var pagetitle = RSOGreetings.greetingForCurrentTime()
    var requestModel = MeetingRoomItemRequestModel()
    var listItems: [RSOCollectionItem] = []
 
    override func viewDidLoad() {
    super.viewDidLoad()
      
    setupTableView()
    membershipViewController = UIViewController.createController(storyBoard: .Membership, ofType: MembershipViewController.self)
      CardListManager.shared.getCardDetails()
      
           // Fetch rooms on page load
           fetchRoomsOnPageLoad()

  }
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
      tableView.reloadData()
      
      
      
    coordinator?.hideBackButton(isHidden: true)
    coordinator?.hideTopViewForHome(isHidden: false)
    pagetitle = RSOGreetings.greetingForCurrentTime()
    coordinator?.setTitle(title: pagetitle)
    coordinator?.updateButtonSelection(0)
    print("dashboard view controller view will appear called")

  }
    private func fetchRoomsOnPageLoad() {
            // Ensure the fetch method is called immediately
            if selectedButtonType == .meetingRooms {
                fetchMeetingRooms()
            }
        }

        private func fetchMeetingRooms() {
            // Fetch meeting rooms data directly
            if let meetingRoomsCell = tableView.cellForRow(at: IndexPath(row: 0, section: SectionType.meetingRooms.rawValue)) as? DashboardMeetingRoomsTableViewCell {
                meetingRoomsCell.fetchRooms(id: 1, requestModel: requestModel)
            } else {
                // Optionally, you can reload the table view and then fetch data
                tableView.reloadSections(IndexSet(integer: SectionType.meetingRooms.rawValue), with: .none)
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    // Ensure the cell is available for fetching data after the reload
                    if let meetingRoomsCell = self.tableView.cellForRow(at: IndexPath(row: 0, section: SectionType.meetingRooms.rawValue)) as? DashboardMeetingRoomsTableViewCell {
                        meetingRoomsCell.fetchRooms(id: 1, requestModel: self.requestModel)
                    } else {
                        print("DashboardMeetingRoomsTableViewCell not found after reload.")
                    }
                }
            }
        }
  private func setupTableView() {
    tableView.dataSource = self
    tableView.delegate = self
    navigationController?.navigationBar.isHidden = true
    registerTableCells()
      
  }
  
  private func registerTableCells() {
    let cellIdentifiers = ["MyBookingCloseTableViewCell", "DashboardMarketPlaceTableViewCell", "DashboardDeskTypeTableViewCell", "DashboardMeetingRoomsTableViewCell", "MembershipTableViewCell"]
    
    for identifier in cellIdentifiers {
      tableView.register(UINib(nibName: identifier, bundle: nil), forCellReuseIdentifier: identifier)
    }
  }
  
  func myBookingListingAPI() {
    RSOLoader.showLoader()
    APIManager.shared.request(
      modelType: MyBookingResponse.self,
      type: MyBookingEndPoint.myBookingListing) { [weak self] response in
        guard let self = self else { return }        
        switch response {
        case .success(let responseData):
          let bookings = responseData
          DispatchQueue.main.async {
            RSOLoader.removeLoader()
            let myBookingVC = UIViewController.createController(storyBoard: .Booking, ofType: MyBookingViewController.self)
            myBookingVC.myBookingResponseData = bookings
            myBookingVC.coordinator = self.coordinator
            self.navigationController?.pushViewController(myBookingVC, animated: true)
          }
          self.eventHandler?(.dataLoaded)
          if responseData.status == false {
            DispatchQueue.main.async {
              RSOLoader.removeLoader()
              RSOToastView.shared.show("No Future Booking", duration: 2.0, position: .center)
            }
          }
        case .failure(let error):
          self.eventHandler?(.error(error))
          DispatchQueue.main.async {
            RSOLoader.removeLoader()
            RSOToastView.shared.show("\(error.localizedDescription)", duration: 2.0, position: .center)
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
      case .marketPlace:  return 209
      case .deskType: return 35
      case .meetingRooms: return 209
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
    guard let sectionType = SectionType(rawValue: indexPath.section) else {
      return UITableViewCell()
    }
    if sectionType == .meetingRooms && selectedButtonType == .membership {
      if let cell = tableView.dequeueReusableCell(withIdentifier: "MembershipTableViewCell", for: indexPath) as? MembershipTableViewCell, let memberVC = membershipViewController {
        cell.selectionStyle = .none
        // Create and configure the MembershipViewController
        memberVC.view.frame = cell.containerView.bounds
        cell.configure(with: memberVC)
        return cell
      }
    }
    let cell = tableView.dequeueReusableCell(withIdentifier: sectionType.cellIdentifier, for: indexPath)
    cell.selectionStyle = .none
    switch sectionType {
    case .myBookingClose:
      if let myBookingCell = cell as? MyBookingCloseTableViewCell {
          if UserHelper.shared.isUserExplorer(){
              myBookingCell.btnBooking.isUserInteractionEnabled = false
          }else{
              myBookingCell.btnBooking.isUserInteractionEnabled = true
              myBookingCell.btnBooking.addTarget(self, action: #selector(btnBookingTappedAction), for: .touchUpInside)
          }
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
    guard let sectionType = SectionType(rawValue: indexPath.section) else {
      return 100
    }
    
    if sectionType == .meetingRooms && selectedButtonType == .membership  {
      return self.view.frame.height
    }
    return sectionType.heightForRow
  }
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
  }
}

extension DashboardViewController {
  enum Event {
    case dataLoaded
    case error(Error?)
  }
}

extension DashboardViewController: BookButtonActionDelegate {
    func showShortTermOfficeBookingVC(){
        let bookOfficeVC = UIViewController.createController(storyBoard: .OfficeBooking, ofType: ShortTermBookAnOfficeViewController.self)
        bookOfficeVC.coordinator = self.coordinator
        self.navigationController?.pushViewController(bookOfficeVC, animated: true)
    }
    
  func showBookRoomDetailsVC(meetingRoomId: Int) {
      let bookMeetingRoomVC = UIViewController.createController(storyBoard: .Booking, ofType: BookMeetingRoomViewController.self)
      bookMeetingRoomVC.coordinator = self.coordinator
      self.navigationController?.pushViewController(bookMeetingRoomVC, animated: true)
  }
  // not used
  func showDeskBookingVC() {
      
  }
  func showBookMeetingRoomsVC() {
    
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
extension DashboardViewController: DashboardDeskTypeTableViewCellDelegate {
  func buttonTapped(type: DashboardOption) {
    DispatchQueue.main.async {
      self.selectedButtonType = type
       // self.tableView.reloadSections(IndexSet(integer: 3), with: .automatic)
        self.tableView.reloadSections(IndexSet(integer: SectionType.meetingRooms.rawValue), with: .automatic)

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
//    func buttonTapped(type: DashboardOption) {
//            DispatchQueue.main.async {
//                self.selectedButtonType = type
//                
//                // Reloading the entire table view is not efficient, you can target specific sections or rows.
//               // self.tableView.reloadSections(IndexSet(integer: 3), with: .automatic)
//                 self.tableView.reloadSections(IndexSet(integer: SectionType.meetingRooms.rawValue), with: .automatic)
//                // Directly accessing the index path for the cell you want to work with
//                let indexPath = IndexPath(row: 0, section: 3) // Assuming the dashboardMeetingRooms cell is at section 3
//                if let meetingRoomsCell = self.tableView.cellForRow(at: indexPath) as? DashboardMeetingRoomsTableViewCell {
//                    switch type {
//                    case .meetingRooms:
//                        meetingRoomsCell.fetchRooms(id: 1, requestModel: self.requestModel)
//                    case .workspace:
//                        meetingRoomsCell.fetchOfficeDesk(id: nil, requestModel: nil)
//                    case .membership:
//                        // Handle membership case if needed
//                        break
//                    }
//                } else {
//                    print("DashboardMeetingRoomsTableViewCell not found at indexPath \(indexPath)")
//                }
//            }
//        }
}
