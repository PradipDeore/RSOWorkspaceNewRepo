//
//  ReportAnIssueViewController.swift
//  RSOWorkspace
//
//  Created by Sumit Aquil on 18/03/24.
//

import UIKit

class ReportAnIssueViewController: UIViewController {
    
    var coordinator: RSOTabBarCordinator?
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var tableView: UITableView!
    var cornerRadius: CGFloat = 10.0
    var location: [LocationDetails] = []
    var dropdownOptions: [LocationDetails] = []
    var eventHandler: ((_ event: Event) -> Void)?
    var reportAnIssueRespnseData: ReportAnIssueResponse?
    var location_id = 0
    var descriptionOfIssue = ""
    var selectedLocation = ""
    var selectedImage: UIImage? // Store selected image here

    
    enum Section: Int, CaseIterable {
        case selectArea = 0
        case addPics
        case provideDetails
        case requestButton
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        coordinator?.hideBackButton(isHidden:false)
        coordinator?.setTitle(title: "Concierge")
        
        customizeCell()
        setupTableView()
        fetchLocations()
    }
    
    func customizeCell() {
        self.containerView.layer.cornerRadius = cornerRadius
        self.containerView.layer.masksToBounds = true
        self.containerView.addShadow()
    }
    
    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "SelectAnAreaTableViewCell", bundle: nil), forCellReuseIdentifier: "SelectAnAreaTableViewCell")
        tableView.register(UINib(nibName: "AddPicsTableViewCell", bundle: nil), forCellReuseIdentifier: "AddPicsTableViewCell")
        tableView.register(UINib(nibName: "ProvideDetailsOfIssueTableViewCell", bundle: nil), forCellReuseIdentifier: "ProvideDetailsOfIssueTableViewCell")
        tableView.register(UINib(nibName: "RequestButtonTableViewCell", bundle: nil), forCellReuseIdentifier: "RequestButtonTableViewCell")
    }
    private func fetchLocations() {
        APIManager.shared.request(
            modelType: LocationResponse.self, // Assuming your API returns an array of locations
            type: LocationEndPoint.locations) { response in
                switch response {
                case .success(let response):
                    self.dropdownOptions = response.data ?? []
                    DispatchQueue.main.async {
                        if let selectedOption = self.dropdownOptions.first {
                              self.location_id = selectedOption.id ?? 1
                             self.selectedLocation = selectedOption.name ?? "Reef Tower"
                          }
                        self.tableView.reloadData()
                    }
                    self.eventHandler?(.dataLoaded)
                case .failure(let error):
                    self.eventHandler?(.error(error))
                }
            }
    }
//    func reportAnIssueAPI(locationid :Int,description:String) {
//        let requestModel = ReportAnIssueRequestModel(location_id: locationid,  description: description)
//        print("requestModel",requestModel)
//        APIManager.shared.request(
//            modelType: ReportAnIssueResponse.self,
//            type: ServicesEndPoint.reportAnIssue(requestModel: requestModel)) { response in
//                switch response {
//                case .success(let response):
//                    self.reportAnIssueRespnseData = response
//                    //record inserted successfully
//                    DispatchQueue.main.async {
//                        RSOToastView.shared.show("\(response.message)", duration: 3.0, position: .center)
//                        
//                        // Reset the form
//                        self.resetForm()
//                    }
//                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
//                        self.dismiss(animated: true, completion: nil)
//                    }
//                    self.eventHandler?(.dataLoaded)
//                case .failure(let error):
//                    self.eventHandler?(.error(error))
//                    DispatchQueue.main.async {
//                        //  Unsuccessful
//                        RSOToastView.shared.show("\(error.localizedDescription)", duration: 2.0, position: .center)
//                    }
//                }
//            }
//    }
//    
    
    func reportAnIssueAPI(locationId: Int, image: UIImage?, description: String) {
        guard let image = image else {
            RSOToastView.shared.show("Please select an image", duration: 2.0, position: .center)
            return
        }
        // URL of the API endpoint
        guard let url = URL(string: Configuration.shared.baseURL)?.appendingPathComponent("report-issue") else { return }
        
        let token = RSOToken.shared.getToken() ?? ""
        // Create the request
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        let boundary = UUID().uuidString
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")


        let httpBody = createMultipartBody(locationId: locationId, image: image, description: description, boundary: boundary)
        request.httpBody = httpBody
        print("Request Headers: \(request.allHTTPHeaderFields ?? [:])")
           print("Request Parameters: locationId: \(locationId), description: \(description)")
        let session = URLSession.shared
        let task = session.dataTask(with: request) { (data, response, error) in
            guard let data = data, error == nil else {
                DispatchQueue.main.async {
                    self.eventHandler?(.error(error))
                    RSOToastView.shared.show("Upload failed: \(error?.localizedDescription ?? "Unknown error")", duration: 2.0, position: .center)
                }
                return
            }
            
            // Log the raw response to debug the issue
            if let httpResponse = response as? HTTPURLResponse {
                print("Status Code: \(httpResponse.statusCode)")
            }

            // Log the raw response data
            if let jsonString = String(data: data, encoding: .utf8) {
                print("Raw Response Data: \(jsonString)")
            }

            // Attempt to parse the data
            do {
                let decoder = JSONDecoder()
                let responseModel = try decoder.decode(ReportAnIssueResponse.self, from: data)
                DispatchQueue.main.async {
                    self.reportAnIssueRespnseData = responseModel
                    RSOToastView.shared.show("\(responseModel.message)", duration: 3.0, position: .center)
                    self.resetForm()
                    self.dismiss(animated: true, completion: nil)
                    self.eventHandler?(.dataLoaded)
                }
                // Log successful response model
            print("Parsed Response: \(responseModel)")
            } catch {
                DispatchQueue.main.async {
                    // Show parsing error in the UI
                    RSOToastView.shared.show("Parsing error: \(error.localizedDescription)", duration: 2.0, position: .center)
                }
            }
        }

        task.resume()
    }


       func createMultipartBody(locationId: Int, image: UIImage, description: String, boundary: String) -> Data {
           var body = Data()

           // Add location_id
           body.append("--\(boundary)\r\n".data(using: .utf8)!)
           body.append("Content-Disposition: form-data; name=\"location_id\"\r\n\r\n".data(using: .utf8)!)
           body.append("\(locationId)\r\n".data(using: .utf8)!)

           // Add description
           body.append("--\(boundary)\r\n".data(using: .utf8)!)
           body.append("Content-Disposition: form-data; name=\"description\"\r\n\r\n".data(using: .utf8)!)
           body.append("\(description)\r\n".data(using: .utf8)!)

           // Add image data
              if let imageData = image.jpegData(compressionQuality: 0.7) {
                  body.append("--\(boundary)\r\n".data(using: .utf8)!)
                  body.append("Content-Disposition: form-data; name=\"image\"; filename=\"issueImage.jpg\"\r\n".data(using: .utf8)!)
                  body.append("Content-Type: image/jpeg\r\n\r\n".data(using: .utf8)!)
                  body.append(imageData)
                  body.append("\r\n".data(using: .utf8)!)
              } else {
                  print("Failed to convert image to JPEG format.")
              }
           // End boundary
           body.append("--\(boundary)--\r\n".data(using: .utf8)!)

           return body
       }

       func resetForm() {
           location_id = 0
           descriptionOfIssue = ""
           dropdownOptions = []
           selectedImage = nil
           
           // Reset images in the AddPicsTableViewCell
           if let cell = tableView.cellForRow(at: IndexPath(row: 0, section: Section.addPics.rawValue)) as? AddPicsTableViewCell {
               cell.resetImages()
           }
           // Reset the description text field in ProvideDetailsOfIssueTableViewCell
           if let provideDetailsCell = tableView.cellForRow(at: IndexPath(row: 0, section: Section.provideDetails.rawValue)) as? ProvideDetailsOfIssueTableViewCell {
               provideDetailsCell.textFieldView.text = ""
               provideDetailsCell.descriptionText = ""
           }
           tableView.reloadData()
       }
}

