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
    var visitorsDetailArray : [MyVisitorDetail] = []
    
    var ddOptions: [Reason] = []
    var eventHandler: ((_ event: Event) -> Void)?
    var apiRequestScheduleVisitorsRequest = ScheduleVisitorsRequest()
    var apiEditScheduleVisitorsRequest = UpdateVisitorsRequestModel()
   
    var displayscheduleVisitorsEditDetailsNextScreen = DisplayScheduleVisitorsEditDetailModel()
    var displayscheduleVisitorsDetailsNextScreen = DisplayScheduleVisitorsDetailModel()
    
    var isEditMode: Bool = false
    var visitorId:Int?
    var email: String?
    var phone: String?
    var name: String?
    var reasonId:Int = 1
    var reasonForVisit = ""
    var arrivalDate = ""
    var start_time = ""
    var end_time = ""
    var myvisitordetailsArray: [MyVisitorDetail] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //let emptyVisitor = VisitorDetails(visitorName: "", visitorEmail: "", visitorPhone: "")
        let emptyVisitor = MyVisitorDetail(visitor_name: "", visitor_email: "", visitor_phone: "")
        visitorsDetailArray.append(emptyVisitor)
        setupTableView()
        fetchreasonForVisit()
        if isEditMode {
            setInitialVisitorDetails()
        }
        self.arrivalDate = Date.formatSelectedDate(format: .yyyyMMdd, date: Date())
    }
    func setInitialVisitorDetails() {
        let indexPath = IndexPath(row: 1, section: SectionTypeScheduleVisitors.invitedVisitors.rawValue)
        tableView.reloadRows(at: [indexPath], with: .none)
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if isEditMode {
            //setInitialVisitorDetails()
            
            displayscheduleVisitorsDetailsNextScreen.reasonForVisit = reasonForVisit
            displayscheduleVisitorsEditDetailsNextScreen.reasonForVisit = reasonForVisit
          
            // 7 oct 2024 bharati added these lines
            
            // Ensure that start_time and end_time are assigned correctly
                  displayscheduleVisitorsEditDetailsNextScreen.startTime = start_time
                  displayscheduleVisitorsEditDetailsNextScreen.endTime = end_time

            apiRequestScheduleVisitorsRequest.reason_of_visit = reasonId
            
            //displayscheduleVisitorsDetailsNextScreen.visitors = myvisitordetailsArray
            displayscheduleVisitorsEditDetailsNextScreen.visitors = myvisitordetailsArray
            apiRequestScheduleVisitorsRequest.vistor_details = myvisitordetailsArray
        }
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
           // if isEditMode{
                cell.calender.date = Date.dateFromString(arrivalDate, format: .yyyyMMdd) ?? Date()
            //}
            cell.initWithDefaultDate()
            cell.selectionStyle = .none
            return cell
            
        case .selectTime:
            let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifierScheduleVisitors.selectTime.rawValue, for: indexPath) as! SelectTimeTableViewCell
            cell.selectionStyle = .none
            cell.delegate = self
            let givenDate = Date.dateFromString(arrivalDate, format: .yyyyMMdd) ?? Date()
                if isEditMode, DateTimeManager.shared.isSelectedDateSametoDate(givenDate: givenDate) {
                    cell.selectStartTime.date = Date.dateFromString(start_time, format: .HHmmss) ?? Date()
                    cell.selectEndTime.date = Date.dateFromString(end_time, format: .HHmmss) ?? Date()
                } else {
                    cell.setupInitialTimeValues()
                }
                
            return cell
        case .reasonForVisit:
            let cell =  tableView.dequeueReusableCell(withIdentifier: CellIdentifierScheduleVisitors.reasonForVisit.rawValue, for: indexPath) as! ReasonForVisitTableViewCells
            
            cell.resetReasonTextFields()
            cell.delegate = self
        
           // if isEditMode {
                cell.txtSelectReason.text = self.reasonForVisit
           // }
               
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
                
                cell.isEditMode = self.isEditMode
                cell.delegate = self
                cell.resetTextFields()
                cell.selectionStyle = .none
                cell.btnAddVisitors.isHidden = false
                if isEditMode{
                    cell.txtName.text = self.name
                    cell.txtEmail.text = self.email
                    cell.txtPhone.text = self.phone
                    cell.btnAddVisitors.isHidden = true
                    cell.btnAdd.isHidden = true
                    cell.lblInviteMoreVisitors.isHidden = true
                }
                return cell
            }else {
                
                let cell =  tableView.dequeueReusableCell(withIdentifier: CellIdentifierScheduleVisitors.invitedVisitors.rawValue, for: indexPath)as! InviteVisitorsTableViewCell
                cell.delegate = self
                cell.selectionStyle = .none
                
                //Get visitor detail from visitorsDetailArray
                                let visitorDetail = visitorsDetailArray[indexPath.row - 1]
                                cell.lblVisitorEmail.text = visitorDetail.visitor_email
                                cell.visitorEmailView.isHidden = false
                                if indexPath.row == 0 && isEditMode{
                                    if visitorsDetailArray.first?.visitor_email == "" {
                                        cell.visitorEmailView.isHidden = true
                                        cell.visitorEmailView.isHidden = email?.isEmpty ?? true
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
                return isEditMode ? 220 : 278
            } else if visitorsDetailArray.first?.visitor_email == "" {
                return 0
            }else {
                return  53
            }
        case .btnCancelAndSave:
            return 55
        }
    }
}
// MARK: - SelectReasonTableViewCellDelegate
extension ScheduleVisitorsViewController: ReasonForVisitTableViewCellDelegate {
    func dropdownButtonTapped(selectedOption: Reason) {
        // Implement what you want to do with the selected option, for example:
        print("Selected option: \(selectedOption.reason),\(selectedOption.id)")
        apiRequestScheduleVisitorsRequest.reason_of_visit = selectedOption.id
        //for upate
        apiEditScheduleVisitorsRequest.reason_of_visit = selectedOption.id
        
        self.reasonId =  selectedOption.id
        self.reasonForVisit = selectedOption.reason
        //for add
        displayscheduleVisitorsDetailsNextScreen.reasonForVisit = selectedOption.reason
        //for update
        displayscheduleVisitorsEditDetailsNextScreen.reasonForVisit = selectedOption.reason
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
        apiRequestScheduleVisitorsRequest.arrival_date = apiDate
        // save formated date to show in next screen
        let displayDate = Date.formatSelectedDate(format: .EEEEddMMMMyyyy, date: actualFormatOfDate)
        displayscheduleVisitorsDetailsNextScreen.date = displayDate
        print("arrival date is",self.arrivalDate)
        self.arrivalDate = Date.formatSelectedDate(format: .yyyyMMdd, date: actualFormatOfDate)
        DispatchQueue.main.async {
            //  ********** fetchMeetingRooms() instead reload time cell
            self.tableView.reloadSections([SectionTypeScheduleVisitors.selectTime.rawValue], with: .none)
        }
        
    }
}
extension ScheduleVisitorsViewController: SelectTimeTableViewCellDelegate{
    func selectFulldayStatus(_ isFullDay: Bool) {
        
    }
    func didSelectStartTime(_ startTime: Date) {
        // for api request
        let apiStartTime = Date.formatSelectedDate(format: .HHmm, date: startTime)
        apiRequestScheduleVisitorsRequest.start_time = apiStartTime
        //for edit
        apiEditScheduleVisitorsRequest.start_time = apiStartTime
        //display in next vc
        self.start_time = Date.formatSelectedDate(format: .HHmmss, date: startTime)
        let displayStartTime = Date.formatSelectedDate(format: .hhmma, date: startTime)
        displayscheduleVisitorsDetailsNextScreen.startTime = displayStartTime
        displayscheduleVisitorsEditDetailsNextScreen.startTime = displayStartTime
    }
    
