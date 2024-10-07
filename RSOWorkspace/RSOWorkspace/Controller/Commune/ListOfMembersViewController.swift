//
//  ListOfMembersViewController.swift
//  RSOWorkspace
//
//  Created by Sumit Aquil on 21/03/24.
//

import UIKit
import IQKeyboardManagerSwift

class ListOfMembersViewController: UIViewController {
    
    var coordinator : RSOTabBarCordinator?
    @IBOutlet weak var txtSearch: RSOTextField!
    @IBOutlet weak var btnBrowseDirectory: RSOButton!
    
    @IBOutlet weak var tableView: UITableView!
    var eventHandler: ((_ event: Event) -> Void)?
    var memberListArray:[Member] = []
    var memberCompanyName = ""
    var searchText :String?
    var companyMembersDict: [Int: [Member]] = [:] // Dictionary to store members for each company
    var companyList:[Company] = []
    var memberListSearchArray: [Int: [Member]] = [:]
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        coordinator?.hideBackButton(isHidden: false)
        coordinator?.setTitle(title: "Find Members")
      
        setupTableView()
        setsearchTextField()
        txtSearch.delegate = self // Set the delegate for txtSearch
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.txtSearch.text = self.searchText
        fetchCompaniesAndMembers()
        RSOLoader.showLoader()
    }
    
    @IBAction func btnBrowseDirectoryTappedAction(_ sender: Any) {
        let browseDirectoryVC = UIViewController.createController(storyBoard: .Commune, ofType: BrowseMembersViewController.self)
        browseDirectoryVC.coordinator = self.coordinator
        self.navigationController?.pushViewController(browseDirectoryVC, animated: true)
        
    }
    func setsearchTextField(){
        btnBrowseDirectory.layer.cornerRadius = btnBrowseDirectory.bounds.height / 2
        txtSearch.layer.cornerRadius = txtSearch.bounds.height / 2
        txtSearch.placeholderText = "Search Members"
        
        txtSearch.placeholderColor = ._595959
        txtSearch.customBackgroundColor = .white
        txtSearch.placeholderFont = RSOFont.inter(size: 14, type: .SemiBold)
        txtSearch.customBorderWidth = 0.0
        txtSearch.setUpTextFieldView(rightImageName:"search")
    }
    
    private func setupTableView() {
        tableView.register(UINib(nibName: "FindMembersSearchListTableViewCell", bundle: nil), forCellReuseIdentifier: "FindMembersSearchListTableViewCell")
        
        tableView.dataSource = self
        tableView.delegate = self
        
        navigationController?.navigationBar.isHidden = true
    }
    

    func fetchCompaniesAndMembers() {
        let dispatchGroup = DispatchGroup() // Create a dispatch group

        // Fetch companies
        APIManager.shared.request(modelType: CompanyListResponse.self, type: CommuneEndPoint.companyList) { [weak self] response in
            guard let self = self else { return }
            switch response {
            case .success(let response):
                self.companyList = response.data

                // Iterate over each company to fetch its members
                for company in self.companyList {
                    dispatchGroup.enter() // Enter the group before starting each request
                    self.fetchListOfMembers(requestModel: MemberSearchRequest(membersSearch: nil, companyId: company.id), forCompany: company, dispatchGroup: dispatchGroup)
                }

                // Notify when all member requests have been completed
                dispatchGroup.notify(queue: .main) {
                    self.filterMembers()
                    RSOLoader.removeLoader()
                    self.eventHandler?(.dataLoaded) // This callback will be called once all fetch operations are completed
                }
                
            case .failure(let error):
                DispatchQueue.main.async {
                    RSOLoader.removeLoader()
                    self.eventHandler?(.error(error))
                }
            }
        }
    }

    func fetchListOfMembers(requestModel: MemberSearchRequest?, forCompany company: Company, dispatchGroup: DispatchGroup) {
        APIManager.shared.request(modelType: MemberListResponse.self, type: CommuneEndPoint.memberList(requestModel: requestModel ?? MemberSearchRequest(membersSearch: nil, companyId: nil))) { [weak self] response in
            guard let self = self else { return }
            switch response {
            case .success(let response):
                let members = response.data
                self.companyMembersDict[company.id] = members // Store members for the company using company ID as key
                
            case .failure(let error):
                self.eventHandler?(.error(error))
            }

            dispatchGroup.leave() // Leave the group when the request is complete
        }
    }

    func fetchListOfMembers(requestModel:MemberSearchRequest?) {
       
        APIManager.shared.request(
            modelType: MemberListResponse.self, // Assuming your API returns an array of Services
            type: CommuneEndPoint.memberList(requestModel: requestModel ?? MemberSearchRequest(membersSearch: nil, companyId: nil))){ response in
                switch response {
                case .success(let response):
                    self.memberListArray = response.data
                    print("count is ",self.memberListArray.count)
                    DispatchQueue.main.async {
                        print("Member List Count: \(self.memberListArray.count)")
                    }
                    self.eventHandler?(.dataLoaded)
                case .failure(let error):
                    self.eventHandler?(.error(error))
                }
        }
    }
    
    
}

extension ListOfMembersViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0 // Adjust the height of the header between sections
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let searchText = txtSearch.text, !searchText.isEmpty {
                // If search text is not empty, return the count of filtered members
                return memberListSearchArray.count
            } else {
                // If search text is empty, return the count of all company members
                return companyMembersDict.count
            }
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView() // Return an empty view for the header between sections
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FindMembersSearchListTableViewCell", for: indexPath) as! FindMembersSearchListTableViewCell
        cell.selectionStyle = .none
       
        if let searchText = txtSearch.text, !searchText.isEmpty{
            let company = companyList[indexPath.row]
                 let members = memberListSearchArray[company.id] ?? [] // Get members for the company
                 
                 if let firstMember = members.first {
                     cell.setData(item: firstMember, memberCompany: company.name)
                 }
        }else{
            let company = companyList[indexPath.row]
                 let members = companyMembersDict[company.id] ?? [] // Get members for the company
                 
                 if let firstMember = members.first {
                     cell.setData(item: firstMember, memberCompany: company.name)
                 }
        }

        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 168
    }
}


extension ListOfMembersViewController {
    enum Event {
        
        case dataLoaded
        case error(Error?)
    }
}
extension ListOfMembersViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder() // Hide the keyboard
        return true
    }

    func filterMembers() {
        guard let searchText = txtSearch.text?.lowercased(), !searchText.isEmpty else {
            // If the search text is empty, show all members for each company
            memberListSearchArray = companyMembersDict
            tableView.reloadData()
            return
        }

        // Filter members based on the search query for each company
        memberListSearchArray = [:] // Clear previous search results
        for (companyId, members) in companyMembersDict {
            let filteredMembers = members.filter { member in
                if let firstName = member.firstName, let lastName = member.lastName {
                    let fullName = "\(firstName) \(lastName)"
                    return fullName.lowercased().contains(searchText)
                }
                return false
            }
            if !filteredMembers.isEmpty {
                memberListSearchArray[companyId] = filteredMembers
            }
        }
        if memberListSearchArray.flatMap({ $0.value }).isEmpty {
            self.view.makeToast("No Records found", duration: 2,position: .center)
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

