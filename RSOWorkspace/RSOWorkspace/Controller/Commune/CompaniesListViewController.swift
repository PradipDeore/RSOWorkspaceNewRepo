//
//  CompaniesListViewController.swift
//  RSOWorkspace
//
//  Created by Sumit Aquil on 21/03/24.
//

import UIKit

class CompaniesListViewController: UIViewController {

    var coordinator: RSOTabBarCordinator?

    @IBOutlet weak var tableView: UITableView!
    var eventHandler: ((_ event: Event) -> Void)?
    var companiesListArray:[Company] = []
    override func viewDidLoad() {
        super.viewDidLoad()
       
        coordinator?.hideBackButton(isHidden: false)
        coordinator?.setTitle(title: "Companies")
      
        setupTableView()
        fetchCompaniesList()
    }
    
    private func setupTableView() {
        tableView.register(UINib(nibName: "CompaniesListTableViewCell", bundle: nil), forCellReuseIdentifier: "CompaniesListTableViewCell")
        
        tableView.dataSource = self
        tableView.delegate = self
        
        navigationController?.navigationBar.isHidden = true
    }
    func fetchCompaniesList() {
        self.eventHandler?(.loading)
        APIManager.shared.request(
            modelType: CompanyListResponse.self, // Assuming your API returns an array of Services
            type: CommuneEndPoint.companyList) { response in
                self.eventHandler?(.stopLoading)
                switch response {
                case .success(let response):
                    self.companiesListArray = response.data
                
                    print("count is ",self.companiesListArray.count)
                    print("memberListArray ",self.companiesListArray)
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

extension CompaniesListViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
            return 0 // Adjust the height of the header between sections
        }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return companiesListArray.count
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
            return UIView() // Return an empty view for the header between sections
        }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "CompaniesListTableViewCell", for: indexPath) as! CompaniesListTableViewCell
            cell.selectionStyle = .none
            cell.delegate = self
            let item = companiesListArray[indexPath.row]
            cell.setData(item: item)
            cell.tag = indexPath.row
            return cell
        
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            return 150
        default:
            return 100
        }
    }
    

}
extension CompaniesListViewController:ButtonBrowseMambersDelegate{
    func btnBrowseMembersTappedAction(index:Int) {
        
        let selectedCompany = companiesListArray[index]
               
        let browseMembersListVC = UIViewController.createController(storyBoard: .Commune, ofType: BrowseMembersViewController.self)
        browseMembersListVC.selectedCompanyId = selectedCompany.id
        browseMembersListVC.selectedCompanyName = selectedCompany.name
        
        self.navigationController?.pushViewController(browseMembersListVC, animated: true)
    }
    
    
}
extension CompaniesListViewController {
    enum Event {
        case loading
        case stopLoading
        case dataLoaded
        case error(Error?)
    }
}
