//
//  MyVisitorsViewController.swift
//  RSOWorkspace
//
//  Created by Sumit Aquil on 10/04/24.
//

import UIKit

enum CellIdentifierMyVisitors: String {
    case selectDate = "SelectDateTableViewCell"
    case visitorDetails = "VisitorDetailsTableViewCell"
}

enum SectionTypeMyVisitors: Int, CaseIterable {
    case selectDate
    case visitorDetails
}

class MyVisitorsViewController: UIViewController{
    
    var coordinator: RSOTabBarCordinator?
    @IBOutlet weak var tableView: UITableView!
    
    var listItems: [RSOCollectionItem] = []
    var visitorEmailDelegate:sendVisitorEmailDelegate?
    
    var myVisitorResponse: [MyVisitor] = []
    
    var eventHandler: ((_ event: Event) -> Void)?
    var apiRequestScheduleVisitorsRequest = ScheduleVisitorsRequest()
    var displayscheduleVisitorsDetailsNextScreen = DisplayScheduleVisitorsDetailModel()
    let currentDate = Date.formatSelectedDate(format: .yyyyMMdd, date: Date())
    override func viewDidLoad() {
        super.viewDidLoad()
        
        coordinator?.hideBackButton(isHidden: false)
        coordinator?.setTitle(title: "My Visitors")
        setupTableView()
        fetchMyVisitors(date: currentDate)
    }
    
    @IBAction func btnBackAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
        
    }
    private func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.registerCellsMyVisitors()
        navigationController?.navigationBar.isHidden = true
        tableView.register(UINib(nibName: "VisitorsTableViewCell", bundle: nil), forCellReuseIdentifier: "VisitorsTableViewCell")
    }
    private func fetchMyVisitors(date:String) {
        APIManager.shared.request(
            modelType: MyVisitorAPIResponse.self,
            type: VisitorsEndPoint.myVisitors(date: date)) { response in
                switch response {
                case .success(let response):
                    self.myVisitorResponse = response.data
                    print("myVisitorResponse response is",self.myVisitorResponse)
                    // Optional: Convert visitorDetails JSON string to array for each visitor
                    self.myVisitorResponse.forEach { visitor in
                        _ = visitor.visitorDetails // This will parse the visitor details JSON string
                    }
                    DispatchQueue.main.async {
                        if self.myVisitorResponse.isEmpty {
                            // Show a toast message if no visitors are found
                            self.view.makeToast("No Visitors found", duration: 2.0,position: .center)
                        }
                        self.tableView.reloadData()
                    }
                    self.eventHandler?(.dataLoaded)
                case .failure(let error):
                    self.eventHandler?(.error(error))
                }
            }
    }
    private func cancelVisitors(visitorId: Int, cell: VisitorDetailsTableViewCell, completion: @escaping () -> Void) {
        RSOLoader.showLoader()
        APIManager.shared.request(
            modelType: CancelVisitorResponseModel.self,
            type: VisitorsEndPoint.cancelVisitor(visitorId: visitorId)) { response in
                switch response {
                case .success(let response):
                    RSOLoader.removeLoader()
                    if response.status == true {
                        print("Visitor canceled successfully")
                        // Update the UI after the visitor is canceled
                        self.myVisitorResponse.removeAll { $0.id == visitorId }
                        DispatchQueue.main.async {
                            self.tableView.reloadData()
                            // Hide buttons after the API call is successful
                            cell.hideEditAndCancelButtons()
                        }
                        completion()  // Call completion to hide buttons
                    }
                    self.eventHandler?(.dataLoaded)
                case .failure(let error):
                    self.eventHandler?(.error(error))
                }
            }
    }
    
    
}

// MARK: - UITableViewDataSource, UITableViewDelegate