extension ReportAnIssueViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return Section.allCases.count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 5
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView()
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let section = Section(rawValue: indexPath.section) else { return UITableViewCell() }
        switch section {
        case .selectArea:
            let cell = tableView.dequeueReusableCell(withIdentifier: "SelectAnAreaTableViewCell", for: indexPath) as! SelectAnAreaTableViewCell
            cell.delegate = self
            cell.dropdownOptions = dropdownOptions
            cell.selectionStyle = .none
            cell.txtSelectAnArea.text = selectedLocation
            return cell
        case .addPics:
            let cell = tableView.dequeueReusableCell(withIdentifier: "AddPicsTableViewCell", for: indexPath) as! AddPicsTableViewCell
            cell.delegate = self
            cell.selectionStyle = .none
            return cell
        case .provideDetails:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProvideDetailsOfIssueTableViewCell", for: indexPath) as! ProvideDetailsOfIssueTableViewCell
            cell.delegate = self
            cell.selectionStyle = .none
            return cell
        case .requestButton:
            let cell = tableView.dequeueReusableCell(withIdentifier: "RequestButtonTableViewCell", for: indexPath) as! RequestButtonTableViewCell
            cell.delegate = self
            cell.selectionStyle = .none
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let section = Section(rawValue: indexPath.section) else { return 0 }
        switch section {
        case .selectArea:
            return 60
        case .addPics:
            return 130
        case .provideDetails:
            return 138
        case .requestButton:
            return 60
        }
    }
}
extension ReportAnIssueViewController: SelectAnAreaTableViewCellDelegate {
    
    func dropdownButtonTapped(selectedOption: LocationDetails) {
        // Implement what you want to do with the selected option, for example:
        print("Selected option: \(selectedOption.name),\(selectedOption.id)")
        self.selectedLocation = selectedOption.name ?? "Reef Tower"
        location_id = selectedOption.id ?? 1
    }
    
    func presentAlertController(alertController: UIAlertController) {
        // Present the alert controller from the view controller
        present(alertController, animated: true, completion: nil)
    }
}
extension ReportAnIssueViewController:DescriptionDelegate{
    func sendDescription(txtDescription: String) {
        descriptionOfIssue = txtDescription
    }
}

extension ReportAnIssueViewController:RequestButtonTableViewCellDelegate{
    func requestButtonTapped() {
        // Validate the required fields
        guard location_id != 0, !descriptionOfIssue.isEmpty else {
            RSOToastView.shared.show("All fields are required", duration: 2.0, position: .center)
            return
        }
        reportAnIssueAPI(locationId: location_id, image: selectedImage, description: descriptionOfIssue)

    }
}

extension ReportAnIssueViewController {
    enum Event {
        
        case dataLoaded
        case error(Error?)
    }
}
extension ReportAnIssueViewController:AddPicsTableViewCellDelegate{
    func openGallery() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }
}
extension ReportAnIssueViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            picker.dismiss(animated: true, completion: nil)
            
            if let image = info[.originalImage] as? UIImage {
                // Save the selected image
                self.selectedImage = image
                
                // Display the selected image in the AddPicsTableViewCell
                if let cell = tableView.cellForRow(at: IndexPath(row: 0, section: Section.addPics.rawValue)) as? AddPicsTableViewCell {
                    cell.displayPhoto(image)
                }
            }
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            picker.dismiss(animated: true, completion: nil)
        }
}
