//
//  ProfileViewController.swift
//  RSOWorkspace
//
//  Created by Sumit Aquil on 01/04/24.
//

import UIKit

protocol SubViewDismissalProtocol: AnyObject {
    func subviewDismmised()
}

class ProfileViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    var eventHandler: ((_ event: Event) -> Void)?
    
    var myProfileResponse:MyProfile?
   
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        fetchMyProfiles()
       
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
        let cellIdentifiers = ["ProfileDetailsTableViewCell", "ChangePasswordTableViewCell", "MembershipPlanTableViewCell","AddPaymentMethodTableViewCell","RewardPointsTableViewCell"]
        for identifier in cellIdentifiers {
            tableView.register(UINib(nibName: identifier, bundle: nil), forCellReuseIdentifier: identifier)
        }
    }
    private func fetchMyProfiles() {
      DispatchQueue.main.async {
        RSOLoader.showLoader()
      }
        APIManager.shared.request(
            modelType: MyProfile.self, // Assuming your API returns an array of MyProfile
            type: MyProfileEndPoint.myProfile) { response in
                switch response {
                case .success(let response):
                    self.myProfileResponse = response
                   // print ("myProfileResponseCount",self.myProfileResponse)
                    DispatchQueue.main.async {
                      RSOLoader.removeLoader()
                        self.tableView.reloadData()
                    }
                    self.eventHandler?(.dataLoaded)
                case .failure(let error):
                    self.eventHandler?(.error(error))
                  DispatchQueue.main.async {
                    RSOLoader.removeLoader()
                  }
                }
            }
    }
}
extension ProfileViewController: UITableViewDataSource, UITableViewDelegate {
    
    enum SectionType: Int, CaseIterable {
        case profileDetails = 0
        case changePassword
        case membershipPlan
        case paymentMethod
       
        var cellIdentifier: String {
            switch self {
            case .profileDetails: return "ProfileDetailsTableViewCell"
            case .changePassword: return "ChangePasswordTableViewCell"
            case .membershipPlan: return "MembershipPlanTableViewCell"
            case .paymentMethod: return "AddPaymentMethodTableViewCell"
            }
        }

        var heightForRow: CGFloat {
            switch self {
            case .profileDetails: return 202
            case .changePassword: return 50
            case .membershipPlan: return 189
            case .paymentMethod: return 50
            
            }
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return SectionType.allCases.count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 5
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let section = SectionType(rawValue: indexPath.section) else {
            return UITableViewCell()
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: section.cellIdentifier, for: indexPath)
        cell.selectionStyle = .none
        
        switch section {
        case .profileDetails:
            if let profileDetailsCell = cell as? ProfileDetailsTableViewCell {
                profileDetailsCell.delegate = self
                //only one object in response for member
                profileDetailsCell.setData()
                return profileDetailsCell
            }
        case .changePassword:
            if let changePasswordCell = cell as? ChangePasswordTableViewCell {
               
                    return changePasswordCell
                
            }
        case .membershipPlan:
            if let membershipPlanCell = cell as? MembershipPlanTableViewCell {
               
                if let membershipPlan = myProfileResponse {
                          membershipPlanCell.setData(item: membershipPlan)
                      } else {
                          // Handle the case where myProfileResponse is nil
                          // For example, you could set some default data or show an error message
                          print("Error: myProfileResponse is nil")
                      }
                membershipPlanCell.delegate = self
                return membershipPlanCell
            }
        case .paymentMethod:
            if let paymentMethodCell = cell as? AddPaymentMethodTableViewCell {
                return paymentMethodCell
                
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

extension ProfileViewController {
    enum Event {
        case dataLoaded
        case error(Error?)
    }
}
extension ProfileViewController:editProfileDelegate{
    func sendDetails() {
       
        let firstName = myProfileResponse?.data.firstName ?? ""
        let lastName = myProfileResponse?.data.lastName ?? ""
        let designation = myProfileResponse?.data.designation ?? ""
        
        print("Sending details to UpdateProfileViewController")
        print("firstName:", firstName)
        print("lastName:", lastName)
        print("designation:", designation)
        
        let editProfileVC = UIViewController.createController(storyBoard: .Profile, ofType: UpdateProfileViewController.self)
        editProfileVC.firstName = firstName
        editProfileVC.lastName = lastName
        editProfileVC.designation = designation
        editProfileVC.dismissDelegate = self
        editProfileVC.modalPresentationStyle = .overFullScreen
        editProfileVC.modalTransitionStyle = .crossDissolve
        editProfileVC.view.backgroundColor = UIColor.clear
        self.present(editProfileVC, animated: true)
    }
}
extension ProfileViewController: SubViewDismissalProtocol {
    func subviewDismmised() {
        fetchMyProfiles()
    }
}

extension ProfileViewController: MembershipPlanDelegate {
    func navigateToDisplayMembershipPlans() {
        let membershipViewController = UIViewController.createController(storyBoard: .Membership, ofType: MembershipViewController.self)
        self.navigationController?.pushViewController(membershipViewController, animated: true)
    }
}
    
    
    
    

