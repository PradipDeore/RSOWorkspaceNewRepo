//
//  ConfirmedDeskBookingViewController.swift
//  RSOWorkspace
//
//  Created by Sumit Aquil on 18/04/24.
//

import UIKit

class ConfirmedDeskBookingViewController: UIViewController{
  
  var coordinator: RSOTabBarCordinator?
  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var containerView: UIView!
  var cornerRadius: CGFloat = 10.0
  
  var eventHandler: ((_ event: Event) -> Void)?
  var apiResponseData:StoreDeskBookingResponseModel?
  var deskList:[RSOCollectionItem] = []
  
  private let cellIdentifiersConfirmDesk: [CellTypeConfirmDesk] = [ .confirmedLocation, .confirmedSelectedDesks, .confirmedTime, .confirmedDate,  .confirmedTeamMembers,  .confirmAndProceedToPayment, .buttonEdit]
  
  private let cellHeights: [CGFloat] = [ 70, 70, 70, 70, 60, 40, 40]
  
  // var bookingConfirmDetails : ConfirmBookingRequestModel?
  var confirmdeskBookingResponse: ConfirmDeskBookingDetailsModel?
  var bookingConfirmDetails = ConfirmBookingRequestModel()
 var deskbookingConfirmDetails:StoreDeskBookingRequest?
    
  var roomId: Int = 0
  var teamMembersArray:[String] = [""]
  var locationName :String = ""
  var timeRange = ""
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
    
    for type in cellIdentifiersConfirmDesk {
      tableView.register(UINib(nibName: type.rawValue, bundle: nil), forCellReuseIdentifier: type.rawValue)
    }
  }
    
    func storeDeskBookingAPI(requestModel: StoreDeskBookingRequest) {
      
      DispatchQueue.main.async {
        RSOLoader.showLoader()
      }
          APIManager.shared.request(
              modelType: StoreDeskBookingResponseModel.self,
              type: DeskBookingEndPoint.storeDeskBooking(requestModel: requestModel)) { response in
                DispatchQueue.main.async {
                  RSOLoader.removeLoader()
                }
                  switch response {
                  case .success(let response):
                      self.apiResponseData = response
                     
                      print("===Store desk booking api response\(response)")
                      DispatchQueue.main.async {
                          let paymentVC = UIViewController.createController(storyBoard: .Payment, ofType: PaymentViewController.self)
                          //paymentVC.requestParameters = self.bookingConfirmDetails
                          paymentVC.coordinator = self.coordinator
                          //paymentVC.bookingId = response.booking_id ?? 0
                          //self.navigationController?.pushViewController(paymentVC, animated: true)
                          self.present(paymentVC, animated: true)
                          
                      }
                      self.eventHandler?(.dataLoaded)
                  case .failure(let error):
                      self.eventHandler?(.error(error))
                      DispatchQueue.main.async {
                          //  Unsuccessful
                          RSOToastView.shared.show("\(error.localizedDescription)", duration: 2.0, position: .center)
                      }
                  }
              }
      }
}

extension ConfirmedDeskBookingViewController: UITableViewDataSource, UITableViewDelegate {
  
