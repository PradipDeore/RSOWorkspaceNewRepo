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
    var notificationList:[NotificationData] = []
    var eventHandler: ((_ event: Event) -> Void)?
    let notificationCount = 0
    var unreadNotificationCount = 0
    var notificationId = 0
    var expandedIndexSet: Set<Int> = [] // Track which cells are expanded
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        fetchNotifications()
    }
    
    private func setupTableView() {
        // Register custom cell
        tableView.register(UINib(nibName: "NotificationTableViewCell", bundle: nil), forCellReuseIdentifier: "NotificationTableViewCell")
        tableView.register(UINib(nibName: "NotificationDescTableViewCell", bundle: nil), forCellReuseIdentifier: "NotificationDescTableViewCell")
        // Set delegate and data source
        tableView.delegate = self
        tableView.dataSource = self
        
    }
    @IBAction func backButtonAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
        self.coordinator?.loadHomeScreen()
    }
    
    private func fetchNotifications() {
        APIManager.shared.request(
            modelType: NotificationResponseModel.self, // Assuming your API returns an array of Services
            type: NotificationEndPoint.notifications) { response in
                switch response {
                case .success(let response):
                    self.notificationList = response.data ?? []
                    // let notificationCount  = self.notificationList.count
                    //UserHelper.shared.saveNotificationCount(notificationCount: notificationCount)
                    let notificationCount = response.unseenCount
                    UserHelper.shared.saveUnreadNotificationCount(notificationCount: notificationCount )
                    UserHelper.shared.saveReadNotificationCount(notificationCount: self.unreadNotificationCount)
                    
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                    self.eventHandler?(.dataLoaded)
                case .failure(let error):
                    self.eventHandler?(.error(error))
                }
            }
    }
    private func fetchNotificationStatus(notificationId:Int) {
        APIManager.shared.request(
            modelType: NotificationStatusResponseModel.self, // Assuming your API returns an array of Services
            type: NotificationEndPoint.notificationStatus(notificationId: notificationId)) { response in
                switch response {
                case .success(let response):
                    if response.status {
                        print("Notification status fetched successfully")
                    } else {
                        print("Notification status is false")
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
        if expandedIndexSet.contains(indexPath.row) {
               // Show the description cell
               let cell = tableView.dequeueReusableCell(withIdentifier: "NotificationDescTableViewCell", for: indexPath) as! NotificationDescTableViewCell
               let item = notificationList[indexPath.row]
               cell.setNotificationsDetails(item: item)
               cell.selectionStyle = .none
               return cell
           } else {
               // Show the regular notification cell
               let cell = tableView.dequeueReusableCell(withIdentifier: "NotificationTableViewCell", for: indexPath) as! NotificationTableViewCell
               let item = notificationList[indexPath.row]
               cell.setNotifications(item: item)
               cell.selectionStyle = .none
               return cell
           }
    }
    //    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    //        return 85
    //    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Fetch the selected notification
           var selectedNotification = notificationList[indexPath.row]
           
           // If the notification is unread (isSeen == 0), mark it as read
           if selectedNotification.isSeen == 0 {
               selectedNotification.isSeen = 1
               notificationList[indexPath.row] = selectedNotification
               
               // Optionally update your backend that the notification is seen
               fetchNotificationStatus(notificationId: selectedNotification.id)
               
               // Reload just the selected row to reflect the seen status
               tableView.reloadRows(at: [indexPath], with: .automatic)
           }
           
           // Optionally toggle expansion for the cell
           if expandedIndexSet.contains(indexPath.row) {
               expandedIndexSet.remove(indexPath.row)
           } else {
               expandedIndexSet.insert(indexPath.row)
           }
           tableView.reloadRows(at: [indexPath], with: .automatic)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        // Return different heights depending on the state
        if expandedIndexSet.contains(indexPath.row) {
            return UITableView.automaticDimension // Dynamic height for description cell
        } else {
            return 85 // Fixed height for notification cell
        }
    }
}
extension NotificationsViewController {
    enum Event {
        case dataLoaded
        case error(Error?)
    }
}
