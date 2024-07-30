//
//  FeedbackViewController.swift
//  RSOWorkspace
//
//  Created by Sumit Aquil on 01/04/24.
//

import UIKit

class FeedbackViewController: UIViewController {
    
    @IBOutlet weak var imgExcellent: UIImageView!
    @IBOutlet weak var imgGood: UIImageView!
    @IBOutlet weak var imgAverage: UIImageView!
    @IBOutlet weak var imgPoor: UIImageView!
    @IBOutlet weak var imgVeryPoor: UIImageView!
    
    @IBOutlet weak var provideDetailsTextView: UITextView!
    
    var feedbackResponseData:  FeedbackResponseModel?
    var selectedFeedbackType: String?
    var eventHandler: ((_ event: Event) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        provideDetailsTextView.addPlaceholder(text: "Please provide any details")
        setUpImageViews()
    }
    private func setUpImageViews() {
        let tapExcellent = UITapGestureRecognizer(target: self, action: #selector(imageTapped(_:)))
        let tapGood = UITapGestureRecognizer(target: self, action: #selector(imageTapped(_:)))
        let tapAverage = UITapGestureRecognizer(target: self, action: #selector(imageTapped(_:)))
        let tapPoor = UITapGestureRecognizer(target: self, action: #selector(imageTapped(_:)))
        let tapVeryPoor = UITapGestureRecognizer(target: self, action: #selector(imageTapped(_:)))
        
        imgExcellent.addGestureRecognizer(tapExcellent)
        imgGood.addGestureRecognizer(tapGood)
        imgAverage.addGestureRecognizer(tapAverage)
        imgPoor.addGestureRecognizer(tapPoor)
        imgVeryPoor.addGestureRecognizer(tapVeryPoor)
        
        imgExcellent.isUserInteractionEnabled = true
        imgGood.isUserInteractionEnabled = true
        imgAverage.isUserInteractionEnabled = true
        imgPoor.isUserInteractionEnabled = true
        imgVeryPoor.isUserInteractionEnabled = true
        
        imgExcellent.tag = 1
        imgGood.tag = 2
        imgAverage.tag = 3
        imgPoor.tag = 4
        imgVeryPoor.tag = 5
        
    }
    
    @objc private func imageTapped(_ sender: UITapGestureRecognizer) {
        guard let tag = sender.view?.tag else { return }
        switch tag {
        case 1:
            selectedFeedbackType = "Excellent"
        case 2:
            selectedFeedbackType = "Good"
        case 3:
            selectedFeedbackType = "Average"
        case 4:
            selectedFeedbackType = "Poor"
        case 5:
            selectedFeedbackType = "Very Poor"
        default:
            selectedFeedbackType = nil
        }
        
        // Optionally, you could update the UI to reflect the selected state
        updateSelectedState()
    }
    
    private func updateSelectedState() {
        // Reset all image views to default state
        // Optionally, you could change the image or border to indicate the selected state
        let images = [imgExcellent, imgGood, imgAverage, imgPoor, imgVeryPoor]
        for imageView in images {
            imageView?.layer.borderWidth = 0
            imageView?.layer.borderColor = UIColor.clear.cgColor
        }
        
        // Highlight the selected image
        switch selectedFeedbackType {
        case "Excellent":
            imgExcellent.layer.borderWidth = 2
            imgExcellent.layer.borderColor = UIColor.lightGray.cgColor
        case "Good":
            imgGood.layer.borderWidth = 2
            imgGood.layer.borderColor = UIColor.lightGray.cgColor
        case "Average":
            imgAverage.layer.borderWidth = 2
            imgAverage.layer.borderColor = UIColor.lightGray.cgColor
        case "Poor":
            imgPoor.layer.borderWidth = 2
            imgPoor.layer.borderColor = UIColor.lightGray.cgColor
        case "Very Poor":
            imgVeryPoor.layer.borderWidth = 2
            imgVeryPoor.layer.borderColor = UIColor.lightGray.cgColor
        default:
            break
        }
    }
    func feebackStoreAPI(feedback_type: String, comments: String) {
        RSOLoader.showLoader()
        let requestModel = FeedbackRequestModel(feedback_type: feedback_type, comments: comments)
        print("requestModel", requestModel)
        APIManager.shared.request(
            modelType: FeedbackResponseModel.self,
            type: NotificationEndPoint.feedback(requestModel: requestModel)) { response in
                switch response {
                case .success(let response):
                    self.feedbackResponseData = response
                    DispatchQueue.main.async {
                        RSOLoader.removeLoader()
                        RSOToastView.shared.show("\(response.message ?? "")", duration: 2.0, position: .center)
                        self.clearFields()
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                            self.dismiss(animated: true, completion: nil)
                        }
                        self.eventHandler?(.dataLoaded)
                    }
                case .failure(let error):
                    DispatchQueue.main.async {
                        RSOLoader.removeLoader()
                        RSOToastView.shared.show("\(error.localizedDescription)", duration: 2.0, position: .center)
                        self.eventHandler?(.error(error))
                    }
                }
            }
    }
    private func clearFields() {
        DispatchQueue.main.async {
            self.provideDetailsTextView.text = ""
            self.selectedFeedbackType = nil
            self.updateSelectedState()
        }
    }
    @IBAction func btnBackAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
        
    }
    @IBAction func btnSubmitActionTapped(_ sender: Any) {
        guard let feedbackType = selectedFeedbackType else {
            RSOToastView.shared.show("Please select a feedback type", duration: 2.0, position: .center)
            return
        }
        
        let comments = provideDetailsTextView.text ?? ""
        feebackStoreAPI(feedback_type: feedbackType, comments: comments)
    }
    
}
    
extension FeedbackViewController {
    enum Event {
        case dataLoaded
        case error(Error?)
    }
}

