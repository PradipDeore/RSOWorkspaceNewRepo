//
//  BrowseMembersViewController.swift
//  RSOWorkspace
//
//  Created by Sumit Aquil on 21/03/24.
//

import UIKit
import IQKeyboardManagerSwift


class BrowseMembersViewController: UIViewController {
    
    var coordinator : RSOTabBarCordinator?

    @IBOutlet weak var txtSearch: RSOTextField!
    @IBOutlet weak var tableView: UITableView!
    var selectedCompanyName = ""
    var selectedCompanyId: Int?
    var eventHandler: ((_ event: Event) -> Void)?
    
    @IBOutlet weak var btnBrowseDirectory: RSOButton!
    var companyMembersDict: [Int: [Member]] = [:] // Dictionary to store members for each company
    var companyList:[Company] = []
    var memberListSearchArray: [Int: [Member]] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        coordinator?.hideBackButton(isHidden: false)

        if selectedCompanyId != nil{
            coordinator?.setTitle(title: "Companies")
        }else{
            coordinator?.setTitle(title: "Find Members")

        }
        setupTableView()
        tableView.register(CustomHeaderView.self, forHeaderFooterViewReuseIdentifier: "CustomHeaderView")

        setsearchTextField()
        txtSearch.delegate = self
   
        fetchCompaniesAndMembers()
        btnBrowseDirectory.isHidden = false
        showHideBtnBrowseDirectory()
        
    }
    func setsearchTextField(){
        
        txtSearch.layer.cornerRadius = txtSearch.bounds.height / 2
        txtSearch.placeholderText = "Search Members"
        
        txtSearch.placeholderColor = ._595959
        txtSearch.customBackgroundColor = .white
        txtSearch.placeholderFont = RSOFont.inter(size: 14, type: .SemiBold)
        txtSearch.customBorderWidth = 0.0
        txtSearch.setUpTextFieldView(rightImageName:"search")
    }
    func showHideBtnBrowseDirectory(){
        btnBrowseDirectory.layer.cornerRadius = btnBrowseDirectory.bounds.height / 2
        btnBrowseDirectory.backgroundColor = .BFBFBF
        btnBrowseDirectory.setTitleColor(.black, for: .normal)
        if let selectedCompanyId = selectedCompanyId {
            
            print("selectedCompanyId",selectedCompanyId  )
            btnBrowseDirectory.isHidden = true
        }else{
            btnBrowseDirectory.isHidden = false
        }
    }
    private func setupTableView() {
        
        tableView.register(UINib(nibName: "ComapaniesSearchMembersTableViewCell", bundle: nil), forCellReuseIdentifier: "ComapaniesSearchMembersTableViewCell")
        
        tableView.dataSource = self
        tableView.delegate = self
        
        navigationController?.navigationBar.isHidden = true
    }
    func fetchCompaniesAndMembers() {
        // Fetch companies
        APIManager.shared.request(modelType: CompanyListResponse.self, type: CommuneEndPoint.companyList) { [weak self] response in
            guard let self = self else { return }
            switch response {
            case .success(let response):
                self.companyList = response.data
                
                // Iterate over each company to fetch its members
                for company in self.companyList {
                    self.fetchListOfMembers(requestModel: MemberSearchRequest(membersSearch: nil, companyId: company.id), forCompany: company)
                }
                
                
            case .failure(let error):
                self.eventHandler?(.error(error))
            }
        }
    }
    
    func fetchListOfMembers(requestModel: MemberSearchRequest?, forCompany company: Company) {
 
        APIManager.shared.request(modelType: MemberListResponse.self, type: CommuneEndPoint.memberList(requestModel: requestModel ?? MemberSearchRequest(membersSearch: nil, companyId: nil))) { [weak self] response in
            guard let self = self else { return }
            switch response {
            case .success(let response):
                let members = response.data
//                if let companyId = company?.id{
//                    self.companyMembersDict[companyId] = members // Store members for the company using company ID as key
//
//                }
                self.companyMembersDict[company.id] = members // Store members for the company using company ID as key

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

extension BrowseMembersViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        if let searchText = txtSearch.text, !searchText.isEmpty {
               // If search text is not empty
               if selectedCompanyId != nil {
                   // If a company is selected, display all search results in a single section
                   return 1
               } else {
                   // If no company is selected, display each search result in its own section
                   return memberListSearchArray.count
               }
           } else {
               // If search text is empty
               if selectedCompanyId != nil {
                   // If a company is selected, display all members in a single section
                   return 1
               } else {
                   // If no company is selected, each company will have its own section
                   return companyList.count
               }
           }
       
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50 // Adjust the height of the header between sections
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let selectedCompanyId = selectedCompanyId {
            if let searchText = txtSearch.text, !searchText.isEmpty{
                return memberListSearchArray[selectedCompanyId]?.count ?? 0

            }else{
                return companyMembersDict[selectedCompanyId]?.count ?? 0
            }
        } else {
            // Check if search text is empty
                    if let searchText = txtSearch.text, !searchText.isEmpty {
                        // If search text is not empty, display filtered search results
                        return memberListSearchArray[companyList[section].id]?.count ?? 0
                    } else {
                        // If search text is empty, display all members for the company
                        return companyMembersDict[companyList[section].id]?.count ?? 0
                    }
        }
    }
    
  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
      let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "CustomHeaderView") as! CustomHeaderView
      
      if let selectedCompanyId = selectedCompanyId {
          if let selectedCompany = companyList.first(where: { $0.id == selectedCompanyId }) {
              headerView.titleLabel.text = selectedCompany.name
          }
      } else {
          headerView.titleLabel.text = companyList[section].name
      }
      headerView.backgroundColor = .clear
      headerView.titleLabel.backgroundColor = .clear
      headerView.titleLabel.textColor = .black
      headerView.titleLabel.font = RSOFont.inter(size: 18, type: .SemiBold)
      
      return headerView
  }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ComapaniesSearchMembersTableViewCell", for: indexPath) as! ComapaniesSearchMembersTableViewCell
        cell.selectionStyle = .none
        cell.delegateShowCard = self
        if let selectedCompanyId = selectedCompanyId {
            if let searchText = txtSearch.text, !searchText.isEmpty{
                if let members = memberListSearchArray[selectedCompanyId], indexPath.row < members.count {
                    let member = members[indexPath.row]
                    cell.lblMemberName.text = "\(member.firstName ?? "") \(member.lastName ?? "")"
                }
            }else{
                if let members = companyMembersDict[selectedCompanyId], indexPath.row < members.count {
                    let member = members[indexPath.row]
                    cell.lblMemberName.text = "\(member.firstName ?? "") \(member.lastName ?? "")"
                }
            }
        } else {
            if let searchText = txtSearch.text, !searchText.isEmpty{
                let company = companyList[indexPath.section]
                if let members = memberListSearchArray[company.id], indexPath.row < members.count {
                    let member = members[indexPath.row]
                    cell.lblMemberName.text = "\(member.firstName ?? "") \(member.lastName ?? "")"
                }
            }else{
                let company = companyList[indexPath.section]
                if let members = companyMembersDict[company.id], indexPath.row < members.count {
                    let member = members[indexPath.row]
                    cell.lblMemberName.text = "\(member.firstName ?? "") \(member.lastName ?? "")"
                }
            }
           
        }
        cell.lblMemberName.addUnderline()
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var selectedMember:Member?
        var selectedMemberCompany = ""
        if let selectedCompanyId = selectedCompanyId {
            if let searchText = txtSearch.text, !searchText.isEmpty{
                if let members = memberListSearchArray[selectedCompanyId], indexPath.row < members.count {
                    selectedMember = members[indexPath.row]
                    selectedMemberCompany = companyList.first(where: { $0.id == selectedCompanyId })?.name ?? ""

                }
            }else{
                if let members = companyMembersDict[selectedCompanyId], indexPath.row < members.count {
                    selectedMember = members[indexPath.row]
                    selectedMemberCompany = companyList.first(where: { $0.id == selectedCompanyId })?.name ?? ""
                }
            }
        } else {
            if let searchText = txtSearch.text, !searchText.isEmpty{
                let company = companyList[indexPath.section]
                if let members = memberListSearchArray[company.id], indexPath.row < members.count {
                    selectedMember = members[indexPath.row]
                    selectedMemberCompany = company.name
                }
            }else{
                let company = companyList[indexPath.section]
                if let members = companyMembersDict[company.id], indexPath.row < members.count {
                    selectedMember = members[indexPath.row]
                    selectedMemberCompany = company.name

                }
            }
        }
        // Call the delegate method to show the card with the selected member
           if let selectedMember = selectedMember {
               self.showCard(for: selectedMember, membercompany: selectedMemberCompany)
           }

    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
}
extension BrowseMembersViewController:LabelMemberNameTappedDelegate{
   
