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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setValuesforTextFileds()
        customizeCell()
        imgProfile.setRounded()
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
        txtFirstName.customBorderWidth = 0.0
        
        txtLastname.placeholderFont = RSOFont.inter(size: 16, type: .Medium)
        txtLastname.customBorderWidth = 0.0
        
        txtDesignation.placeholderFont = RSOFont.inter(size: 16, type: .Medium)
        txtDesignation.customBorderWidth = 0.0
        
    }
    
//    func updateProfileAPI(fname: String?, lname: String?, designation: String?, photo: Data?) {
//           RSOLoader.showLoader()
//           let photoBase64 = photo?.base64EncodedString() // Convert image data to base64 string
//           let requestModel = UpdateProfileRequestModel(first_name: fname, last_name: lname, designation: designation, photo: photoBase64)
//           print("requestModel", requestModel)
//           APIManager.shared.request(
//               modelType: UpdateProfileResponse.self,
//               type: MyProfileEndPoint.updateProfile(requestModel: requestModel)) { response in
//                   
//                   switch response {
//                   case .success(let response):
//                       self.updateProfileResponseData = response
//                       UserHelper.shared.saveUserFirstName(firstName: fname)
//                       UserHelper.shared.saveUserLastName(lastName: lname)
//                       UserHelper.shared.saveUserDesignation(designation: designation)
//                       DispatchQueue.main.async {
//                           RSOLoader.removeLoader()
//                           self.dismissDelegate?.subviewDismmised()
//                           RSOToastView.shared.show("\(response.message)", duration: 2.0, position: .center)
//                       }
//                       DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
//                           self.dismiss(animated: true, completion: nil)
//                       }
//                       self.eventHandler?(.dataLoaded)
//                   case .failure(let error):
//                       self.eventHandler?(.error(error))
//                       DispatchQueue.main.async {
//                           RSOLoader.removeLoader()
//                           RSOToastView.shared.show("\(error.localizedDescription)", duration: 2.0, position: .center)
//                       }
//                   }
//               }
//       }

    func updateProfileAPI(fname: String?, lname: String?, designation: String?, photo: Data?) {
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
        body.append("\(firstName)\r\n".data(using: .utf8)!)
        
        // Append last name
        body.append("--\(boundary)\r\n".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"last_name\"\r\n\r\n".data(using: .utf8)!)
        body.append("\(lastName)\r\n".data(using: .utf8)!)
        
        // Append designation
        body.append("--\(boundary)\r\n".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"designation\"\r\n\r\n".data(using: .utf8)!)
        body.append("\(designation ?? "")\r\n".data(using: .utf8)!)
        
        // Append photo
        let photoData = photo!
        body.append("--\(boundary)\r\n".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"photo\"; filename=\"test.png\"\r\n".data(using: .utf8)!)
        body.append("Content-Type: image/png\r\n\r\n".data(using: .utf8)!)
        body.append(photoData)
        body.append("\r\n".data(using: .utf8)!)
        
        // Append the final boundary
        body.append("--\(boundary)--\r\n".data(using: .utf8)!)
        
        // Set the request body
        request.httpBody = body
        
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
                           UserHelper.shared.saveUserDesignation(designation: designation)
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
        let fname = txtFirstName.text
        let lname = txtLastname.text
        let designation = txtDesignation.text
        updateProfileAPI(fname: fname, lname: lname, designation: designation, photo: selectedImageData)
        
    }
}
    extension UpdateProfileViewController {
        enum Event {
            case dataLoaded
            case error(Error?)
        }
    }

