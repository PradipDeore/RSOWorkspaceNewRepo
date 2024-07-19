//
//  BookingViewController.swift
//  RSOWorkspace
//
//  Created by Sumit Aquil on 23/02/24.
//

import UIKit

class BookingViewController: UIViewController,RSOTabCoordinated {
    
    var coordinator: RSOTabBarCordinator?
    @IBOutlet weak var tableView: UITableView!
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
        tableView.register(UINib(nibName: "BookDeskTableViewCell", bundle: nil), forCellReuseIdentifier: "BookDeskTableViewCell")
        tableView.register(UINib(nibName: "BookMeetingRoomTableViewCell", bundle: nil), forCellReuseIdentifier: "BookMeetingRoomTableViewCell")
        tableView.register(UINib(nibName: "OtherBookingsTableViewCell", bundle: nil), forCellReuseIdentifier: "OtherBookingsTableViewCell")
        tableView.register(UINib(nibName: "BookOfficeTableViewCell", bundle: nil), forCellReuseIdentifier: "BookOfficeTableViewCell")
    
       navigationController?.navigationBar.isHidden = true
    }
    
}

extension BookingViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
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
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "BookDeskTableViewCell", for: indexPath) as! BookDeskTableViewCell
            cell.selectionStyle = .none
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "BookMeetingRoomTableViewCell", for: indexPath) as! BookMeetingRoomTableViewCell
            cell.selectionStyle = .none
            return cell
        case 2:
            let cell =  tableView.dequeueReusableCell(withIdentifier: "OtherBookingsTableViewCell", for: indexPath) as! OtherBookingsTableViewCell
            cell.selectionStyle = .none
            return cell

        case 3:
            let cell =  tableView.dequeueReusableCell(withIdentifier: "BookOfficeTableViewCell", for: indexPath) as! BookOfficeTableViewCell
            cell.selectionStyle = .none
            return cell
        default:
            return UITableViewCell()
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section{
        case 0:
            let bookDeskVC = UIViewController.createController(storyBoard: .Booking, ofType: DeskBookingViewController.self)
            //bookDeskVC.meetingId = meetingRoomId
            //bookDeskVC.requestModel = apiRequestModelRoomListing
           // bookDeskVC.displayBookingDetails = displayBookingDetailsNextScreen
            bookDeskVC.coordinator = self.coordinator
            self.navigationController?.pushViewController(bookDeskVC, animated: true)
        case 1:
            let bookMeetingRoomVC = UIViewController.createController(storyBoard: .Booking, ofType: BookMeetingRoomViewController.self)
            bookMeetingRoomVC.coordinator = self.coordinator
            self.navigationController?.pushViewController(bookMeetingRoomVC, animated: true)
        case 3:
            let bookAnOfiiceVC = UIViewController.createController(storyBoard: .Booking, ofType: BookAnOfficeViewController.self)
            bookAnOfiiceVC.coordinator = self.coordinator
            self.navigationController?.pushViewController(bookAnOfiiceVC, animated: true)
            
        default:
            break
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0 ,1:
            return 100
        case 2:
            return 125
        case 3:
            return 200
        default:
            return 100
        }
    }
    

}