    func didSelectEndTime(_ endTime: Date) {
        // for api request
        let apiEndTime = Date.formatSelectedDate(format: .HHmm, date: endTime)
        apiRequestScheduleVisitorsRequest.end_time = apiEndTime
        //for edit
        apiEditScheduleVisitorsRequest.end_time = apiEndTime
        //display in next vc
        self.end_time = Date.formatSelectedDate(format: .HHmmss, date: endTime)
        let displayEndTime = Date.formatSelectedDate(format: .hhmma, date: endTime)
        displayscheduleVisitorsDetailsNextScreen.endTime = displayEndTime
        //for update
        displayscheduleVisitorsEditDetailsNextScreen.endTime = displayEndTime
        
    }
}

extension ScheduleVisitorsViewController:ButtonSaveDelegate{
    
    func btnSaveTappedAction() {
        // Check if visitor details are empty
        if !isEditMode {
            if visitorsDetailArray.isEmpty || (visitorsDetailArray.count == 1 && visitorsDetailArray.first?.visitor_email == "") {
                RSOToastView.shared.show("Please add visitor details before proceeding", duration: 2.0, position: .center)
                return
            }
        }
      
           // Update API request and display models with the filtered visitor details
           self.apiRequestScheduleVisitorsRequest.vistor_details = visitorsDetailArray
           self.displayscheduleVisitorsDetailsNextScreen.visitors = visitorsDetailArray
        
        print("Request Model: \(apiRequestScheduleVisitorsRequest)")
           print("Edit Model: \(apiEditScheduleVisitorsRequest)")
           print("Display Schedule: \(displayscheduleVisitorsDetailsNextScreen)")
           print("Display Edit Schedule: \(displayscheduleVisitorsEditDetailsNextScreen)")
        let visitorsDetailsVC = UIViewController.createController(storyBoard: .VisitorManagement, ofType: ScheduledVisitorDetatailsViewController.self)
        visitorsDetailsVC.scheduledVisitorDetailsDelegate = self
        //for api
        visitorsDetailsVC.requestModel = self.apiRequestScheduleVisitorsRequest

        //for update api
        visitorsDetailsVC.updateVisitorRequestModel = self.apiEditScheduleVisitorsRequest
        //for display
        visitorsDetailsVC.displayscheduleVisitorsDetails = self.displayscheduleVisitorsDetailsNextScreen
        
        //for update api
        visitorsDetailsVC.displayEditedscheduleVisitorsDetails = self.displayscheduleVisitorsEditDetailsNextScreen
        //for diplsay edited data
    
        visitorsDetailsVC.isEditMode = self.isEditMode

        visitorsDetailsVC.modalTransitionStyle = .crossDissolve
        visitorsDetailsVC.modalPresentationStyle = .overFullScreen
        visitorsDetailsVC.view.backgroundColor = UIColor.clear

        if isEditMode {
            let indexPath = IndexPath(row: visitorsDetailArray.count + 1, section: SectionTypeScheduleVisitors.invitedVisitors.rawValue)
            
            if let cell = tableView.cellForRow(at: indexPath) as? VisitorsTableViewCell {
                
                self.email = cell.txtEmail.text ?? ""
                self.name  = cell.txtName.text ?? ""
                self.phone = cell.txtPhone.text ?? ""
                
                // Pass the values to the next view controller
                visitorsDetailsVC.visitorId = self.visitorId
                visitorsDetailsVC.email = self.email
                visitorsDetailsVC.phone = self.phone
                visitorsDetailsVC.name = self.name
                visitorsDetailsVC.arrivalDate = self.arrivalDate
                visitorsDetailsVC.start_time = self.start_time
                visitorsDetailsVC.end_time = self.end_time
                visitorsDetailsVC.reasonForVisit = self.reasonForVisit
                visitorsDetailsVC.reasonId = self.reasonId
                visitorsDetailsVC.myvistordetailsArray.removeAll()
                let obj = MyVisitorDetail(visitor_name: name, visitor_email: email, visitor_phone: phone)
                visitorsDetailsVC.myvistordetailsArray.append(obj)
            }
        }
        self.present(visitorsDetailsVC, animated: true)
    }
}

