//
//  MyBookingViewController.swift
//  RSOWorkspace
//
//  Created by Sumit Aquil on 28/02/24.
//

import UIKit
import Toast_Swift

struct MyBookingItem {
    var dateString: String = ""
    var filteredBookings: [MeetingBooking] = []
    //var filteredBookingsDesk: [DeskBooking] = []
}

import UIKit

class MyBookingViewController: UIViewController {

    var coordinator: RSOTabBarCordinator?
    var selectedButtonTag = 1
    @IBOutlet weak var btnAll: RSOButton!
    @IBOutlet weak var btnMeetings: RSOButton!
    @IBOutlet weak var btnWorkDesk: RSOButton!
    @IBOutlet weak var tableView: UITableView!
    var myBookingResponseData: MyBookingResponse?
    var eventHandler: ((_ event: Event) -> Void)? // Data Binding Closure
    var filteredSections: [MyBookingItem] = [] // Structure to store filtered sections
    var selectedSection: Int?
    
    let selectedButtonColor = UIColor(named: "BFBFBF") ?? .black
    let defaultButtonColor  = UIColor(named: "000000") ?? .black
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        coordinator?.hideBackButton(isHidden: false)
        coordinator?.setTitle(title: "My Bookings")
        
        customizeCell()
        setupTableView()
        buttonSetUp()
        reloadTable(dataArray: myBookingResponseData?.mergedBookings)
       
        setButtonAppearance(button: btnAll, backgroundColor: selectedButtonColor, textColor: .white)
        
        
    }

    func customizeCell() {
        btnAll.layer.cornerRadius = btnAll.bounds.height / 2
        btnMeetings.layer.cornerRadius = btnMeetings.bounds.height / 2
        btnWorkDesk.layer.cornerRadius = btnWorkDesk.bounds.height / 2
    }
    func buttonSetUp(){
        setButtonAppearance(button: btnAll, backgroundColor: defaultButtonColor, textColor: .white)
        setButtonAppearance(button: btnMeetings, backgroundColor: defaultButtonColor, textColor: .white)
        setButtonAppearance(button: btnWorkDesk, backgroundColor: defaultButtonColor, textColor: .white)
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
                            self.myBookingResponseData = bookings
                            self.reloadData()
                          RSOLoader.removeLoader()
                        }
                    
                        self.eventHandler?(.dataLoaded)
                    
                case .failure(let error):
                    self.eventHandler?(.error(error))
                    DispatchQueue.main.async {
                      RSOLoader.removeLoader()
                        RSOToastView.shared.show("\(error.localizedDescription)", duration: 2.0, position: .center)
                    }
                }
            }
    }
    @IBAction func buttonTapped(_ sender: UIButton) {
       
        buttonSetUp()
        selectedButtonTag = sender.tag
        reloadData()
        myBookingListingAPI()
        
        sender.backgroundColor = selectedButtonColor
        sender.setTitleColor(.black, for: .normal)
        selectedSection = nil
        self.tableView.reloadData()
    }
    func reloadData(){
        switch selectedButtonTag {
        case 1:
            reloadTable(dataArray: myBookingResponseData?.mergedBookings)
        case 2:
            reloadTable(dataArray: myBookingResponseData?.bookMeetings)
        case 3:
            reloadTable(dataArray: myBookingResponseData?.bookDesks)
        default:
            break
        }

    }
    func setButtonAppearance(button: UIButton, backgroundColor: UIColor, textColor: UIColor) {
        button.backgroundColor = backgroundColor
        button.setTitleColor(textColor, for: .normal)
    }

    private func setupTableView() {
        tableView.register(UINib(nibName: "MyBookingOpenTableViewCell", bundle: nil), forCellReuseIdentifier: "MyBookingOpenTableViewCell")
        tableView.dataSource = self
        tableView.delegate = self
    }
    private func reloadTable(dataArray: MyBookingResponse.BookingData?) {
        if let bookingsData = dataArray {
            switch bookingsData {
            case .dictionary(let bookingsDictionary):
                // Handle dictionary case
                filteredSections = bookingsDictionary.map { (date, bookings) in
                    return MyBookingItem(dateString: date, filteredBookings: bookings)
                }
               
                self.tableView.reloadData()
            case .array(_):
                filteredSections = []
                self.tableView.reloadData()
                // Show error message if no bookings data is available
                RSOToastView.shared.show("No Future Booking", duration: 2.0, position: .center)
            }
        }else {
            
        }
    }
}

extension MyBookingViewController: UITableViewDataSource, UITableViewDelegate {

    func numberOfSections(in tableView: UITableView) -> Int {
        return filteredSections.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredSections[section].filteredBookings.count
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
   
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let date = filteredSections[section].dateString
        let formattedDate = Date.formattedDayAndMonth(from: date)
        let headerView = MyBookingDateHeaderView(reuseIdentifier: "MyBookingDateHeaderView")
        // Set the date and day name text for the label in your custom header view
        if let dayName = formattedDate?.dayName{
            headerView.dayLabel.text = "\(dayName)"
        }
        if let dayMonth = formattedDate?.dateMonth{
            headerView.dateMonthLabel.text = "\(dayMonth)"
        }
        return headerView
    }
    

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyBookingOpenTableViewCell", for: indexPath) as! MyBookingOpenTableViewCell
        let booking = filteredSections[indexPath.section].filteredBookings[indexPath.row]
        cell.setData(item: booking)
//        // Safely access filteredBookingsDesk if it has enough data
//          if indexPath.row < filteredSections[indexPath.section].filteredBookingsDesk.count {
//              let bookingDesk = filteredSections[indexPath.section].filteredBookingsDesk[indexPath.row]
//              cell.setDataDesk(item: bookingDesk)
//          }
        cell.delegate = self
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Handle cell selection if needed
    }
}
extension MyBookingViewController:MyBookingOpenTableViewCellDelegate {
    func displayBookingQRCode() {
        let displayQRVC = UIViewController.createController(storyBoard: .Booking, ofType: DisplayQRCodeViewController.self)
        displayQRVC.modalTransitionStyle = .crossDissolve
        displayQRVC.modalPresentationStyle = .overCurrentContext
        self.present(displayQRVC, animated: true)
    }
}
extension MyBookingViewController {
    enum Event {
        case dataLoaded
        case error(Error?)
    }
}
