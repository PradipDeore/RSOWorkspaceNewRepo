//
//  UpdateProfileViewController.swift
//  RSOWorkspace
//
//  Created by Sumit Aquil on 11/04/24.
//

import UIKit
import Toast_Swift

class UpdateProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate  {
    
    @IBOutlet weak var containerView: UIView!
    var cornerRadius: CGFloat = 10.0
    weak var dismissDelegate: SubViewDismissalProtocol?
    @IBOutlet weak var txtFirstName: RSOTextField!
    @IBOutlet weak var txtLastname: RSOTextField!
    @IBOutlet weak var txtDesignation: RSOTextField!
    @IBOutlet weak var imgProfile: UIImageView!
    var firstName = ""
    var lastName = ""
    var designation = ""
    var imgphotoUrl = ""
    @IBOutlet weak var btnUpdate: RSOButton!
    var eventHandler: ((_ event: Event) -> Void)? // Data Binding Closure
    
    var updateProfileResponseData: UpdateProfileResponse?
    var selectedImageData: Data?
    
    @IBOutlet weak var btnEditPhoto: RSOButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        setValuesforTextFileds()
        customizeCell()
        imgProfile.setRounded()
        setCameraButton()
        
    }
    func setCameraButton(){
        btnEditPhoto.setCornerRadiusToButton()
        btnEditPhoto.backgroundColor = .B_9_D_0_AA
        btnEditPhoto.tintColor = .black
    }
    
    @IBAction func btnEditProfile(_ sender: Any) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = true
        present(imagePicker, animated: true, completion: nil)
        
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let editedImage = info[.editedImage] as? UIImage {
            imgProfile.image = editedImage
            selectedImageData = editedImage.jpegData(compressionQuality: 0.5) // Adjust compression if needed
            
        }
        dismiss(animated: true, completion: nil)
    }
    func setValuesforTextFileds(){
        
        print("Setting values for text fields")
        print("firstName:", firstName)
        print("lastName:", lastName)
        print("designation:", designation)
        
        if !imgphotoUrl.isEmpty {
            let url = URL(string: imageBasePath + imgphotoUrl)
            self.imgProfile.kf.setImage(with: url)
        }
        txtFirstName.text = firstName
        txtLastname.text = lastName
        txtDesignation.text = designation
        
        txtFirstName.placeholderFont = RSOFont.inter(size: 16, type: .Medium)
        txtLastname.placeholderFont = RSOFont.inter(size: 16, type: .Medium)
        txtDesignation.placeholderFont = RSOFont.inter(size: 16, type: .Medium)
        
    }
    
    
    func updateProfileAPI(fname: String, lname: String, designationName: String, photo: Data?) {
        // URL of the API endpoint
        let url = URL(string: "https://finance.ardemos.co.in/rso/api/update-profile")!
        let token = RSOToken.shared.getToken() ?? ""
        // Create the request
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        // Boundary string
        let boundary = "Boundary-\(UUID().uuidString)"
        
        // Set content-type
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        // Create the body data
        var body = Data()
        
        // Append first name
        body.append("--\(boundary)\r\n".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"first_name\"\r\n\r\n".data(using: .utf8)!)
        body.append("\(fname)\r\n".data(using: .utf8)!)
        
        // Append last name
        body.append("--\(boundary)\r\n".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"last_name\"\r\n\r\n".data(using: .utf8)!)
        body.append("\(lname)\r\n".data(using: .utf8)!)
        
        // Append designation
        body.append("--\(boundary)\r\n".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"designation\"\r\n\r\n".data(using: .utf8)!)
        body.append("\(designationName)\r\n".data(using: .utf8)!)
        
        // Append photo
        if let photoData = photo {
            // Convert photo data to image if necessary
            if UIImage(data: photoData) != nil {
                body.append("--\(boundary)\r\n".data(using: .utf8)!)
                body.append("Content-Disposition: form-data; name=\"photo\"; filename=\"profile_photo.png\"\r\n".data(using: .utf8)!)
                body.append("Content-Type: image/png\r\n\r\n".data(using: .utf8)!)
                body.append(photoData)
                body.append("\r\n".data(using: .utf8)!)
            }
        }
        
        // Append the final boundary
        body.append("--\(boundary)--\r\n".data(using: .utf8)!)
        
        // Set the request body
        request.httpBody = body
        
        printRequestDetails(request)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                DispatchQueue.main.async {
                    RSOLoader.removeLoader()
                    RSOToastView.shared.show("Error: \(error.localizedDescription)", duration: 2.0, position: .center)
                }
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                DispatchQueue.main.async {
                    RSOLoader.removeLoader()
                    RSOToastView.shared.show("Server error", duration: 2.0, position: .center)
                }
                return
            }
            
            if let data = data {
                do {
                    // Decode the response data into UpdateProfileResponse
                    let decoder = JSONDecoder()
                    let responseObject = try decoder.decode(UpdateProfileResponse.self, from: data)
                    
                    DispatchQueue.main.async {
                        self.updateProfileResponseData = responseObject
                        UserHelper.shared.saveUserFirstName(firstName: fname)
                        UserHelper.shared.saveUserLastName(lastName: lname)
                        UserHelper.shared.saveUserDesignation(designation: self.designation)
                        RSOLoader.removeLoader()
                        self.dismissDelegate?.subviewDismmised()
                        RSOToastView.shared.show("\(responseObject.message)", duration: 2.0, position: .center)
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                            self.dismiss(animated: true, completion: nil)
                        }
                        self.eventHandler?(.dataLoaded)
                    }
                } catch {
                    DispatchQueue.main.async {
                        RSOLoader.removeLoader()
                        RSOToastView.shared.show("Decoding error: \(error.localizedDescription)", duration: 2.0, position: .center)
                    }
                }
            }
        }
        
        task.resume()
    }
    
    func printRequestDetails(_ request: URLRequest) {
        // Print the URL
        if let url = request.url {
            print("URL: \(url.absoluteString)")
        }
        
        // Print the HTTP method
        if let method = request.httpMethod {
            print("HTTP Method: \(method)")
        }
        
        // Print the headers
        if let headers = request.allHTTPHeaderFields {
            print("Headers: \(headers)")
        }
        
        // Print the body data as a string (if available)
        if let body = request.httpBody {
            if let bodyString = String(data: body, encoding: .utf8) {
                print("Body: \(bodyString)")
            } else {
                print("Body: \(body.count) bytes")
            }
        } else {
            print("No body data")
        }
    }
    func customizeCell(){
        self.containerView.layer.cornerRadius = cornerRadius
        self.containerView.layer.masksToBounds = true
        
        let shadowColor = UIColor.black.withAlphaComponent(0.5)
        self.containerView.layer.shadowColor = shadowColor.cgColor
        self.containerView.layer.shadowOffset = CGSize(width: 0, height: 4.0)
        self.containerView.layer.shadowRadius = 10.0
        self.containerView.layer.shadowOpacity = 19.0
        self.containerView.layer.masksToBounds = false
        self.containerView.layer.shadowPath = UIBezierPath(roundedRect:  CGRect(x: 0, y: self.containerView.bounds.height - 4, width: self.containerView.bounds.width, height: 4), cornerRadius: self.containerView.layer.cornerRadius).cgPath
    }
    
    @IBAction func btnDismissView(_ sender: Any) {
        dismiss(animated: true)
        
    }
    
    @IBAction func btnUpdateAction(_ sender: Any) {
        // Validate first name
        guard let fname = txtFirstName.text?.trimmingCharacters(in: .whitespacesAndNewlines), !fname.isEmpty else {
            RSOToastView.shared.show("First name cannot be empty", duration: 2.0, position: .center)
            return
        }
        guard RSOValidator.isValidName(fname) else {
            RSOToastView.shared.show("First name cannot contain numbers or special characters", duration: 2.0, position: .center)
            return
        }
        // Validate last name
        guard let lname = txtLastname.text?.trimmingCharacters(in: .whitespacesAndNewlines), !lname.isEmpty else {
            RSOToastView.shared.show("Last name cannot be empty", duration: 2.0, position: .center)
            return
        }
        guard RSOValidator.isValidName(lname) else {
            RSOToastView.shared.show("Last name cannot contain numbers or special characters", duration: 2.0, position: .center)
            return
        }
        
        // Validate designation
        guard let designation = txtDesignation.text?.trimmingCharacters(in: .whitespacesAndNewlines), !designation.isEmpty else {
            RSOToastView.shared.show("Designation cannot be empty", duration: 2.0, position: .center)
            return
        }
        guard RSOValidator.isValidName(designation) else {
            RSOToastView.shared.show("Designation cannot contain numbers or special characters", duration: 2.0, position: .center)
            return
        }
        // Proceed to update profile if all validations pass
        updateProfileAPI(fname: fname, lname: lname, designationName: designation, photo: selectedImageData)
    }
}
extension UpdateProfileViewController {
    enum Event {
        case dataLoaded
        case error(Error?)
    }
}