extension ScheduleVisitorsViewController:VisitorsTableViewCellDelegate{
    
    
    func addVisitors(email: String, name: String, phone: String) {
        
        // Check if email is valid
        if !RSOValidator.isValidEmail(email) {
            RSOToastView.shared.show("Invalid email", duration: 2.0, position: .center)
            return
        }
        if name.isEmpty {
            RSOToastView.shared.show("Please enter visitor name", duration: 2.0, position: .center)
            return
        }
        if !RSOValidator.validatePhoneNumber(phone) {
            RSOToastView.shared.show("Please enter a valid  phone number", duration: 2.0, position: .center)
            return
        }
        let obj = MyVisitorDetail(visitor_name: name, visitor_email: email, visitor_phone: phone)
        // Normal mode: Add new visitor
        if visitorsDetailArray.count == 1, let firstVisitor = visitorsDetailArray.first, firstVisitor.visitor_email == "" {
            visitorsDetailArray.removeFirst()
        }
        visitorsDetailArray.append(obj)
        
        self.apiRequestScheduleVisitorsRequest.vistor_details = visitorsDetailArray
        self.displayscheduleVisitorsDetailsNextScreen.visitors = visitorsDetailArray
        //tableView.reloadData()//before code
        // Reload only the invited visitors section (assuming it's section 3 in this case)
        // After modifying visitorsDetailArray, call the function to update the button state
            updateSaveButtonState()
            let invitedVisitorsSection = SectionTypeScheduleVisitors.invitedVisitors.rawValue
            tableView.reloadSections(IndexSet(integer: invitedVisitorsSection), with: .automatic)
        
    }
    
