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
    
   
    // Array to store AboutRSO objects
    let aboutData: [AboutRSO] = [
        AboutRSO(imageName: "about1", title: "Fully Customizable", description: "Versatile office spaces that flex with your business growth which make us the perfect choice for all business sizes."),
        AboutRSO(imageName: "about2", title: "Perfectly Adaptable", description: "Transform your offices as your business grows. Your workspace evolves with every professional enhancement."),
        AboutRSO(imageName: "about3", title: "Prompt Set-Ups", description: "Face no complexity in set-up or unnecessary delays. With RSO, enjoy swift transitions and hassle free support."),
        AboutRSO(imageName: "about4", title: "Cost-Effective", description: "Extremely Low start up costs, flexible lease terms, no need to buy equipment or furniture, there's no DEWA or AC charges either."),
        AboutRSO(imageName: "about5", title: "Expert Support Staff", description: "Our staff help you out with all your requirements, never waste resources on hiring and executive search."),
        AboutRSO(imageName: "about6", title: "Boost Profits", description: "Invest in your core business, you do not need to worry about facilities planning."),
        AboutRSO(imageName: "about7", title: "Effective Placements", description: "Be well placed and network with other businesses through our corporate and social events."),
        AboutRSO(imageName: "about8", title: "Corporate Image", description: "Benefit from a professional corporate image and the style of resources usually reserved for large business.")
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Assign delegates
        tableView.delegate = self
        tableView.dataSource = self
        
        // Register the custom cell nib file
        let nib = UINib(nibName: "aboutRSOTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "aboutRSOTableViewCell")
    }
    @IBAction func btnBackAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
        
    }
    // MARK: - Table View Data Source
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return aboutData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "aboutRSOTableViewCell", for: indexPath) as! aboutRSOTableViewCell
        
        let aboutItem = aboutData[indexPath.row]
        cell.setData(item: aboutItem)
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 105
    }
}



