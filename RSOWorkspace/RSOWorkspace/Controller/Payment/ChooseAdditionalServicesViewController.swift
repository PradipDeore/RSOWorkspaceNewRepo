//
//  ChooseAdditionalServicesViewController.swift
//  RSOWorkspace
//
//  Created by Sumit Aquil on 07/03/24.
//

import UIKit
import Toast_Swift

class ChooseAdditionalServicesViewController: UIViewController {
    var bookingId: Int = 0
    var selectedServices: [String] = []
    var coordinator: RSOTabBarCordinator?
    var apiResponseData:PaymentRoomBookingResponse?
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var containerView: UIView!
    
    var totalPrice:Double = 0.0
    var vatAmount:Double = 0.0
    var provideRequirementDet = ""
    var additionalServicesArray:[String] = []
    
    var eventHandler: ((_ event: Event) -> Void)?
    
    private let cellIdentifiers: [(CellType,CGFloat)] = [(.chooseAdditionalServicesLabel,20.0),(.chooseAdditionaServices,60),(.provideRequirementDet,70),(.cancelAndRequestButton,45)]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        containerView.setCornerRadiusForView()
        setValuesForAdditionalServices()
        containerView.setCornerRadiusForView()
        
    }
    func setValuesForAdditionalServices(){
        self.additionalServicesArray = ["Flipchart","Refreshments","Water Bottles","Stationary"]
    }
   
    private func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        
        navigationController?.navigationBar.isHidden = true
        
        for cellIdentifier in cellIdentifiers {
            let type = cellIdentifier.0
            tableView.register(UINib(nibName: type.rawValue, bundle: nil), forCellReuseIdentifier: type.rawValue)
        }
    }
    @IBAction func btnHideViewTappedAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    func paymentRoomBookingAPI(additionalrequirements :[String], bookingid:Int, requirementdetails:String,totalprice:Double,vatamount:Double) {
        self.eventHandler?(.loading)
        let requestModel = PaymentRoomBookingRequest(additional_requirements: additionalrequirements, booking_id: bookingid, requirement_details: requirementdetails, total_price: totalprice, vatamount: vatamount)
        print("requestModel",requestModel)
        APIManager.shared.request(
            modelType: PaymentRoomBookingResponse.self,
            type: PaymentRoomBookingEndPoint.getBookingOfRooms(requestModel: requestModel)) { response in
                self.eventHandler?(.stopLoading)
                switch response {
                case .success(let response):
                    
                    self.apiResponseData = response
                    //Booking Saved successfully
                    DispatchQueue.main.async {
                        RSOToastView.shared.show("\(response.message)", duration: 2.0, position: .center)
                    }
                    
                    // Pause execution for 5 seconds using DispatchQueue
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                        self.navigationController?.popToRootViewController(animated: true)
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
extension ChooseAdditionalServicesViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return cellIdentifiers.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 1{
            return additionalServicesArray.count
        }
        return 1
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 1{
            return 10
        }
        return 10
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 1 {
            return UIView()
        }
        return UIView()
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellType = cellIdentifiers[indexPath.section].0
        switch cellType{
        case .chooseAdditionalServicesLabel:
            let labelCell = tableView.dequeueReusableCell(withIdentifier: cellType.rawValue, for: indexPath) as!  SelectMeetingRoomLabelTableViewCell
               labelCell.lblMeetingRoom.text = "Choose Additional Services"
               labelCell.lblMeetingRoom.font = UIFont(name: "Poppins-SemiBold", size: 20.0)
               return labelCell
            
        case .chooseAdditionaServices:
            let cell = tableView.dequeueReusableCell(withIdentifier: cellType.rawValue, for: indexPath) as! ChooseAdditionalServicesTableViewCell
            
            let services = additionalServicesArray[indexPath.row]
            cell.lblServices.text = services
            cell.selectionStyle = .none
            cell.delegate = self
            cell.service = services
            return cell
         
        case . provideRequirementDet:
            let cell = tableView.dequeueReusableCell(withIdentifier: cellType.rawValue, for: indexPath) as! ProvideRequirementDetailsTableViewCell
            return cell
        case .cancelAndRequestButton:
            let cell = tableView.dequeueReusableCell(withIdentifier: cellType.rawValue, for: indexPath) as! CancelAndRequestButtonTableViewCell
            cell.delegate = self
            return cell
        default:
            return UITableViewCell()
            
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: cellType.rawValue, for: indexPath)
        cell.selectionStyle = .none
        return cell
      
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellIdentifiers[indexPath.section].1
    }
}

extension ChooseAdditionalServicesViewController {
    enum Event {
        case loading
        case stopLoading
        case dataLoaded
        case error(Error?)
    }
    
    enum CellType: String {
        case chooseAdditionalServicesLabel = "SelectMeetingRoomLabelTableViewCell"
        case chooseAdditionaServices = "ChooseAdditionalServicesTableViewCell"
        case provideRequirementDet = "ProvideRequirementDetailsTableViewCell"
        case cancelAndRequestButton = "CancelAndRequestButtonTableViewCell"
    }
    
}
extension ChooseAdditionalServicesViewController:ChooseAdditionalServicesCellDelegate{
    func didSelect(service: String) {
        selectedServices.append(service)
        print("selected services array when added ",selectedServices)
    }
    
    func didDeselect(service: String) {
        if let index = selectedServices.firstIndex(of: service) {
            selectedServices.remove(at: index)
            print("selected services array when removed",selectedServices)
            
        }
    }
    
}
extension ChooseAdditionalServicesViewController:CancelAndRequestButtonTableViewCellDelegate{
    
    func btnRequestTappedAction() {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProvideRequirementDetailsTableViewCell", for: IndexPath(row: 0, section: 2)) as! ProvideRequirementDetailsTableViewCell
        let details = cell.txtViewrequirnmentDetails.text
        //print("details=", details)
        self.paymentRoomBookingAPI(additionalrequirements: ["Stationary"], bookingid: self.bookingId, requirementdetails: details ?? "", totalprice: 315.0, vatamount: 15.0)
      
    }
    
    func btnCancelTappedAction() {
        UIViewController.createController(storyBoard: .Payment, ofType: ChooseAdditionalServicesViewController.self)
        self.dismiss(animated: true)
    }
    
}