    func InviteMoreVisitors() {
        let inviteVisitorsVC = UIViewController.createController(storyBoard: .VisitorManagement, ofType: InviteVisitorsViewController.self)
        inviteVisitorsVC.modalPresentationStyle = .overFullScreen
        inviteVisitorsVC.modalTransitionStyle = .crossDissolve
        inviteVisitorsVC.view.backgroundColor = UIColor.clear
        inviteVisitorsVC.visitorEmailDelegate = self
        self.present(inviteVisitorsVC, animated: true)
    }

    func updateSaveButtonState() {
        let list = self.apiRequestScheduleVisitorsRequest.vistor_details ?? []
        // Access the btnCancelAndSave cell
        let indexPath = IndexPath(row: 0, section: SectionTypeScheduleVisitors.btnCancelAndSave.rawValue)
        
        if let cell = tableView.cellForRow(at: indexPath) as? ButtonCancelAndSaveTableViewCell {
            if list.isEmpty && !isEditMode {
                cell.btnSave.alpha = 0.5
                cell.btnSave.isUserInteractionEnabled = false
            } else {
                cell.btnSave.alpha = 1.0
                cell.btnSave.isUserInteractionEnabled = true
            }
        }
    }

}
extension ScheduleVisitorsViewController:InviteVisitorsTableViewCellDelegate{
    
    func btnDeleteVisitors(buttonTag: Int) {
        
//        visitorsDetailArray.remove(at:buttonTag)
//        // If the array is empty after deletion, add a placeholder VisitorDetails object
//        if visitorsDetailArray.isEmpty {
//            let emptyVisitor = MyVisitorDetail(visitor_name: "", visitor_email: "", visitor_phone: "")
//            visitorsDetailArray.append(emptyVisitor)
//        }
//        tableView.reloadData()
        
        visitorsDetailArray.remove(at: buttonTag)
           
           // If the array is empty after deletion, add a placeholder VisitorDetails object
           if visitorsDetailArray.isEmpty {
               let emptyVisitor = MyVisitorDetail(visitor_name: "", visitor_email: "", visitor_phone: "")
               visitorsDetailArray.append(emptyVisitor)
           }

           // Update the request model
           self.apiRequestScheduleVisitorsRequest.vistor_details = visitorsDetailArray
           self.displayscheduleVisitorsDetailsNextScreen.visitors = visitorsDetailArray
           
           tableView.reloadData()
    }
}
extension ScheduleVisitorsViewController:sendVisitorEmailDelegate{
    func sendVisitorEmail(email: String) {
        let obj = MyVisitorDetail(visitor_name: "", visitor_email: "", visitor_phone: "")
        
        // Remove the empty visitor detail if it exists
        if visitorsDetailArray.count == 1, let firstVisitor = visitorsDetailArray.first, firstVisitor.visitor_email == "" {
            visitorsDetailArray.removeFirst()
        }
        
        // Append the new visitor detail
        visitorsDetailArray.append(obj)
        self.apiRequestScheduleVisitorsRequest.vistor_details = visitorsDetailArray
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

extension ScheduleVisitorsViewController: ScheduledVisitorDetailsProtocol {
    func didUpdateSuccessfully() {
        DispatchQueue.main.async {
            self.visitorsDetailArray.removeAll()
            let emptyVisitor = MyVisitorDetail(visitor_name: "", visitor_email: "", visitor_phone: "")
            self.visitorsDetailArray.append(emptyVisitor)
            self.tableView.reloadData()
        }
    }
}
