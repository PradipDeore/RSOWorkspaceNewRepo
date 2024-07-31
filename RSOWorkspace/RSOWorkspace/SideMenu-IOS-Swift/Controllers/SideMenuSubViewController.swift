//
//  SideMenuViewController.swift
//  SideMenu-IOS-Swift
//
//  Created by apple on 12/01/22.
//

import UIKit

protocol SideMenuViewControllerDelegate {
    func selectedCell(_ row: Int, menuTitle: String)
}
class SideMenuSubViewController: UIViewController {
    
    @IBOutlet var roundedView: UIView!
    @IBOutlet var headerImageView: UIImageView!
    @IBOutlet var sideMenuTableView: UITableView!
    @IBOutlet var footerLabel: UILabel!
    
    @IBOutlet weak var lblCompanyName: UILabel!
    @IBOutlet weak var lblName: UILabel!
    
    var eventHandler: ((_ event: Event) -> Void)? // Data Binding Closure
    var myProfileResponse:MyProfile?
    
    var delegate: SideMenuViewControllerDelegate?
    var defaultHighlightedCell: Int = 0
    
    var menu: [SideMenuModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        headerImageView.setRounded()
        roundedView.layer.cornerRadius = 35
        // TableView
        self.sideMenuTableView.delegate = self
        self.sideMenuTableView.dataSource = self
        self.sideMenuTableView.backgroundColor = .BFBFBF
        self.sideMenuTableView.separatorStyle = .none
        
        menu = createMenu()
        // Set Highlighted Cell
        DispatchQueue.main.async {
            let defaultRow = IndexPath(row: self.defaultHighlightedCell, section: 0)
            self.sideMenuTableView.selectRow(at: defaultRow, animated: false, scrollPosition: .none)
        }
        
        // Footer
        self.footerLabel.textColor = ._2_C_2_C_2_C
        self.footerLabel.font = RSOFont.poppins(size: 16, type: .SemiBold)
        //self.footerLabel.text = "Version 1.1"
        
        // Register TableView Cell
        self.sideMenuTableView.register(SideMenuCell.nib, forCellReuseIdentifier: SideMenuCell.identifier)
        
        // Update TableView with the data
        self.sideMenuTableView.reloadData()
        fetchMyProfiles()
        
    }

    func refreshMenuList(){
        fetchMyProfiles()
        menu = createMenu()
        self.sideMenuTableView.backgroundColor = .BFBFBF
        self.sideMenuTableView.separatorStyle = .none
        
        // Set Highlighted Cell
        DispatchQueue.main.async {
            let defaultRow = IndexPath(row: self.defaultHighlightedCell, section: 0)
            self.sideMenuTableView.selectRow(at: defaultRow, animated: false, scrollPosition: .none)
        }
        
        // Footer
        self.footerLabel.textColor = ._2_C_2_C_2_C
        self.footerLabel.font = RSOFont.poppins(size: 16, type: .SemiBold)
        self.sideMenuTableView.reloadData()
    }
    func createMenu() -> [SideMenuModel] {
        var menu: [SideMenuModel] = [
            SideMenuModel(title: "My Profile"),
            SideMenuModel(title: "Dashboard"),
            SideMenuModel(title: "")
        ]
        menu.append(SideMenuModel(title: "Schedule Visitors"))
        menu.append(SideMenuModel(title: "My Visitors"))
        menu.append(SideMenuModel(title: ""))
        menu.append(SideMenuModel(title: "Amenities"))
        if !UserHelper.shared.isUserExplorer(){
            menu.append(SideMenuModel(title: "Payments"))
        }
        menu.append(SideMenuModel(title: ""))
        menu.append(SideMenuModel(title: "Feedback"))
        menu.append(SideMenuModel(title: "FAQs"))
        menu.append(SideMenuModel(title: ""))
        menu.append(SideMenuModel(title: "Locations"))
        menu.append(SideMenuModel(title: "About Us"))
        menu.append(SideMenuModel(title: ""))
        if !UserHelper.shared.isUserExplorer(){
            menu.append(SideMenuModel(title: "Logout"))
        }
        
        return menu
    }
    private func fetchMyProfiles() {
        self.eventHandler?(.loading)
        APIManager.shared.request(
            modelType: MyProfile.self, // Assuming your API returns an array of MyProfile
            type: MyProfileEndPoint.myProfile) { response in
                self.eventHandler?(.stopLoading)
                switch response {
                case .success(let response):
                    
                    self.myProfileResponse = response
                    let firstName =  self.myProfileResponse?.data.firstName
                    let lastName =  self.myProfileResponse?.data.lastName
                    
                    DispatchQueue.main.async {
                        if let firstName = firstName, let lastName = lastName {
                            self.lblName.text = "\(firstName) \(lastName)"
                        }
                        let companyName = self.myProfileResponse?.data.companyName
                        if let companyName = companyName{
                            self.lblCompanyName.text = "\(companyName)"
                        }
                        if let imageUrl = self.myProfileResponse?.data.photo, !imageUrl.isEmpty{
                            let url = URL(string: imageBasePath + imageUrl)
                            self.headerImageView.kf.setImage(with: url)
                        }
                    }
                    self.eventHandler?(.dataLoaded)
                case .failure(let error):
                    self.eventHandler?(.error(error))
                }
            }
    }
}

// MARK: - UITableViewDelegate

extension SideMenuSubViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if self.menu[indexPath.row].title.isEmpty{
            return 40
        }
        return 25
    }
}

// MARK: - UITableViewDataSource

extension SideMenuSubViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.menu.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SideMenuCell.identifier, for: indexPath) as? SideMenuCell else { fatalError("xib doesn't exist") }
        
        cell.selectionStyle = .none
        cell.titleLabel.text = self.menu[indexPath.row].title
        // Add horizontal line after every 2 rows
        if self.menu[indexPath.row].title.isEmpty {
            cell.horizontalLineView.isHidden = false
        }else{
            cell.horizontalLineView.isHidden = true
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        
        let title = self.menu[indexPath.row].title
        if title.isEmpty == false{
            self.delegate?.selectedCell(indexPath.row, menuTitle: title)
        }
    }
}
extension SideMenuSubViewController {
    enum Event {
        case loading
        case stopLoading
        case dataLoaded
        case error(Error?)
    }
}