    func showCard(for member: Member, membercompany: String){
        let cardVC = UIViewController.createController(storyBoard: .Commune, ofType: FindMembersCardViewController.self)
        cardVC.modalPresentationStyle = .overFullScreen
        cardVC.modalTransitionStyle = .crossDissolve
        cardVC.view.backgroundColor = UIColor.clear
        // Pass the selected member to the FindMembersCardViewController
        cardVC.configure(with: member, companyName: membercompany)
        self.present(cardVC, animated: true)
    }
}
extension BrowseMembersViewController {
    enum Event {
        
        case dataLoaded
        case error(Error?)
    }
}
// Implement UITextFieldDelegate method to handle search
extension BrowseMembersViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            textField.resignFirstResponder() // Hide the keyboard
            filterMembers()
            return true
        }

        func filterMembers() {
            guard let searchText = txtSearch.text?.lowercased(), !searchText.isEmpty else {
                // If the search text is empty, show all members
                memberListSearchArray = companyMembersDict
                tableView.reloadData()
                return
            }

            // Filter members based on the search query
            memberListSearchArray = companyMembersDict.mapValues { members in
                members.filter { member in
                    if let firstName = member.firstName, let lastName = member.lastName {
                        let fullName = "\(firstName) \(lastName)"
                        return fullName.lowercased().contains(searchText)
                    }
                    return false
                }
            }

            tableView.reloadData()
        }

        func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
            // Delay the filter operation to ensure that all the changes from typing are reflected
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                self.filterMembers()
            }
            return true
        }
}

