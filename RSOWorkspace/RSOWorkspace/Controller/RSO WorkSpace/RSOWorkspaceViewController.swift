//
//  RSOWorkspaceViewController.swift
//  RSOWorkspace
//
//  Created by Sumit Aquil on 02/04/24.
//

import UIKit

import UIKit

class RSOWorkspaceViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    var aboutUsResponse: AboutUsResponseModel?
    var aboutUsData : [AboutRSO] = []
    var eventHandler: ((_ event: Event) -> Void)?
  
  
    @IBOutlet weak var lblAboutRSOTitleText: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Assign delegates
        tableView.delegate = self
        tableView.dataSource = self
        // Register the custom cell nib file
        let nib = UINib(nibName: "aboutRSOTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "aboutRSOTableViewCell")
        
        fetchABoutUs()
    }
    @IBAction func btnBackAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
        
    }
    // MARK: - Table View Data Source
    private func fetchABoutUs() {
        APIManager.shared.request(
            modelType: AboutUsResponseModel.self, // Assuming your API returns an array of MyProfile
            type: AboutUsEndPoint.aboutUs) { response in
                DispatchQueue.main.async {
                    switch response {
                    case .success(let response):
                        self.lblAboutRSOTitleText.text = response.title
                        self.aboutUsData = response.data ?? []
                        self.tableView.reloadData()
                        self.eventHandler?(.dataLoaded)
                    case .failure(let error):
                        self.eventHandler?(.error(error))
                    }
                }
            }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return aboutUsData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "aboutRSOTableViewCell", for: indexPath) as! aboutRSOTableViewCell
        
        let aboutItem = aboutUsData[indexPath.row]
        cell.setData(item: aboutItem)
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 105
    }
}


extension RSOWorkspaceViewController {
    enum Event {
        
        case dataLoaded
        case error(Error?)
    }
}
