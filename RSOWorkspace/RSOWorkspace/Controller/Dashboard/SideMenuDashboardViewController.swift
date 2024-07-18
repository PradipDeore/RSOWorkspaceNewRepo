//
//  SideMenuDashboardViewController.swift
//  RSOWorkspace
//
//  Created by Sumit Aquil on 15/04/24.
//

import UIKit


class SideMenuDashboardViewController: UIViewController {
    
  @IBOutlet var topViewHeightConstraint: NSLayoutConstraint!
  @IBOutlet weak var tableView: UITableView!
    var eventHandler: ((_ event: Event) -> Void)?
    
    var myProfileResponse:MyProfile?
   
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        //fetchMyProfiles()
       
    }
    
    @IBAction func btnBackAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    private func setupTableView() {
        
        tableView.dataSource = self
        tableView.delegate = self
        navigationController?.navigationBar.isHidden = true
        registerTableCells()
    }
    
    private func registerTableCells() {
        let cellIdentifiers = ["SelectDateTableViewCell", "MyBookingOpenTableViewCell", "PaymentTableViewCell"]
        for identifier in cellIdentifiers {
            tableView.register(UINib(nibName: identifier, bundle: nil), forCellReuseIdentifier: identifier)
        }
    }
    private func fetchMyProfiles() {
        self.eventHandler?(.loading)
        APIManager.shared.request(
            modelType: MyProfile.self, // Assuming your API returns an array of MyProfile
            type: MyProfileEndPoint.myProfile) { response in
                self.eventHandler?(.stopLoading)
                switch response {
                case .success(let response):
                    self.myProfileResponse = response
                   // print ("myProfileResponseCount",self.myProfileResponse)
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
extension SideMenuDashboardViewController: UITableViewDataSource, UITableViewDelegate {
    
    enum SectionType: Int, CaseIterable {
        case myBookingDate = 0
        case myBookings
        case payments
        
        var cellIdentifier: String {
            switch self {
            case .myBookingDate: return "SelectDateTableViewCell"
            case .myBookings: return "MyBookingOpenTableViewCell"
            case .payments: return "PaymentTableViewCell"
            }
        }
        
        var heightForRow: CGFloat {
            switch self {
            case .myBookingDate: return 334
            case .myBookings: return 80
            case .payments:
                return 203
            }
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return SectionType.allCases.count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let section = SectionType(rawValue: indexPath.section) else {
            return UITableViewCell()
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: section.cellIdentifier, for: indexPath)
        
        switch section {
        case .myBookingDate:
          
            if let dateCell = cell as? SelectDateTableViewCell {
                return dateCell
            }
        case .myBookings:
            if let changePasswordCell = cell as? ChangePasswordTableViewCell {
                if indexPath.row == 3 {
                    changePasswordCell.lblTitle.text = "Add payment method"
                    changePasswordCell.lblTitle.font = RSOFont.poppins(size: 14, type: .SemiBold)
                }
                return changePasswordCell
                
            }
        case .payments:
            if let paymentCell = cell as? PaymentTableViewCell {
                return paymentCell
            }
        default:
            break
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let section = SectionType(rawValue: indexPath.section) else {
            return 100
        }
        return section.heightForRow
    }
}

extension SideMenuDashboardViewController {
    enum Event {
        case loading
        case stopLoading
        case dataLoaded
        case error(Error?)
    }
}

