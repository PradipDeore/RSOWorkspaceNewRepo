//
//  ConfirmShortTermBookingViewController.swift
//  RSOWorkspace
//
//  Created by Sumit Aquil on 27/07/24.
//

import UIKit

class ConfirmShortTermBookingViewController: UIViewController {
    
    var coordinator: RSOTabBarCordinator?
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var containerView: UIView!
    var cornerRadius: CGFloat = 10.0
    
    var eventHandler: ((_ event: Event) -> Void)?
    var apiResponseData:StoreofficeBookingResponse?
    var officeList:[RSOCollectionItem] = []
    
    private let cellIdentifiersConfirmOffice: [CellTypeConfirmOffice] = [ .confirmedLocation, .confirmedSelectedOffice, .confirmedTime, .confirmedDate,  .confirmedNoOFSeats,  .confirmAndProceedToPayment, .buttonEdit]
    
    private let cellHeights: [CGFloat] = [ 70, 85, 70, 70, 60, 40, 40]
    
    var confirmOfficeBookingResponse: ConfirmOfficeBookingDetailsModel?
    var bookingConfirmDetails = ConfirmBookingRequestModel()
    var officebookingConfirmDetails:StoreOfficeBookingRequest?
    
    var roomId: Int = 0
    var locationName :String = ""
    var timeRange = ""
    var officeName = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        customizeCell()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tableView.reloadData()
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
        
        for type in cellIdentifiersConfirmOffice {
            tableView.register(UINib(nibName: type.rawValue, bundle: nil), forCellReuseIdentifier: type.rawValue)
        }
    }
    
    func storeOfficeBookingAPI(requestModel: StoreOfficeBookingRequest) {
        DispatchQueue.main.async {
            RSOLoader.showLoader()
        }
        APIManager.shared.request(
            modelType: StoreofficeBookingResponse.self,
            type: ShortTermOfficeBookingEndPoint.storeOfficeBooking(requestModel: requestModel)) { response in
                DispatchQueue.main.async {
                    RSOLoader.removeLoader()
                    switch response {
                    case .success(let response):
                        self.apiResponseData = response
                        if let errorMessage = response.msg, errorMessage.isEmpty == false {
                            self.eventHandler?(.error(errorMessage as? Error))
                            //  Unsuccessful
                            self.navigationController?.popViewController(animated: true)
                            RSOToastView.shared.show("\(errorMessage)", duration: 2.0, position: .center)
                            
                        } else {
                            // Start time
                            self.bookingConfirmDetails.setValues(response: response)
                            let paymentVC = UIViewController.createController(storyBoard: .Payment, ofType: PaymentViewController.self)
                            paymentVC.requestParameters = self.bookingConfirmDetails
                            paymentVC.coordinator = self.coordinator
                            paymentVC.officeName = self.officeName
                            paymentVC.bookingType = .office
                            paymentVC.bookingId = response.data?.officeID ?? 0
                            self.navigationController?.pushViewController(paymentVC, animated: true)
                        }
                        
                        self.eventHandler?(.dataLoaded)
                    case .failure(let error):
                        self.eventHandler?(.error(error))
                        //  Unsuccessful
                        RSOToastView.shared.show("\(error.localizedDescription)", duration: 2.0, position: .center)
                    }
                }
            }
    }
}

extension ConfirmShortTermBookingViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return cellIdentifiersConfirmOffice.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
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
            headerView.sectionLabel.text = "Confirm Booking"
            headerView.sectionLabel.font = RSOFont.poppins(size: 20.0, type: .SemiBold)
        }else {
            return nil
        }
        return headerView
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellType = cellIdentifiersConfirmOffice[indexPath.section]
        
        switch cellType {
            
        case .confirmedLocation:
            let cell = tableView.dequeueReusableCell(withIdentifier: cellType.rawValue, for: indexPath) as! BookingConfirmedLocationTableViewCell
            cell.txtLocation.text = confirmOfficeBookingResponse?.location
            cell.selectionStyle = .none
            return cell
            
        case .confirmedSelectedOffice:
            let cell = tableView.dequeueReusableCell(withIdentifier: cellType.rawValue, for: indexPath) as! BookingConfirmedMeetingRoomTableViewCell
            cell.lblTitle.text = "Selected Office Type"
            cell.lblRoomName.text = confirmOfficeBookingResponse?.officeName
            cell.selectionStyle = .none
            return cell
            
        case .confirmedDate:
            let cell = tableView.dequeueReusableCell(withIdentifier: cellType.rawValue, for: indexPath) as! BookingConfirmedDateTableViewCell
            cell.lblDate.text = confirmOfficeBookingResponse?.date
            cell.selectionStyle = .none
            
            return cell
            
        case .confirmedTime:
            let cell = tableView.dequeueReusableCell(withIdentifier: cellType.rawValue, for: indexPath) as! BookingConfirmedTimeTableViewCell
            
            if let startTime = self.confirmOfficeBookingResponse?.startTime, let endTime = self.confirmOfficeBookingResponse?.endTime {
                timeRange = "\(startTime) - \(endTime)"
                cell.txtTime.text = timeRange
                
            } else {
                cell.txtTime.text = "Unavailable"
            }
            cell.selectionStyle = .none
            
            return cell
            
        case .confirmedNoOFSeats:
            let cell = tableView.dequeueReusableCell(withIdentifier: cellType.rawValue, for: indexPath) as! NoOfSeatsTableViewCell
            if let noOfSeats = confirmOfficeBookingResponse?.nofOfSeats {
                print("Number of seats: \(noOfSeats)")
                cell.configure(with: noOfSeats)
            }
            cell.selectionStyle = .none
            return cell
            
        case .confirmAndProceedToPayment:
            let cell = tableView.dequeueReusableCell(withIdentifier: cellType.rawValue, for: indexPath) as! ConfirmAndProceedToPayementTableViewCell
            cell.delegate = self
            if !UserHelper.shared.isGuest(){
                cell.btnConfirmAndProceed.setTitle("Confirm", for: .normal)
            }
            cell.selectionStyle = .none
            return cell
            
        case .buttonEdit:
            let cell = tableView.dequeueReusableCell(withIdentifier: cellType.rawValue, for: indexPath) as! ButtonEditTableViewCell
            cell.delegate = self
            cell.selectionStyle = .none
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeights[indexPath.section]
    }
}

extension ConfirmShortTermBookingViewController {
    enum Event {
        case dataLoaded
        case error(Error?)
    }
    
    enum CellTypeConfirmOffice: String {
        //case selectMeetingRoom = "SelectMeetingRoomLabelTableViewCell"
        case confirmedLocation = "BookingConfirmedLocationTableViewCell"
        case confirmedSelectedOffice = "BookingConfirmedMeetingRoomTableViewCell"
        case confirmedTime = "BookingConfirmedTimeTableViewCell"
        case confirmedDate = "BookingConfirmedDateTableViewCell"
        case confirmedNoOFSeats = "NoOfSeatsTableViewCell"
        case confirmAndProceedToPayment = "ConfirmAndProceedToPayementTableViewCell"
        case buttonEdit = "ButtonEditTableViewCell"
    }
}
extension ConfirmShortTermBookingViewController:ButtonEditTableViewCellDelegate{
    func navigateToBookingDetails() {
        self.navigationController?.popViewController(animated: true)
    }
}
extension ConfirmShortTermBookingViewController:ConfirmAndProceedToPayementTableViewCellDelegate{
    func btnConfirmAndProceedTappedAction() {
        let apidefaultTime = Date.formatSelectedDate(format: .HHmm, date: Date())
        
        let startTime = self.officebookingConfirmDetails?.start_time ?? apidefaultTime
        let endTime = self.officebookingConfirmDetails?.end_time ?? apidefaultTime
        let date = self.officebookingConfirmDetails?.date ?? ""
        let isFullDay = self.officebookingConfirmDetails?.is_fullday ?? "No"
        let officeID = self.officebookingConfirmDetails?.office_id
        guard let noOfSeats = self.officebookingConfirmDetails?.seats else { return  }
        
        let requestModel = StoreOfficeBookingRequest(
            start_time: startTime,
            end_time: endTime,
            date: date,
            is_fullday: isFullDay,
            office_id: 24,
            seats: noOfSeats
        )
        
        print("Parameters: \(requestModel)")
        storeOfficeBookingAPI(requestModel: requestModel)
        
    }
    
}
