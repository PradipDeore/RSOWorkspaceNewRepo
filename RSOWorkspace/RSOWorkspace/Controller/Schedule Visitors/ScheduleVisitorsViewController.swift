//
//  ScheduleVisitorsViewController.swift
//  RSOWorkspace
//
//  Created by Sumit Aquil on 03/04/24.
//

import UIKit
import IQKeyboardManagerSwift
import Toast_Swift

enum CellIdentifierScheduleVisitors: String {
    case selectDate = "SelectDateTableViewCell"
    case selectTime = "SelectTimeTableViewCell"
    case reasonForVisit = "ReasonForVisitTableViewCells"
    case invitedVisitors = "InviteVisitorsTableViewCell"
    case btnCancelAndSave = "ButtonCancelAndSaveTableViewCell"
}

enum SectionTypeScheduleVisitors: Int, CaseIterable {
    case selectDate
    case selectTime
    case reasonForVisit
    case invitedVisitors
    case btnCancelAndSave
}


class ScheduleVisitorsViewController: UIViewController{
    
    @IBOutlet weak var tableView: UITableView!
    var listItems: [RSOCollectionItem] = []
    var visitorEmailDelegate:sendVisitorEmailDelegate?
    var visitorsDetailArray : [VisitorDetails] = []
    var ddOptions: [Reason] = []
    var eventHandler: ((_ event: Event) -> Void)?
    var apiRequestScheduleVisitorsRequest = ScheduleVisitorsRequest()
    var displayscheduleVisitorsDetailsNextScreen = DisplayScheduleVisitorsDetailModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let emptyVisitor = VisitorDetails(visitorName: "", visitorEmail: "", visitorPhone: "")
        visitorsDetailArray.append(emptyVisitor)
        setupTableView()
        fetchreasonForVisit()
    }
    
    @IBAction func btnBackAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    private func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        
        let nib = UINib(nibName: "VisitorsTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "VisitorsTableViewCell")
        let niblabel = UINib(nibName: "LabelVisitorsTableViewCell", bundle: nil)
        tableView.register(niblabel, forCellReuseIdentifier: "LabelVisitorsTableViewCell")
        
        tableView.registerCellsScheduleVisitors()
        navigationController?.navigationBar.isHidden = true
    }
    
    private func fetchreasonForVisit() {
        APIManager.shared.request(
            modelType: ReasonForVisit.self, // Assuming your API returns an array of locations
            type: VisitorsEndPoint.reasonForVisit) { response in
                switch response {
                case .success(let response):
                    self.ddOptions = response.data
                    print("count is",self.ddOptions.count)
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

extension ScheduleVisitorsViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return SectionTypeScheduleVisitors.allCases.count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch SectionTypeScheduleVisitors(rawValue: section) {
        case .invitedVisitors:
            return visitorsDetailArray.count + 2
        default:
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let section = SectionTypeScheduleVisitors(rawValue: indexPath.section) else { return UITableViewCell() }
        
        switch section {
            
        case .selectDate:
            let  cell =  tableView.dequeueReusableCell(withIdentifier: CellIdentifierScheduleVisitors.selectDate.rawValue, for: indexPath) as! SelectDateTableViewCell
            cell.delegate = self
            cell.selectionStyle = .none
            return cell
            
        case .selectTime:
            let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifierScheduleVisitors.selectTime.rawValue, for: indexPath) as! SelectTimeTableViewCell
            cell.delegate = self
            cell.selectionStyle = .none
            
            return cell
        case .reasonForVisit:
            let cell =  tableView.dequeueReusableCell(withIdentifier: CellIdentifierScheduleVisitors.reasonForVisit.rawValue, for: indexPath) as! ReasonForVisitTableViewCells
            cell.delegate = self
            cell.dropdownOptions = self.ddOptions
            cell.selectionStyle = .none
            
            return cell
        case .invitedVisitors:
            if indexPath.row == 0 {
                let cell =  tableView.dequeueReusableCell(withIdentifier: "LabelVisitorsTableViewCell", for: indexPath) as! LabelVisitorsTableViewCell
                cell.selectionStyle = .none
                return cell
            }
            //last row for eg count is 3 indexpath.row = 3
            else if indexPath.row == (visitorsDetailArray.count + 1) {
                let cell =  tableView.dequeueReusableCell(withIdentifier: "VisitorsTableViewCell", for: indexPath) as! VisitorsTableViewCell
                cell.delegate = self
                
                return cell
            }else {
                
                let cell =  tableView.dequeueReusableCell(withIdentifier: CellIdentifierScheduleVisitors.invitedVisitors.rawValue, for: indexPath)as! InviteVisitorsTableViewCell
                cell.delegate = self
                cell.selectionStyle = .none
                
                // Get visitor detail from visitorsDetailArray
                let visitorDetail = visitorsDetailArray[indexPath.row - 1]
                cell.lblVisitorEmail.text = visitorDetail.visitorEmail
                cell.visitorEmailView.isHidden = false
                if indexPath.row == 0 {
                    if visitorsDetailArray.first?.visitorEmail == "" {
                        cell.visitorEmailView.isHidden = true
                    }
                }
                return cell
            }
            
        case .btnCancelAndSave:
            let cell =  tableView.dequeueReusableCell(withIdentifier: CellIdentifierScheduleVisitors.btnCancelAndSave.rawValue, for: indexPath)as! ButtonCancelAndSaveTableViewCell
            cell.delegate = self
            cell.selectionStyle = .none
            return cell
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let section = SectionTypeScheduleVisitors(rawValue: indexPath.section) else { return 0 }
        
        switch section {
        case .selectDate:
            return 334
        case .selectTime:
            return 80
        case .reasonForVisit:
            return 100
        case .invitedVisitors:
            if indexPath.row == 0{
                return 53
                
                //last row for eg count is 3 indexpath.row = 3
            } else if indexPath.row == (visitorsDetailArray.count + 1) {
                return 278
            } else if visitorsDetailArray.first?.visitorEmail == "" {
                return 0
            }else {
                return 53
            }
        case .btnCancelAndSave:
            return 46
        }
    }
}
// MARK: - SelectReasonTableViewCellDelegate
extension ScheduleVisitorsViewController: ReasonForVisitTableViewCellDelegate {
    func dropdownButtonTapped(selectedOption: Reason) {
        // Implement what you want to do with the selected option, for example:
        print("Selected option: \(selectedOption.reason),\(selectedOption.id)")
        apiRequestScheduleVisitorsRequest.reasonOfVisit = selectedOption.reason
        displayscheduleVisitorsDetailsNextScreen.reasonForVisit = selectedOption.reason
    }
    
    func presentAlertController(alertController: UIAlertController) {
        // Present the alert controller from the view controller
        present(alertController, animated: true, completion: nil)
    }
}

extension ScheduleVisitorsViewController: SelectDateTableViewCellDelegate {
    func didSelectDate(_ actualFormatOfDate: Date) {
        // on date change save api formatted date for this vc model and next vc model
        let apiDate = Date.formatSelectedDate(format: .yyyyMMdd, date: actualFormatOfDate)
        apiRequestScheduleVisitorsRequest.arrivalDate = apiDate
        // save formated date to show in next screen
        let displayDate = Date.formatSelectedDate(format: .EEEEddMMMMyyyy, date: actualFormatOfDate)
        displayscheduleVisitorsDetailsNextScreen.date = displayDate
        
    }
}
extension ScheduleVisitorsViewController: SelectTimeTableViewCellDelegate{
  func selectFulldayStatus(_ isFullDay: Bool) {
  
  }
  
    func didSelectStartTime(_ startTime: Date) {
        // for api request
        let apiStartTime = Date.formatSelectedDate(format: .HHmm, date: startTime)
        apiRequestScheduleVisitorsRequest.startTime = apiStartTime
        //display in next vc
        let displayStartTime = Date.formatSelectedDate(format: .hhmma, date: startTime)
        displayscheduleVisitorsDetailsNextScreen.startTime = displayStartTime
    }
    
    func didSelectEndTime(_ endTime: Date) {
        // for api request
        let apiEndTime = Date.formatSelectedDate(format: .HHmm, date: endTime)
        apiRequestScheduleVisitorsRequest.endTime = apiEndTime
        //display in next vc
        let displayEndTime = Date.formatSelectedDate(format: .hhmma, date: endTime)
        displayscheduleVisitorsDetailsNextScreen.endTime = displayEndTime
        
    }
}

extension ScheduleVisitorsViewController:ButtonSaveDelegate{
    
    func btnSaveTappedAction() {
        
        
        let visitorsDetailsVC = UIViewController.createController(storyBoard: .VisitorManagement, ofType: ScheduledVisitorDetatailsViewController.self)
       //for api
        visitorsDetailsVC.requestModel = self.apiRequestScheduleVisitorsRequest
        //for display
        visitorsDetailsVC.displayscheduleVisitorsDetails = self.displayscheduleVisitorsDetailsNextScreen
        visitorsDetailsVC.modalTransitionStyle = .crossDissolve
        visitorsDetailsVC.modalPresentationStyle = .overFullScreen
        visitorsDetailsVC.view.backgroundColor = UIColor.clear
        self.present(visitorsDetailsVC, animated: true)
    }
}

extension ScheduleVisitorsViewController:VisitorsTableViewCellDelegate{
   

    func addVisitors(email: String, name: String, phone: String) {
        
        let obj = VisitorDetails(visitorName: name, visitorEmail: email, visitorPhone: phone)
        
        // Remove the empty visitor detail if it exists
        if visitorsDetailArray.count == 1, let firstVisitor = visitorsDetailArray.first, firstVisitor.visitorEmail == "" {
            visitorsDetailArray.removeFirst()
        }
        
        // Append the new visitor detail
        visitorsDetailArray.append(obj)
        self.apiRequestScheduleVisitorsRequest.visitorDetails = visitorsDetailArray
        self.displayscheduleVisitorsDetailsNextScreen.visitors = visitorsDetailArray
        tableView.reloadData()
        
    }
    
    func InviteMoreVisitors() {
        let inviteVisitorsVC = UIViewController.createController(storyBoard: .VisitorManagement, ofType: InviteVisitorsViewController.self)
        inviteVisitorsVC.modalPresentationStyle = .overFullScreen
        inviteVisitorsVC.modalTransitionStyle = .crossDissolve
        inviteVisitorsVC.view.backgroundColor = UIColor.clear
        inviteVisitorsVC.visitorEmailDelegate = self
        self.present(inviteVisitorsVC, animated: true)
    }
    
}
extension ScheduleVisitorsViewController:InviteVisitorsTableViewCellDelegate{
    
    func btnDeleteVisitors(buttonTag: Int) {
        
        visitorsDetailArray.remove(at:buttonTag)
        // If the array is empty after deletion, add a placeholder VisitorDetails object
        if visitorsDetailArray.isEmpty {
            let emptyVisitor = VisitorDetails(visitorName: "", visitorEmail: "", visitorPhone: "")
            visitorsDetailArray.append(emptyVisitor)
        }
        tableView.reloadData()
    }
}
extension ScheduleVisitorsViewController:sendVisitorEmailDelegate{
    func sendVisitorEmail(email: String) {
        let obj = VisitorDetails(visitorName: "", visitorEmail: email, visitorPhone: "")
        
        // Remove the empty visitor detail if it exists
        if visitorsDetailArray.count == 1, let firstVisitor = visitorsDetailArray.first, firstVisitor.visitorEmail == "" {
            visitorsDetailArray.removeFirst()
        }
        
        // Append the new visitor detail
        visitorsDetailArray.append(obj)
        self.apiRequestScheduleVisitorsRequest.visitorDetails = visitorsDetailArray
        self.displayscheduleVisitorsDetailsNextScreen.visitors = visitorsDetailArray
        tableView.reloadData()
        
    }
}

// MARK: - Enums

extension ScheduleVisitorsViewController {
    enum Event {
        
        case dataLoaded
        case error(Error?)
    }
}

// MARK: - UITableView Extension

extension UITableView {
    func registerCellsScheduleVisitors() {
        let cellIdentifiers: [CellIdentifierScheduleVisitors] = [.selectDate, .selectTime, .reasonForVisit,.invitedVisitors, .btnCancelAndSave]
        cellIdentifiers.forEach { reuseIdentifier in
            register(UINib(nibName: reuseIdentifier.rawValue, bundle: nil), forCellReuseIdentifier: reuseIdentifier.rawValue)
        }
    }
}

