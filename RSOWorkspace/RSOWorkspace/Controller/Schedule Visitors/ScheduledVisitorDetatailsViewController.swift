//
//  ScheduledVisitorDetatailsViewController.swift
//  RSOWorkspace
//
//  Created by Sumit Aquil on 05/04/24.
//

import UIKit
import Toast_Swift
class ScheduledVisitorDetatailsViewController: UIViewController {
    
    var displayscheduleVisitorsDetails : DisplayScheduleVisitorsDetailModel!
    var requestModel : ScheduleVisitorsRequest!
    var updateVisitorRequestModel : UpdateVisitorsRequestModel?
    var displayEditedscheduleVisitorsDetails : DisplayScheduleVisitorsEditDetailModel!
    
    var coordinator: RSOTabBarCordinator?
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var containerView: UIView!
    var cornerRadius: CGFloat = 10.0
    var eventHandler: ((_ event: Event) -> Void)?
    var isEditMode: Bool = false
    var visitorId:Int?
    var email: String?
    var phone: String?
    var name: String?
    var reasonId:Int?
    var reasonForVisit = ""
    var arrivalDate = ""
    var start_time = ""
    var end_time = ""
    var myvistordetailsArray: [MyVisitorDetail] = []
    
    private let cellIdentifiers: [CellType] = [.date, .time,  .labelVisitor, .visitors, .reasonForvisit, .buttonEdit, .confirmAndProceed]
    
    private let cellHeights: [CGFloat] = [70, 70, 25, 32, 70, 40, 40]
    
    var bookingConfirmDetails : ConfirmBookingRequestModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        customizeCell()
        containerView.setCornerRadiusForView()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if isEditMode {
            if displayEditedscheduleVisitorsDetails != nil {
                tableView.reloadData()
            }
        } else {
            if displayscheduleVisitorsDetails != nil {
                tableView.reloadData()
            }
        }
    }
    func scheduleVisitorsAPIDetails(requestModel: ScheduleVisitorsRequest) {
        
        APIManager.shared.request(
            modelType: ScheduleVisitorResponse.self,
            type: VisitorsEndPoint.scheduleVisitors(requestModel: requestModel)) { [weak self] response in
                
                guard let self = self else { return }
                switch response {
                case .success(let responseData):
                    let response = responseData
                    if response.status == true{
                        DispatchQueue.main.async {
                            RSOToastView.shared.show("\(response.message)", duration: 2.0, position: .center)
                            // Wait for 2 seconds (or the duration of the toast) before dismissing the view
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                                self.dismiss(animated: true) {
                                    // Optionally reload the table view after dismissing
                                    self.tableView.reloadData()
                                }
                            }
                        }
                    }
                    self.eventHandler?(.dataLoaded)
                case .failure(let error):
                    self.eventHandler?(.error(error))
                    DispatchQueue.main.async {
                        RSOToastView.shared.show("\(error.localizedDescription)", duration: 2.0, position: .center)
                    }
                }
            }
    }
    func updateVisitorsAPI(requestModel: UpdateVisitorsRequestModel) {
        APIManager.shared.request(
            modelType: UpdateVisitorsDetailsResponse.self,
            type: VisitorsEndPoint.updateVisitors(requestModel: requestModel)) { [weak self] response in
                
                guard let self = self else { return }
                switch response {
                case .success(let responseData):
                    DispatchQueue.main.async {
                        if responseData.status {
                            // Status is true, display success message
                            let message = responseData.message ?? "Update successful"
                            RSOToastView.shared.show(message, duration: 2.0, position: .center)
                            
                            // Wait for 2 seconds before dismissing and reloading
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                                self.dismiss(animated: true) {
                                    // Reload the table view if needed
                                    self.tableView.reloadData()
                                }
                            }
                        } else {
                            // Status is false, display error message
                            let errorMessage = responseData.error ?? "Request failed"
                            RSOToastView.shared.show("Request failed: \(errorMessage)", duration: 2.0, position: .center)
                        }
                    }
                    self.eventHandler?(.dataLoaded)
                case .failure(let error):
                    self.eventHandler?(.error(error))
                    DispatchQueue.main.async {
                        RSOToastView.shared.show("\(error.localizedDescription)", duration: 2.0, position: .center)
                    }
                }
            }
    }
    
    private func customizeCell(){
        containerView.layer.cornerRadius = cornerRadius
        containerView.layer.masksToBounds = true
        
        let shadowColor = UIColor.black.withAlphaComponent(0.5)
        containerView.layer.shadowColor = shadowColor.cgColor
        containerView.layer.shadowOffset = CGSize(width: 0, height: 4.0)
        containerView.layer.shadowRadius = 10.0
        containerView.layer.shadowOpacity = 0.19
        containerView.layer.masksToBounds = false
        containerView.layer.shadowPath = UIBezierPath(roundedRect:  CGRect(x: 0, y: containerView.bounds.height - 4, width: containerView.bounds.width, height: 4), cornerRadius: containerView.layer.cornerRadius).cgPath
    }
    
    @IBAction func btnHideViewTappedAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    private func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        
        navigationController?.navigationBar.isHidden = true
        
        for type in cellIdentifiers {
            tableView.register(UINib(nibName: type.rawValue, bundle: nil), forCellReuseIdentifier: type.rawValue)
            
        }
        
    }
}

extension ScheduledVisitorDetatailsViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return cellIdentifiers.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let cellType = cellIdentifiers[section]
        if cellType == .visitors {
               if isEditMode { 
                   return displayEditedscheduleVisitorsDetails.visitors.count
               } else {
                   return displayscheduleVisitorsDetails.visitors.count
               }
           }
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 30
        }
        return 0
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = SectionHeaderView(reuseIdentifier: "SectionHeaderView")
        if section == 0 {
            headerView.sectionLabel.text = "Visitors"
            headerView.sectionLabel.font = RSOFont.poppins(size: 20.0, type: .SemiBold)
        }else {
            return nil
        }
        return headerView
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellType = cellIdentifiers[indexPath.section]
        
        switch cellType {
        case .date:
            let cell = tableView.dequeueReusableCell(withIdentifier: cellType.rawValue, for: indexPath) as! VisitorsDateTableViewCell
            cell.txtDate.text = isEditMode ? displayEditedscheduleVisitorsDetails?.date : displayscheduleVisitorsDetails?.date
            
            cell.selectionStyle = .none
            return cell
        case .time:
            let cell = tableView.dequeueReusableCell(withIdentifier: cellType.rawValue, for: indexPath) as! VisitorsTimeTableViewCell
            cell.selectionStyle = .none
            let timeRange = isEditMode ?
            "\(displayEditedscheduleVisitorsDetails?.startTime ?? "") - \(displayEditedscheduleVisitorsDetails?.endTime ?? "")" :
            "\(displayscheduleVisitorsDetails?.startTime ?? "") - \(displayscheduleVisitorsDetails?.endTime ?? "")"
            cell.txtTime.text = timeRange.isEmpty ? "Unavailable" : timeRange
            
            return cell
            
        case .reasonForvisit:
            let cell = tableView.dequeueReusableCell(withIdentifier: cellType.rawValue, for: indexPath) as! ReasonForVisitTableViewCell
            cell.txtReasonForVisit.text = isEditMode ? displayEditedscheduleVisitorsDetails?.reasonForVisit : displayscheduleVisitorsDetails?.reasonForVisit
            
            cell.selectionStyle = .none
            
            return cell
            
        case .labelVisitor:
            let cell = tableView.dequeueReusableCell(withIdentifier: cellType.rawValue, for: indexPath) as! SelectMeetingRoomLabelTableViewCell
            cell.lblMeetingRoom.text = "Visitors"
            cell.lblMeetingRoom.font = UIFont(name: "Poppins-SemiBold", size: 14)
            cell.selectionStyle = .none
            
            return cell
        case .visitors:
            let cell = tableView.dequeueReusableCell(withIdentifier: cellType.rawValue, for: indexPath) as! VisitorsListableViewCell
            let visitorEmail: String?
                
                if isEditMode {
                    visitorEmail = displayEditedscheduleVisitorsDetails?.visitors[indexPath.row].visitor_email
                } else {
                    visitorEmail = displayscheduleVisitorsDetails?.visitors[indexPath.row].visitor_email
                }
                
                cell.lblEmail.text = visitorEmail
            cell.selectionStyle = .none
            
            return cell
        case .buttonEdit:
            let cell = tableView.dequeueReusableCell(withIdentifier: cellType.rawValue, for: indexPath) as! EditButtonTableViewCell
            cell.delegate = self
            cell.selectionStyle = .none
            
            return cell
            
        case .confirmAndProceed:
            let cell = tableView.dequeueReusableCell(withIdentifier: cellType.rawValue, for: indexPath) as! ConfirmAndProceedTableViewCell
            cell.delegate = self
            cell.selectionStyle = .none
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeights[indexPath.section]
    }
}

extension ScheduledVisitorDetatailsViewController {
    enum Event {
        
        case dataLoaded
        case error(Error?)
    }
    
    enum CellType: String {
        case date = "VisitorsDateTableViewCell"
        case time = "VisitorsTimeTableViewCell"
        case labelVisitor = "SelectMeetingRoomLabelTableViewCell"
        case visitors = "VisitorsListableViewCell"
        case reasonForvisit = "ReasonForVisitTableViewCell"
        case buttonEdit = "EditButtonTableViewCell"
        case confirmAndProceed = "ConfirmAndProceedTableViewCell"
    }
}
extension ScheduledVisitorDetatailsViewController:EditButtonTableViewCellDelegate{
    func navigateScheduleVisitors() {
        self.dismiss(animated:true)
    }
}

extension ScheduledVisitorDetatailsViewController:ConfirmAndProceedTableViewCellDelegate{
    func navigateToMyvisitors() {
        
        let updateVisitorRequestModel = UpdateVisitorsRequestModel(visitor_management_id: visitorId, reason_of_visit:reasonId , arrival_date: arrivalDate, start_time: start_time, end_time: end_time, vistor_detail: myvistordetailsArray)
        if isEditMode {
            updateVisitorsAPI(requestModel: updateVisitorRequestModel)
        } else {
            scheduleVisitorsAPIDetails(requestModel: requestModel)
        }
    }
}
extension ScheduledVisitorDetatailsViewController:ConfirmAndProceedToPayementTableViewCellDelegate{
    func btnConfirmAndProceedTappedAction() {
        let paymentVC = UIViewController.createController(storyBoard: .Payment, ofType: PaymentViewController.self)
        paymentVC.requestParameters = bookingConfirmDetails
        paymentVC.coordinator = self.coordinator
        
        self.navigationController?.pushViewController(paymentVC, animated: true)
    }
    
}
