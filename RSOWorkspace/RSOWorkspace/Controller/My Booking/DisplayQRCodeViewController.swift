import UIKit
import Kingfisher

class DisplayQRCodeViewController: UIViewController {

    @IBOutlet weak var QRCodeView: UIView!
    @IBOutlet weak var lblitemName: UILabel!
    @IBOutlet weak var imgQRCode: UIImageView!
    @IBOutlet weak var lblStarttime: UILabel!
    @IBOutlet weak var lblEndTime: UILabel!
    
    var bookingItem: MeetingBooking? // Store booking item to set later

    override func viewDidLoad() {
        super.viewDidLoad()
        QRCodeView.setCornerRadiusForView()

        // Ensure booking item is set and populate the UI
        if let item = bookingItem {
            setupUI(with: item)
        }
    }

    @IBAction func btnHideViewTappedAction(_ sender: Any) {
        self.dismiss(animated: true)
    }

    func setQRCodeImage(item: MeetingBooking) {
        // Store the item, so we can populate the UI after view is loaded
        self.bookingItem = item
    }

    private func setupUI(with item: MeetingBooking) {
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

        if let startDateString = item.startTime {
            let startDate =  Date.dateFromString(startDateString, format: .HHmmss)
            self.lblStarttime.text = Date.formatSelectedDate(format: .hhmma, date: startDate)
        }
        if let endDateString = item.endTime {
            let endDate =  Date.dateFromString(endDateString, format: .HHmmss)
            self.lblEndTime.text = Date.formatSelectedDate(format: .hhmma, date: endDate)
        }
      
        if item.listType == "meeting"
        {
            self.lblitemName.text = "\(item.roomName ?? "")"

        }else {
            self.lblitemName.text =  "Desk No \(item.deskNo ?? "")"
        }
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
