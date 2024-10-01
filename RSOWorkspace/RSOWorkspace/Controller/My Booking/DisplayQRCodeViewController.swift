//
//  DisplayQRCodeViewController.swift
//  RSOWorkspace
//
//  Created by Sumit Aquil on 26/07/24.
//

import UIKit
import Kingfisher

class DisplayQRCodeViewController: UIViewController {

    @IBOutlet weak var QRCodeView: UIView!

    @IBOutlet weak var imgQRCode: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        QRCodeView.setCornerRadiusForView()
        
    }

    @IBAction func btnHideViewTappedAction(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
//    func setQRCodeImage(item: MeetingBooking) {
//
//        
//           if let imgUrl = item.qrCodeUrl, !imgUrl.isEmpty {
//               if let imageUrl = URL(string: imgUrl) {
//                   imgQRCode.kf.setImage(with: imageUrl, options: [.forceRefresh])
//               }
//           } else {
//               imgQRCode.image = UIImage(named: "dummyQRCode")
//           }
//    }
    func setQRCodeImage(item: MeetingBooking) {
            // Debugging print to check MeetingBooking item
            print("Setting QR code image for MeetingBooking: \(item)")
            
            guard let qrCodeURLString = item.qrCodeUrl else {
                print("QR Code URL is nil") // Debugging print
                return
            }

            guard let qrCodeURL = URL(string: qrCodeURLString) else {
                print("Invalid QR Code URL: \(qrCodeURLString)") // Debugging print
                return
            }

            print("QR Code URL is valid: \(qrCodeURL)") // Debugging print
            loadQRCodeImage(from: qrCodeURL)
        }

        private func loadQRCodeImage(from url: URL) {
            let task = URLSession.shared.dataTask(with: url) { data, response, error in
                guard let data = data, error == nil else {
                    print("Error fetching QR code image: \(error?.localizedDescription ?? "Unknown error")")
                    return
                }

                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self.imgQRCode.image = image // Update UI on the main thread
                    }
                } else {
                    print("Unable to create image from data")
                }
            }
            task.resume() // Start the data task
        }
}
