//
//  NotificationsViewController.swift
//  RSOWorkspace
//
//  Created by Sumit Aquil on 18/04/24.
//

import UIKit

class NotificationsViewController: UIViewController {
    
    var coordinator: RSOTabBarCordinator?
    @IBOutlet weak var tableView: UITableView!
    var notificationList:[Notifications] = []
    var eventHandler: ((_ event: Event) -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.coordinator?.hideBackButton(isHidden: false)
        setupTableView()
        fetchNotifications()
    }
    
    private func setupTableView() {
        // Register custom cell
        tableView.register(UINib(nibName: "NotificationTableViewCell", bundle: nil), forCellReuseIdentifier: "NotificationTableViewCell")
        // Set delegate and data source
        tableView.delegate = self
        tableView.dataSource = self
        
    }
    @IBAction func backButtonAction(_ sender: Any) {
      self.navigationController?.popViewController(animated: true)
    }
    
    
    private func fetchNotifications () {
        self.eventHandler?(.loading)
        APIManager.shared.request(
            modelType: NotificationResponseModel.self, // Assuming your API returns an array of Services
            type: NotificationEndPoint.notifications) { response in
                self.eventHandler?(.stopLoading)
                switch response {
                case .success(let response):
                    self.notificationList = response.data
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

// MARK: - UITableView Delegate & DataSource

extension NotificationsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notificationList.count // Row count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NotificationTableViewCell", for: indexPath) as! NotificationTableViewCell
        let item = notificationList[indexPath.row]
        cell.setNotifications(item: item)
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 85
    }
}
extension NotificationsViewController {
    enum Event {
        case loading
        case stopLoading
        case dataLoaded
        case error(Error?)
    }
}
