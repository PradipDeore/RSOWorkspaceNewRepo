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
    var visitorsDetailArray : [VisitorDetails] = []
    var myVisitorResponse: [MyVisitor] = []
    
    var eventHandler: ((_ event: Event) -> Void)?
    var apiRequestScheduleVisitorsRequest = ScheduleVisitorsRequest()
    var displayscheduleVisitorsDetailsNextScreen = DisplayScheduleVisitorsDetailModel()
    
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
    }
    private func fetchMyVisitors() {
        self.eventHandler?(.loading)
        APIManager.shared.request(
            modelType: MyVisitorAPIResponse.self,
            type: VisitorsEndPoint.myVisitors) { response in
                self.eventHandler?(.stopLoading)
                switch response {
                case .success(let response):
                    self.myVisitorResponse = response.data
                    print("myVisitorResponse is",self.myVisitorResponse.count)
                    print("myVisitorResponse response is",self.myVisitorResponse)

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
            let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifierMyVisitors.visitorDetails.rawValue, for: indexPath) as! VisitorDetailsTableViewCell
            cell.selectionStyle = .none
            let item = myVisitorResponse[indexPath.row]
            cell.setData(item: item)
            return cell
            
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let section = SectionTypeMyVisitors(rawValue: indexPath.section) else { return 0 }
        
        switch section {
        case .selectDate:
            return 334
        case .visitorDetails:
            return 180
        }
    }
}

extension MyVisitorsViewController: SelectDateTableViewCellDelegate {
    func didSelectDate(_ actualFormatOfDate: Date) {
        // on date change save api formatted date for this vc model and next vc model
        let apiDate = Date.formatSelectedDate(format: .yyyyMMdd, date: actualFormatOfDate)
        apiRequestScheduleVisitorsRequest.arrivalDate = apiDate
        // save formated date to show in next screen
        let displayDate = Date.formatSelectedDate(format: .EEEEddMMMMyyyy, date: actualFormatOfDate)
        displayscheduleVisitorsDetailsNextScreen.date = displayDate
        
    }
}
// MARK: - Enums

extension MyVisitorsViewController {
    enum Event {
        case loading
        case stopLoading
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


