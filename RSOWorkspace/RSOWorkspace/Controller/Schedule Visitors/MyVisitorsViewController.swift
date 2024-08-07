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
    
    var isEditingVisitor: Bool = false
    var editingIndexPath: IndexPath?
    var email = ""
    var name = ""
    var phone = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        
        coordinator?.hideBackButton(isHidden: false)
        coordinator?.setTitle(title: "My Visitors")
        setupTableView()
        fetchMyVisitors()
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
    private func fetchMyVisitors() {
        APIManager.shared.request(
            modelType: MyVisitorAPIResponse.self,
            type: VisitorsEndPoint.myVisitors) { response in
                switch response {
                case .success(let response):
                    self.myVisitorResponse = response.data
                    print("myVisitorResponse response is",self.myVisitorResponse)
                    // Optional: Convert visitorDetails JSON string to array for each visitor
                    self.myVisitorResponse.forEach { visitor in
                        _ = visitor.visitorDetailsArray // This will parse the visitor details JSON string
                    }
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
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
            return cell
            
            
        case .visitorDetails:
            if isEditingVisitor, editingIndexPath == indexPath {
                let cell = tableView.dequeueReusableCell(withIdentifier: "VisitorsTableViewCell", for: indexPath) as! VisitorsTableViewCell
                cell.selectionStyle = .none
                let item = myVisitorResponse[indexPath.row]
                cell.addButtonView.isHidden = true
                cell.editButtonView.isHidden = false
                cell.visitorDetailDelegate = self
                cell.lblInviteMoreVisitors.isHidden = true
                cell.indexPath = indexPath
                // Set visitor details to cell's text fields
                if let visitorDetailsArray = item.visitorDetailsArray, !visitorDetailsArray.isEmpty {
                    // Display the first visitor email for simplicity
                    let visitor = visitorDetailsArray[0]
                    cell.txtName.text = visitor.visitorName
                    cell.txtEmail.text = visitor.visitorEmail
                    cell.txtPhone.text = visitor.visitorPhone
                }
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifierMyVisitors.visitorDetails.rawValue, for: indexPath) as! VisitorDetailsTableViewCell
                let item = myVisitorResponse[indexPath.row]
                cell.setData(item: item)
                // Ensure the visitor details are parsed
                if let visitorDetailsArray = item.visitorDetailsArray, !visitorDetailsArray.isEmpty {
                    // Display the first visitor email for simplicity
                    let visitor = visitorDetailsArray[0]
                    cell.setVisitorDetails(visitor: visitor)
                } else {
                    cell.setVisitorDetails(visitor: VisitorDetail(visitorName: nil, visitorEmail: "No visitors available", visitorPhone: nil))
                }
                cell.delegate = self
                cell.indexPath = indexPath
                cell.selectionStyle = .none
                return cell
            }
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let section = SectionTypeMyVisitors(rawValue: indexPath.section) else { return 0 }
        
        switch section {
        case .selectDate:
            return 334
        case .visitorDetails:
            if isEditingVisitor, editingIndexPath == indexPath {
                return 278
            } else {
                return 180
            }
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
        
    }
}
extension MyVisitorsViewController:EditVisitorDetailsTableViewCellDelegate{
    func showeditVisitorDetailsScreen(for indexPath: IndexPath) {
        isEditingVisitor = true
        editingIndexPath = indexPath
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
    
}
extension MyVisitorsViewController:DisplayVisitorDetailsDelegate{
    func displayVisitorsDetailsCell(for indexPath: IndexPath) {
        isEditingVisitor = false
        editingIndexPath = indexPath
        tableView.reloadRows(at: [indexPath], with: .automatic)
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


