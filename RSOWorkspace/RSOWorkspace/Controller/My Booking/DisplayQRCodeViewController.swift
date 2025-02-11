import UIKit
import Kingfisher

class DisplayQRCodeViewController: UIViewController {
    
    @IBOutlet weak var QRCodeView: UIView!
    @IBOutlet weak var lblitemName: UILabel!
    @IBOutlet weak var imgQRCode: UIImageView!
    @IBOutlet weak var lblStarttime: UILabel!
    @IBOutlet weak var lblEndTime: UILabel!
    
    var bookingItem: MeetingBooking? // Store booking item to set later
    var bookingItemEnterpriseDetail: EnterpriseAllBookingsResponseModel? // Store a single booking detail
    
    override func viewDidLoad() {
        super.viewDidLoad()
        QRCodeView.setCornerRadiusForView()
        
        if let item = bookingItem {
            setupUI(with: item)
        }
        if let enterpriseItem = bookingItemEnterpriseDetail {
            setupUIEnterprise(with: enterpriseItem)
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
        
        
        
        if let startDateString = item.startTime {
            print("Start Time String: \(startDateString)")
            let startDate =  Date.dateFromString(startDateString, format: .HHmmss)
            self.lblStarttime.text = Date.formatSelectedDate(format: .hhmma, date: startDate)
        }else {
            print("Start Time is nil") // Debugging print
        }
        if let endDateString = item.endTime {
            print("End Time String: \(endDateString)")
            let endDate =  Date.dateFromString(endDateString, format: .HHmmss)
            self.lblEndTime.text = Date.formatSelectedDate(format: .hhmma, date: endDate)
        }else {
            print("End Time is nil") // Debugging print
        }
        
        if item.listType == "meeting"
        {
            self.lblitemName.text = "\(item.roomName ?? "")"
            
        }else {
            self.lblitemName.text =  "Desk No \(item.deskNo ?? "")"
        }
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
    
    func setQRCodeImageEnterprise(item: EnterpriseAllBookingDetails) {
        self.bookingItemEnterpriseDetail = EnterpriseAllBookingsResponseModel(
            status: nil,
            data: [item],
            lastPage: nil,
            perPage: nil,
            currentPage: nil,
            total: nil,
            qrCodeURL: nil)
    }
    
    private func setupUIEnterprise(with item: EnterpriseAllBookingsResponseModel) {
        // Debugging print to check MeetingBooking item
        print("Setting QR code image for MeetingBooking: \(item)")
        
        
        
        if let startDateString = item.data?.first?.startTime {
            let startDate =  Date.dateFromString(startDateString, format: .HHmmss)
            self.lblStarttime.text = Date.formatSelectedDate(format: .hhmma, date: startDate)
        }
        if let endDateString = item.data?.first?.endTime {
            let endDate =  Date.dateFromString(endDateString, format: .HHmmss)
            self.lblEndTime.text = Date.formatSelectedDate(format: .hhmma, date: endDate)
        }
        
        self.lblitemName.text = "\(item.data?.first?.roomName ?? "")"
        
        guard let qrCodeURLString = item.qrCodeURL else {
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
            }
        }
        task.resume() // Start the data task
    }
}
