//
//  FAQViewController.swift
//  RSOWorkspace
//
//  Created by Sumit Aquil on 02/04/24.
//

import UIKit

class FAQViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var eventHandler: ((_ event: Event) -> Void)?
    var myFAQResponse: FAQResponse?
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
    }
    @IBAction func btnBackAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
        
    }
    private func setupTableView() {
        
        tableView.dataSource = self
        tableView.delegate = self
        navigationController?.navigationBar.isHidden = true
        registerTableCells()
        fetchFAQs()
    }
    
    private func registerTableCells() {
        let cellIdentifiers = ["FAQTableViewCell"]
        for identifier in cellIdentifiers {
            tableView.register(UINib(nibName: identifier, bundle: nil), forCellReuseIdentifier: identifier)
        }
    }
    private func fetchFAQs() {
        self.eventHandler?(.loading)
        APIManager.shared.request(
            modelType: FAQResponse.self, // Assuming your API returns an array of MyProfile
            type: FAQEndPoint.faqs) { response in
                self.eventHandler?(.stopLoading)
                switch response {
                case .success(let response):
                    self.myFAQResponse = response
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
extension FAQViewController: UITableViewDataSource, UITableViewDelegate {
    
    enum SectionType: Int, CaseIterable {
        case faq = 0
        
        var cellIdentifier: String {
            switch self {
            case .faq: return "FAQTableViewCell"
            }
        }
        
        var heightForRow: CGFloat {
            switch self {
            case .faq: return 191
         
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
        return myFAQResponse?.data.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let section = SectionType(rawValue: indexPath.section) else {
            return UITableViewCell()
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: section.cellIdentifier, for: indexPath)
        
        switch section {
        case .faq:
            if let faqCell = cell as? FAQTableViewCell {
                
                let item = myFAQResponse?.data[indexPath.row]
             
                if let faq = item{
                    faqCell.setData(item: faq)
                }
                if indexPath.row == 0{
                    faqCell.containerView.backgroundColor = .E_3_E_3_E_3
                }
                else{
                    faqCell.containerView.backgroundColor = .white

                }
                return faqCell
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

extension FAQViewController {
    enum Event {
        case loading
        case stopLoading
        case dataLoaded
        case error(Error?)
    }
}
