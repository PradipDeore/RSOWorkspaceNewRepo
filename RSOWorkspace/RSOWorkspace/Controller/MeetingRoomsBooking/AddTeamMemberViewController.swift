//
//  AddTeamMemberViewController.swift
//  RSOWorkspace
//
//  Created by Sumit Aquil on 05/03/24.
//

import UIKit

protocol sendteamMemberNameDelegate:AnyObject{
    func sendteamMemberName(member: TeamMembersList)
}
class AddTeamMemberViewController: UIViewController {
    
    var teamMemberNameDelegate:sendteamMemberNameDelegate?

    @IBOutlet weak var txtSearchTeamMember: RSOTextField!
    @IBOutlet weak var btnAdd: RSOButton!
    var cornerRadius: CGFloat = 10.0
    var allTeamMembers: [TeamMembersList] = []
    @IBOutlet weak var searchView: UIView!
    var meetingroomName = ""
    var teamMemberName = ""
    var selectedFilteredTeamMembersIndex = -1
    var suggestionsTableView: UITableView!
    var filteredTeamMembers = [TeamMembersList]()
    var isDropdownVisible = false
        
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupSuggestionsTableView()
        txtSearchTeamMember.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)

    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        btnAdd.alpha = 0.5
        btnAdd.isUserInteractionEnabled = false
    }
    func setupUI() {
           btnAdd.layer.cornerRadius = btnAdd.bounds.height / 2
           txtSearchTeamMember.placeholderText = "Search Team Member"
           txtSearchTeamMember.customBackgroundColor = .F_2_F_2_F_2
           txtSearchTeamMember.placeholderColor = ._000000
           txtSearchTeamMember.placeholderFont = RSOFont.poppins(size: 16, type: .Medium)
           txtSearchTeamMember.customBorderWidth = 0.0
           customizeCell()
       }
   
    func setupSuggestionsTableView() {
        suggestionsTableView = UITableView()
           suggestionsTableView.translatesAutoresizingMaskIntoConstraints = false
           view.addSubview(suggestionsTableView)
           
           // Set constraints or frame
           NSLayoutConstraint.activate([
               suggestionsTableView.topAnchor.constraint(equalTo: txtSearchTeamMember.bottomAnchor),
               suggestionsTableView.leadingAnchor.constraint(equalTo: txtSearchTeamMember.leadingAnchor),
               suggestionsTableView.trailingAnchor.constraint(equalTo: txtSearchTeamMember.trailingAnchor),
               suggestionsTableView.heightAnchor.constraint(equalToConstant: 150) // Adjust as needed
           ])
           
           // Set delegate and dataSource
           suggestionsTableView.delegate = self
           suggestionsTableView.dataSource = self
           
        
        // Additional setup
        if let tableView = suggestionsTableView {
            tableView.isHidden = true
        } else {
            print("suggestionsTableView is nil")
            
        }
    }
       
       func customizeCell() {
           searchView.layer.cornerRadius = cornerRadius
           searchView.layer.masksToBounds = true
           
           let shadowColor = UIColor.black.withAlphaComponent(0.5)
           searchView.layer.shadowColor = shadowColor.cgColor
           searchView.layer.shadowOffset = CGSize(width: 0, height: 4.0)
           searchView.layer.shadowRadius = 10.0
           searchView.layer.shadowOpacity = 0.19
           searchView.layer.masksToBounds = false
           searchView.layer.shadowPath = UIBezierPath(roundedRect:  CGRect(x: 0, y: searchView.bounds.height - 4, width: searchView.bounds.width, height: 4), cornerRadius: searchView.layer.cornerRadius).cgPath
       }
      
    @objc func textFieldDidChange() {
        guard let query = txtSearchTeamMember.text, !query.isEmpty else {
            filteredTeamMembers.removeAll()
            isDropdownVisible = false
            suggestionsTableView.isHidden = true
            suggestionsTableView.reloadData()
            return
        }
        btnAdd.alpha = 1.0
        btnAdd.isUserInteractionEnabled = true

        filteredTeamMembers = allTeamMembers.filter { $0.first_name?.lowercased().contains(query.lowercased()) ?? false }
        isDropdownVisible = !filteredTeamMembers.isEmpty
        suggestionsTableView.isHidden = !isDropdownVisible
        suggestionsTableView.reloadData()
    }

    @IBAction func btnHideViewTappedAction(_ sender: Any) {
       dismiss(animated: true)
       
    }
    @IBAction func btnAddTeamMemberTappedAction(_ sender: Any) {
        if selectedFilteredTeamMembersIndex < filteredTeamMembers.count {
            let teamMember = filteredTeamMembers[selectedFilteredTeamMembersIndex]
                teamMemberNameDelegate?.sendteamMemberName(member: teamMember)
                dismiss(animated: true)
            } else {
                // Handle the case where no name is entered
                // For example, show an alert
                let alert = UIAlertController(title: "No Team Member Selected", message: "Please select a team member from the list.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                present(alert, animated: true, completion: nil)
            }
            
        }
}

// MARK: - UITextFieldDelegate

extension AddTeamMemberViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if !filteredTeamMembers.isEmpty {
            isDropdownVisible = true
            suggestionsTableView.isHidden = false
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

extension AddTeamMemberViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredTeamMembers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
        let teamMember = filteredTeamMembers[indexPath.row]
        cell.textLabel?.text = teamMember.fullName
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let teamMember = filteredTeamMembers[indexPath.row]
        selectedFilteredTeamMembersIndex = indexPath.row
        txtSearchTeamMember.text = teamMember.fullName
        isDropdownVisible = false
        suggestionsTableView.isHidden = true
    }
    
    // Hide dropdown when tapping outside
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
        isDropdownVisible = false
        suggestionsTableView.isHidden = true
    }
}