extension MyVisitorsViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return SectionTypeMyVisitors.allCases.count
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch SectionTypeMyVisitors(rawValue: section) {
        case .visitorDetails:
            return myVisitorResponse.count
        default:
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let section = SectionTypeMyVisitors(rawValue: indexPath.section) else { return UITableViewCell() }
        
        switch section {
            
        case .selectDate:
            let  cell =  tableView.dequeueReusableCell(withIdentifier: CellIdentifierMyVisitors.selectDate.rawValue, for: indexPath) as! SelectDateTableViewCell
            cell.delegate = self
            cell.selectionStyle = .none
            // Allow all dates, including past dates, in this specific cell
            cell.calender.minimumDate = nil
            return cell
            
        case .visitorDetails:
            let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifierMyVisitors.visitorDetails.rawValue, for: indexPath) as! VisitorDetailsTableViewCell
            let item = myVisitorResponse[indexPath.row]
            cell.setData(item: item)
            cell.delegate = self
            cell.indexPath = indexPath
            cell.selectionStyle = .none
            return cell
            
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let section = SectionTypeMyVisitors(rawValue: indexPath.section) else { return 0 }
        
        switch section {
        case .selectDate:
            return UITableView.automaticDimension
        case .visitorDetails:
            return 180
            
        }
    }
}

extension MyVisitorsViewController: SelectDateTableViewCellDelegate {
    func didSelectDate(_ actualFormatOfDate: Date) {
        // on date change save api formatted date for this vc model and next vc model
        let apiDate = Date.formatSelectedDate(format: .yyyyMMdd, date: actualFormatOfDate)
        apiRequestScheduleVisitorsRequest.arrival_date = apiDate
        // save formated date to show in next screen
        let displayDate = Date.formatSelectedDate(format: .EEEEddMMMMyyyy, date: actualFormatOfDate)
        displayscheduleVisitorsDetailsNextScreen.date = displayDate
        // Fetch visitors for selected date
        fetchMyVisitors(date:apiDate)
    }
}
extension MyVisitorsViewController:EditVisitorDetailsTableViewCellDelegate{
  
    func cancelVisitor(visitorManagementId: Int, cell: VisitorDetailsTableViewCell) {
        cancelVisitors(visitorId: visitorManagementId, cell: cell) {
               if let indexPath = self.tableView.indexPath(for: cell) {
                   self.myVisitorResponse[indexPath.row].isCancelled = true
                    // Ensure UI updates are performed on the main thread
                   DispatchQueue.main.async {
                       self.tableView.reloadRows(at: [indexPath], with: .none)
                   }
               }
           }
    }
    func showeditVisitorDetailsScreen(visitorManagementId: Int, email: String, phone: String, name: String, reasonId: Int,reasonForVisit: String, arrivaldate: String, starttime: String, endtime: String, vistordetail: [MyVisitorDetail]) {
        let editVisitorsVC = UIViewController.createController(storyBoard: .VisitorManagement, ofType: ScheduleVisitorsViewController.self)
        editVisitorsVC.isEditMode = true
        editVisitorsVC.visitorId = visitorManagementId
        editVisitorsVC.email = email
        editVisitorsVC.name = name
        editVisitorsVC.phone = phone
        editVisitorsVC.reasonId = reasonId
        editVisitorsVC.reasonForVisit = reasonForVisit
        editVisitorsVC.arrivalDate = arrivaldate
        editVisitorsVC.start_time = starttime
        editVisitorsVC.end_time = endtime
        editVisitorsVC.myvisitordetailsArray = vistordetail
        self.navigationController?.pushViewController(editVisitorsVC, animated: true)
    }
  
}
extension MyVisitorsViewController {
    enum Event {
        case dataLoaded
        case error(Error?)
    }
}

// MARK: - UITableView Extension
extension UITableView {
    func registerCellsMyVisitors() {
        let cellIdentifiers: [CellIdentifierMyVisitors] = [.selectDate, .visitorDetails]
        cellIdentifiers.forEach { reuseIdentifier in
            register(UINib(nibName: reuseIdentifier.rawValue, bundle: nil), forCellReuseIdentifier: reuseIdentifier.rawValue)
        }
    }
}


