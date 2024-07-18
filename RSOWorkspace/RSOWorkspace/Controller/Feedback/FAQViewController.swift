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
    var myFAQResponse: FAQResponse? {
        didSet {
            isExpandedArray = Array(repeating: false, count: myFAQResponse?.data.count ?? 0)
        }
    }
    
    var isExpandedArray: [Bool] = []
   
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
        let cellIdentifiers = ["FAQTitleTableViewCell","FAQDescriptionTableViewCell"]
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
        case faqTitle = 0
        case faqDescription
        
        var cellIdentifier: String {
            switch self {
            case .faqTitle: return "FAQTitleTableViewCell"
            case .faqDescription: return "FAQDescriptionTableViewCell"
            }
        }
        
        var heightForRow: CGFloat {
            switch self {
            case .faqTitle: return 72
            case .faqDescription:return 191
                
            }
        }
    }

    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
            return 1 // Ensure only one section is present
        }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myFAQResponse?.data.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let item = myFAQResponse?.data[indexPath.row] else { return UITableViewCell() }
        
        if isExpandedArray[indexPath.row] {
            let cell = tableView.dequeueReusableCell(withIdentifier: "FAQDescriptionTableViewCell", for: indexPath) as! FAQDescriptionTableViewCell
            cell.setData(item: item)
            cell.selectionStyle = .none
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "FAQTitleTableViewCell", for: indexPath) as! FAQTitleTableViewCell
            cell.setData(item: item)
            cell.selectionStyle = .none
            return cell
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        isExpandedArray[indexPath.row].toggle() // Toggle the expanded state
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return isExpandedArray[indexPath.row] ? 191 : 72
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