  func numberOfSections(in tableView: UITableView) -> Int {
    return cellIdentifiersConfirmDesk.count
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if section == 4{
      return  confirmdeskBookingResponse?.teamMembersArray.count ?? 0
    }
    return 1
  }
  
  
  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    let headerView = SectionHeaderView(reuseIdentifier: "SectionHeaderView")
    if section == 0 {
      headerView.sectionLabel.text = "Confirm Booking"
      headerView.sectionLabel.font = RSOFont.poppins(size: 20.0, type: .SemiBold)
    } else if section == 4 {
      headerView.sectionLabel.text = "Team Members"
      headerView.labelHeight = 15 // Set a different height for this section
    }  else {
      return nil
    }
    return headerView
  }
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cellType = cellIdentifiersConfirmDesk[indexPath.section]
    
    switch cellType {
      
    case .confirmedLocation:
      let cell = tableView.dequeueReusableCell(withIdentifier: cellType.rawValue, for: indexPath) as! BookingConfirmedLocationTableViewCell
      cell.txtLocation.text = confirmdeskBookingResponse?.location
      cell.selectionStyle = .none
      return cell
      
    case .confirmedSelectedDesks:
      let cell = tableView.dequeueReusableCell(withIdentifier: cellType.rawValue, for: indexPath) as! SelectDesksTableViewCell
      cell.deskList = deskList
      cell.collectionView.reloadData()
      cell.collectionView.isUserInteractionEnabled = false
      cell.selectionStyle = .none
      return cell
      
    case .confirmedDate:
      let cell = tableView.dequeueReusableCell(withIdentifier: cellType.rawValue, for: indexPath) as! BookingConfirmedDateTableViewCell
      cell.lblDate.text = confirmdeskBookingResponse?.date
      cell.selectionStyle = .none
      
      return cell
      
    case .confirmedTime:
      let cell = tableView.dequeueReusableCell(withIdentifier: cellType.rawValue, for: indexPath) as! BookingConfirmedTimeTableViewCell
      
      if let startTime = self.confirmdeskBookingResponse?.startTime, let endTime = self.confirmdeskBookingResponse?.endTime {
        timeRange = "\(startTime) - \(endTime)"
        cell.txtTime.text = timeRange
        
      } else {
        cell.txtTime.text = "Unavailable"
      }
      cell.selectionStyle = .none
      
      return cell
      
    case .confirmedTeamMembers:
      let cell = tableView.dequeueReusableCell(withIdentifier: cellType.rawValue, for: indexPath) as! BookingConfirmedTeamMembersTableViewCell
      
      cell.selectionStyle = .none
      if let teamMember = confirmdeskBookingResponse?.teamMembersArray[indexPath.row]{
        cell.lblName.text = teamMember
        teamMembersArray.append(teamMember)
      }
      cell.selectionStyle = .none
      
      return cell
      
    case .confirmAndProceedToPayment:
      let cell = tableView.dequeueReusableCell(withIdentifier: cellType.rawValue, for: indexPath) as! ConfirmAndProceedToPayementTableViewCell
      cell.delegate = self
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

extension ConfirmedDeskBookingViewController {
  enum Event {
    case dataLoaded
    case error(Error?)
  }
  
  enum CellTypeConfirmDesk: String {
    //case selectMeetingRoom = "SelectMeetingRoomLabelTableViewCell"
    case confirmedLocation = "BookingConfirmedLocationTableViewCell"
    case confirmedSelectedDesks = "SelectDesksTableViewCell"
    case confirmedTime = "BookingConfirmedTimeTableViewCell"
    case confirmedDate = "BookingConfirmedDateTableViewCell"
    case confirmedTeamMembers = "BookingConfirmedTeamMembersTableViewCell"
    case confirmAndProceedToPayment = "ConfirmAndProceedToPayementTableViewCell"
    case buttonEdit = "ButtonEditTableViewCell"
  }
}
extension ConfirmedDeskBookingViewController:ButtonEditTableViewCellDelegate{
  func navigateToBookingDetails() {
    self.dismiss(animated:true)
    
  }
}
extension ConfirmedDeskBookingViewController:ConfirmAndProceedToPayementTableViewCellDelegate{
    func btnConfirmAndProceedTappedAction() {
        let apidefaultTime = Date.formatSelectedDate(format: .HHmm, date: Date())
        
        let startTime = self.deskbookingConfirmDetails?.start_time ?? apidefaultTime
        let endTime = self.deskbookingConfirmDetails?.end_time ?? apidefaultTime
        let date = self.deskbookingConfirmDetails?.date ?? ""
        let desktype = self.deskbookingConfirmDetails?.desktype ?? 0
        let deskID = self.deskbookingConfirmDetails?.desk_id ?? []
        let teamMembers = self.deskbookingConfirmDetails?.teammembers ?? []
           
           let requestModel = StoreDeskBookingRequest(
               start_time: startTime,
               end_time: endTime,
               date: date,
               is_fullday: "No",
               desktype: desktype,
               desk_id: deskID,
               teammembers: teamMembers
           )
           
           print("Parameters: \(requestModel)")
           storeDeskBookingAPI(requestModel: requestModel)

    }

}
