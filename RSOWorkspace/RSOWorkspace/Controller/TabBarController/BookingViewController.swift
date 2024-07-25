//
//  BookingViewController.swift
//  RSOWorkspace
//
//  Created by Sumit Aquil on 23/02/24.
//

import UIKit

class BookingViewController: UIViewController, RSOTabCoordinated {
    
    var coordinator: RSOTabBarCordinator?
    @IBOutlet weak var tableView: UITableView!
    
    enum BookingSection: Int, CaseIterable {
        case desk = 0
        case meetingRoom
        case otherBookings
        case office
        
        var height: CGFloat {
            switch self {
            case .desk, .meetingRoom:
                return 100
            case .otherBookings:
                return UserHelper.shared.isGuest() ? 0 : 125
            case .office:
                return 200
            }
        }
        
        var cellIdentifier: String {
            switch self {
            case .desk:
                return "BookDeskTableViewCell"
            case .meetingRoom:
                return "BookMeetingRoomTableViewCell"
            case .otherBookings:
                return "OtherBookingsTableViewCell"
            case .office:
                return "BookOfficeTableViewCell"
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.coordinator?.hideTopViewForHome(isHidden: false)
        coordinator?.hideBackButton(isHidden: true)
        coordinator?.setTitle(title: "Booking")
        coordinator?.updateButtonSelection(1)
    }
    
    private func setupTableView() {
        BookingSection.allCases.forEach { section in
            tableView.register(UINib(nibName: section.cellIdentifier, bundle: nil), forCellReuseIdentifier: section.cellIdentifier)
        }
        navigationController?.navigationBar.isHidden = true
    }
}

extension BookingViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return BookingSection.allCases.count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20 // Adjust the height of the header between sections
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView() // Return an empty view for the header between sections
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let section = BookingSection(rawValue: indexPath.section) else {
            return UITableViewCell()
        }
        switch section
        {
        case .office:
            let cell =  tableView.dequeueReusableCell(withIdentifier: "BookOfficeTableViewCell", for: indexPath) as! BookOfficeTableViewCell
            cell.delegate = self
            cell.selectionStyle = .none
            return cell
        case .desk:
            break
        case .meetingRoom:
            break
        case .otherBookings:
            break

        }
        let cell = tableView.dequeueReusableCell(withIdentifier: section.cellIdentifier, for: indexPath)
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let section = BookingSection(rawValue: indexPath.section) else {
            return
        }
        switch section {
        case .desk:
            let bookDeskVC = UIViewController.createController(storyBoard: .Booking, ofType: DeskBookingViewController.self)
            bookDeskVC.coordinator = self.coordinator
            self.navigationController?.pushViewController(bookDeskVC, animated: true)
        case .meetingRoom:
            let bookMeetingRoomVC = UIViewController.createController(storyBoard: .Booking, ofType: BookMeetingRoomViewController.self)
            bookMeetingRoomVC.coordinator = self.coordinator
            self.navigationController?.pushViewController(bookMeetingRoomVC, animated: true)
        case .otherBookings:
            // Handle selection if needed
            break
        case .office:
           break
         
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let section = BookingSection(rawValue: indexPath.section) else {
            return 100
        }
        return section.height
    }
}
extension BookingViewController:BookOfficeTableViewCellDelegate{
    func NavigateToShortTermOfficeBooking() {
        let bookOfficeVC = UIViewController.createController(storyBoard: .OfficeBooking, ofType: ShortTermBookAnOfficeViewController.self)
        bookOfficeVC.coordinator = self.coordinator
        self.navigationController?.pushViewController(bookOfficeVC, animated: true)
    }
    
    func NavigateToLongTermOfficeBooking() {
        let bookOfficeVC = UIViewController.createController(storyBoard: .Booking, ofType: BookAnOfficeViewController.self)
        bookOfficeVC.coordinator = self.coordinator
        self.navigationController?.pushViewController(bookOfficeVC, animated: true)
    }
    
    
}
