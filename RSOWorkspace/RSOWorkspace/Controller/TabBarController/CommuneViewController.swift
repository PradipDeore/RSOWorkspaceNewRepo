//
//  CommuneViewController.swift
//  RSOWorkspace
//
//  Created by Sumit Aquil on 23/02/24.
//

import UIKit

class CommuneViewController: UIViewController,RSOTabCoordinated{

    var coordinator: RSOTabBarCordinator?

    @IBOutlet weak var tableView: UITableView!
    var eventHandler: ((_ event: Event) -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        coordinator?.hideBackButton(isHidden: true)
        self.coordinator?.hideTopViewForHome(isHidden: false)
        coordinator?.setTitle(title: "Commune")
        coordinator?.updateButtonSelection(3)
    }
    private func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        navigationController?.navigationBar.isHidden = true
        registerTableCells()
    }
   
    private func registerTableCells() {
        let cellIdentifiers = ["FindMembersTableViewCell", "CompaniesTableViewCell", "EventTableViewCell"]
        for identifier in cellIdentifiers {
            tableView.register(UINib(nibName: identifier, bundle: nil), forCellReuseIdentifier: identifier)
        }
    }
}
extension CommuneViewController: UITableViewDataSource, UITableViewDelegate {
    
    enum SectionType: Int, CaseIterable {
        case findMembers = 0
        case companies
        case events
        
        var cellIdentifier: String {
            switch self {
            case .findMembers: return "FindMembersTableViewCell"
            case .companies: return "CompaniesTableViewCell"
            case .events: return "EventTableViewCell"
            }
        }
        
        var heightForRow: CGFloat {
            switch self {
            case .findMembers: return 151
            case .companies: return 45
            case .events: return 357
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
        cell.selectionStyle = .none
       
        switch section {
        case .findMembers:
            if let findMembersCell = cell as? FindMembersTableViewCell {
                //myBookingCell.btnBooking.addTarget(self, action: #selector(btnBookingTappedAction), for: .touchUpInside)
                findMembersCell.delegate = self
                
                
            }
        case .companies:
            if let companiesCell = cell as? CompaniesTableViewCell {
                //myBookingCell.btnBooking.addTarget(self, action: #selector(btnBookingTappedAction), for: .touchUpInside)
                companiesCell.delegate  = self
            }
        case .events:
            if let eventsCell = cell as? EventTableViewCell {
                eventsCell.delegateButtonRSVP = self
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
}

extension CommuneViewController {
    enum Event {
        case loading
        case stopLoading
        case dataLoaded
        case error(Error?)
    }
}
extension CommuneViewController:BrowseDirectoryActionDelegate{
    func btnBrowseDirectoryTappedAction() {
        let membersListVC = UIViewController.createController(storyBoard: .Commune, ofType: ListOfMembersViewController.self)
        membersListVC.coordinator = self.coordinator
        self.navigationController?.pushViewController(membersListVC, animated: true)
    }
    
    
}
extension CommuneViewController:ButtonCompaniesTappedDelegate{
    func btnCompaniesTappedAction() {
        let companiesVC = UIViewController.createController(storyBoard: .Commune, ofType: CompaniesListViewController.self)
        companiesVC.coordinator = self.coordinator
        self.navigationController?.pushViewController(companiesVC, animated: true)
    }
}
extension CommuneViewController:ButtonRSVPTappedDelegate{
    func btnRSVPTappedAction() {
        let rsvpVC = UIViewController.createController(storyBoard: .Commune, ofType: RSVPButtonViewController.self)
        rsvpVC.modalPresentationStyle = .overFullScreen
        rsvpVC.modalTransitionStyle = .crossDissolve
        rsvpVC.view.backgroundColor = UIColor.clear
        self.present(rsvpVC, animated: true)
    }
  
}

//extension CommuneViewController: BookButtonActionDelegate {
//    func showBookRoomDetailsVC(meetingRoomId: Int) {
//        // Implement your logic here
//    }
//    
//    func showBookMeetingRoomsVC() {
//        let bookMeetingRoomVC = UIViewController.createController(storyBoard: .Booking, ofType: BookMeetingRoomViewController.self)
//        navigationController?.pushViewController(bookMeetingRoomVC, animated: true)
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
//}
