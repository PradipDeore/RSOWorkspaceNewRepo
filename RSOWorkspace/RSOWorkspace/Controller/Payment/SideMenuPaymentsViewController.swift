//  SideMenuPaymentsViewController.swift
//  RSOWorkspace
//
//  Created by Sumit Aquil on 18/07/24.
//

import UIKit

class SideMenuPaymentsViewController: UIViewController {
    
    @IBOutlet weak var txtMonths: UITextField!
    @IBOutlet weak var btnSelectMonth: UIButton!
    @IBOutlet weak var monthNamesView: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    let months = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]
    var eventHandler: ((_ event: Event) -> Void)?
    var selectedMonth: Int = Date.getCurrentMonth()
    var selectedYear: Int = Date.getCurrentYear()
    var selectedMonthName: String = ""
    var getCardDetailsResponseData: [GetCardDetails] = []

    var getAllBookingResponse : [GetAllBookings] = []
   // var paymentServiceManager = PaymentNetworkManager.shared
    var totalPrice:Double = 0.0
    override func viewDidLoad() {
        super.viewDidLoad()
        let currentMonth = Date.getCurrentMonth()
        let currentYear = Date.getCurrentYear()
        
        selectedMonth = currentMonth
        selectedYear = currentYear
        selectedMonthName = months[currentMonth - 1] // Set initial month name
        
        // Set the default month text in the text field
        txtMonths.text = selectedMonthName
       
        txtMonths.setUpTextFieldView(rightImageName: "arrowdown")
        monthNamesView.setCornerRadiusForView()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        // Register table view cells using UINib
        tableView.register(UINib(nibName: "PaymentDateTableViewCell", bundle: nil), forCellReuseIdentifier: "PaymentDateTableViewCell")
        tableView.register(UINib(nibName: "PaymentDetailsTableViewCell", bundle: nil), forCellReuseIdentifier: "PaymentDetailsTableViewCell")
        tableView.register(UINib(nibName: "PaymentMethodTableViewCell", bundle: nil), forCellReuseIdentifier: "PaymentMethodTableViewCell")
        tableView.register(UINib(nibName: "PayNowButtonTableViewCell", bundle: nil), forCellReuseIdentifier: "PayNowButtonTableViewCell")
        getAllBookingsAPI(month: currentMonth, year: currentYear)
        
    }
    
    
    @IBAction func btnBackAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
        
    }
    @IBAction func btnSelectMonthAction(_ sender: Any) {
        showMonthSelectionActionSheet()
    }
    
    private func showMonthSelectionActionSheet() {
        let actionSheet = UIAlertController(title: "Select Month", message: nil, preferredStyle: .actionSheet)
        let currentMonth = Date.getCurrentMonth()
        let currentYear = Date.getCurrentYear()
        
        for (index, month) in months.enumerated() {
            let monthIndex = index + 1 // 1-based index for months (January = 1, February = 2, etc.)
            
            var title = month
            
            // Mark the current month with additional text
            if monthIndex == currentMonth {
                title += " (Current Month)"
            }
            
            let action = UIAlertAction(title: title, style: .default) { [weak self] action in
                // Update the selected month and make the API call
                self?.txtMonths.text = month
                self?.selectedMonth = monthIndex // Store the selected month index
                self?.selectedMonthName = month // Store the selected month name
                if let selectedMonth = self?.selectedMonth {
                    self?.getAllBookingsAPI(month: selectedMonth, year: self?.selectedYear ?? currentYear)
                }
            }
            
            actionSheet.addAction(action)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
           actionSheet.addAction(cancelAction)
           
           // For iPad support
           if let popoverController = actionSheet.popoverPresentationController {
               popoverController.sourceView = self.view
               popoverController.sourceRect = btnSelectMonth.frame
           }
           self.present(actionSheet, animated: true, completion: nil)
    }
    
    
    
    private func getAllBookingsAPI(month: Int, year: Int)
    {
        let requestModel = GetAllBookingsRequestModel(month: month, year: year)
        
        APIManager.shared.request(
            modelType: GetAllBookingsResponseModel.self,
            type: PaymentMethodEndPoint.getAllBookings(requestModel: requestModel)) { response in
                DispatchQueue.main.async {
                    switch response {
                    case .success(let response):
                        self.getAllBookingResponse = response.data ?? []
                        print("getAllBookingResponse response is", self.getAllBookingResponse)
                        
                        if self.getAllBookingResponse.isEmpty {
                            self.view.makeToast("No bookings for this month", duration: 3.0, position: .center)
                        }
                        self.tableView.reloadData()
                        self.eventHandler?(.dataLoaded)
                    case .failure(let error):
                        self.eventHandler?(.error(error))
                    }
                }
            }
    }
    func calculateTotalPrice() -> Double {
        var total: Double = 0.0
        
        for booking in getAllBookingResponse {
            // Ensure totalPrice is not nil and convert it to Double
            if let priceString = booking.totalPrice, let totalPrice = Double(priceString) {
                total += totalPrice
            }
        }
        
        print("Total Price: \(total)") // Debug print
        
        return total
    }

}

// MARK: - UITableViewDataSource, UITableViewDelegate

extension SideMenuPaymentsViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 1:
            return getAllBookingResponse.count
        default:
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "PaymentDateTableViewCell", for: indexPath) as! PaymentDateTableViewCell
            cell.selectionStyle = .none
            cell.configure(withTotalPrice: calculateTotalPrice(), monthName: selectedMonthName)
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "PaymentDetailsTableViewCell", for: indexPath) as!  PaymentDetailsTableViewCell
            let item = getAllBookingResponse[indexPath.row]
            cell.setData(item: item)
            cell.selectionStyle = .none
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "PaymentMethodTableViewCell", for: indexPath)as! PaymentMethodTableViewCell
            cell.selectionStyle = .none
            return cell
        case 3:
            let cell = tableView.dequeueReusableCell(withIdentifier: "PayNowButtonTableViewCell", for: indexPath) as! PayNowButtonTableViewCell
            cell.selectionStyle = .none
            cell.delegate = self
            return cell
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 3 {
            var requestModel = NiPaymentRequestModel()
            requestModel.total = Int(totalPrice)
            requestModel.email = UserHelper.shared.getUserEmail()
            if UserHelper.shared.isGuest() {
                //paymentServiceManager.makePayment(requestModel: requestModel)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return ""
        case 1:
            return "Details"
        case 2:
            return ""
        case 3:
            return ""
        default:
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 112
        }else if indexPath.section == 1{
            return UITableView.automaticDimension //61
        }else if indexPath.section == 2 {
           // return 96
            return 0
        }
        return 60 // Default row height
    }
}

extension SideMenuPaymentsViewController {
    enum Event {
        case dataLoaded
        case error(Error?)
    }
}

extension SideMenuPaymentsViewController:PayNowButtonTableViewCellDelegate{
    func didTapPayNowButton() {
       // paymentServiceManager.currentViewController = self
        var requestModel = NiPaymentRequestModel()
        requestModel.total = Int(calculateTotalPrice())
        requestModel.email = UserHelper.shared.getUserEmail()
        if UserHelper.shared.isGuest() {
           // paymentServiceManager.makePayment(requestModel: requestModel)
        }
    }
    
    
}

