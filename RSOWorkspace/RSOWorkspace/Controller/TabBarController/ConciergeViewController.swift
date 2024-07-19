//
//  ConciergeViewController.swift
//  RSOWorkspace
//
//  Created by Sumit Aquil on 23/02/24.
//

import UIKit

class ConciergeViewController: UIViewController,RSOTabCoordinated{

    var coordinator: RSOTabBarCordinator?

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var btnchatBot: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        btnchatBot.layer.cornerRadius = 9.0
        btnchatBot.layer.masksToBounds = true
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        coordinator?.hideBackButton(isHidden: true)
        coordinator?.setTitle(title: "Concierge")
        self.coordinator?.hideTopViewForHome(isHidden: false)
        coordinator?.updateButtonSelection(2)
    }
    private func setupTableView() {
        tableView.register(UINib(nibName: "OnDemandServicesTableViewCell", bundle: nil), forCellReuseIdentifier: "OnDemandServicesTableViewCell")
        tableView.register(UINib(nibName: "ReportAnIssueTableViewCell", bundle: nil), forCellReuseIdentifier: "ReportAnIssueTableViewCell")
        
        tableView.dataSource = self
        tableView.delegate = self
        
        navigationController?.navigationBar.isHidden = true
    }
    
}

extension ConciergeViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
            return 20 // Adjust the height of the header between sections
        }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
            return UIView() // Return an empty view for the header between sections
        }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "OnDemandServicesTableViewCell", for: indexPath) as! OnDemandServicesTableViewCell
            cell.selectionStyle = .none
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ReportAnIssueTableViewCell", for: indexPath) as! ReportAnIssueTableViewCell
            cell.selectionStyle = .none
            return cell
        default:
            return UITableViewCell()
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0{
            // Deselect the row so that it doesn't remain highlighted
            redirectToOnDemandServicesViewController()
        }else {
            tableView.deselectRow(at: indexPath, animated: true)
            redirectToReportAnIssueViewController()
        }
    }
    func redirectToOnDemandServicesViewController(){
        let onDemandServicesVC = UIViewController.createController(storyBoard: .ConciergeStoryboard, ofType: OnDemandServicesViewController.self)
        onDemandServicesVC.coordinator = self.coordinator
        self.navigationController?.pushViewController(onDemandServicesVC, animated: true)
        
    }
    func redirectToReportAnIssueViewController(){
        let reportAnIssueVC = UIViewController.createController(storyBoard: .ConciergeStoryboard, ofType: ReportAnIssueViewController.self)
        reportAnIssueVC.coordinator = self.coordinator
        self.navigationController?.pushViewController(reportAnIssueVC, animated: true)
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0 ,1:
            return 165
        default:
            return 100
        }
    }
    

}
