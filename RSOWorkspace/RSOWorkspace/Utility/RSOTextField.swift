import Foundation
import UIKit

class RSOTextField: UITextField {
    
    var customBorderColor: UIColor = .black {
        didSet {
            layer.borderColor = customBorderColor.cgColor
        }
    }
    
    var customBorderWidth: CGFloat = 0.8{
        didSet {
            layer.borderWidth = customBorderWidth
        }
    }
    
    var customBackgroundColor: UIColor = .white {
        didSet {
            backgroundColor = customBackgroundColor
        }
    }
    var placeholderText: String? {
        didSet {
            attributedPlaceholder = NSAttributedString(string: placeholderText ?? "", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray]) // Customize placeholder color here if needed
        }
    }
    var placeholderColor: UIColor = .lightGray {
        didSet {
            updatePlaceholder()
        }
    }
    var placeholderFont: UIFont? {
        didSet {
            updatePlaceholder()
        }
    }
    
    // Left margin for the placeholder
    var leftPlaceholderMargin: CGFloat = 20.0 {
        didSet {
            updatePlaceholder()
        }
    }
    // MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupTextField()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupTextField()
    }
    
    // MARK: - Setup
    
    private func setupTextField() {
        self.textColor = .black
        self.layer.cornerRadius = 10.0 // Customize as per your requirement
        self.layer.borderColor = RSOColors.customGrayColor.cgColor
        self.layer.borderWidth = 1 //1.14
        self.font = RSOFont.inter(size: 16,type: .Regular)
        self.placeholderFont = RSOFont.inter(size: 16,type: .Regular)
        self.autocapitalizationType = .none
        //updatePlaceholder()
        let paddingView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 20))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
    
    
    private func updatePlaceholder() {
        guard let placeholderText = placeholderText else { return }
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.firstLineHeadIndent = leftPlaceholderMargin
        
        let attributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: placeholderColor,
            .font: placeholderFont as Any,
            .paragraphStyle: paragraphStyle
        ]
        
        attributedPlaceholder = NSAttributedString(string: placeholderText, attributes: attributes)
    }
}
class RSOTextFieldOfficeBooking: UITextField {
    
    var customBorderColor: UIColor = .black {
        didSet {
            layer.borderColor = customBorderColor.cgColor
        }
    }
    
    var customBorderWidth: CGFloat = 0.8{
        didSet {
            layer.borderWidth = customBorderWidth
        }
    }
    
    var customBackgroundColor: UIColor = .white {
        didSet {
            backgroundColor = customBackgroundColor
        }
    }
    var placeholderText: String? {
        didSet {
            attributedPlaceholder = NSAttributedString(string: placeholderText ?? "", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray]) // Customize placeholder color here if needed
        }
    }
    var placeholderColor: UIColor = .lightGray {
        didSet {
            updatePlaceholder()
        }
    }
    var placeholderFont: UIFont? {
        didSet {
            updatePlaceholder()
        }
    }
    
    // Left margin for the placeholder
    var leftPlaceholderMargin: CGFloat = 20.0 {
        didSet {
            updatePlaceholder()
        }
    }
    // MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupTextField()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupTextField()
    }
    
    // MARK: - Setup
    
    private func setupTextField() {
        self.textColor = .black
        self.layer.cornerRadius = 10.0 // Customize as per your requirement
        self.layer.borderColor = RSOColors.customTextFieldBorderColor.cgColor
        self.layer.borderWidth =  1
        self.font = RSOFont.inter(size: 16,type: .Regular)
        self.placeholderFont = RSOFont.inter(size: 16,type: .Regular)
        self.autocapitalizationType = .none
        //updatePlaceholder()
        let paddingView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 20))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
    
    
    private func updatePlaceholder() {
        guard let placeholderText = placeholderText else { return }
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.firstLineHeadIndent = leftPlaceholderMargin
        
        let attributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: placeholderColor,
            .font: placeholderFont as Any,
            .paragraphStyle: paragraphStyle
        ]
        
        attributedPlaceholder = NSAttributedString(string: placeholderText, attributes: attributes)
    }
}

extension UITextField {
    func addPasswordToggle(padding: CGFloat = 10.0) {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "password_icon_2"), for: .normal) // Set your show password image
        button.setImage(UIImage(named: "password_icon_1"), for: .selected) // Set your hide password image
        button.addTarget(self, action: #selector(togglePasswordVisibility), for: .touchUpInside)
        
        let buttonSize = self.frame.height - 2 * padding
        button.frame = CGRect(x: 0, y: 0, width: buttonSize, height: buttonSize) // Adjust frame as needed
        button.contentEdgeInsets = UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
        
        button.contentMode = .center
        rightView = button
        rightViewMode = .always
        isSecureTextEntry = true
    }
    
    
    @objc private func togglePasswordVisibility(sender: UIButton) {
        isSecureTextEntry = !isSecureTextEntry
        sender.isSelected = !isSecureTextEntry
    }
    
    func setUpTextFieldView(leftImageName : String? = nil , rightImageName : String? = nil){
        if let leftImage = leftImageName{
            // Set up left view (Location icon)
            let leftView = UIView(frame: CGRect(x: 5, y: 0, width: 30, height: 30))
            let locationImageView = UIImageView(image: UIImage(named: "\(leftImage)"))
            locationImageView.frame = leftView.bounds
            locationImageView.contentMode = .center
            leftView.addSubview(locationImageView)
            
            // Assign left views to text field
            self.leftView = leftView
            self.leftViewMode = .always
        }
        if let rightImage = rightImageName{
            let rightView = UIView(frame: CGRect(x: -10, y: 0, width: 30, height: 30))
            let dropdownImageView = UIImageView(image: UIImage(named: "\(rightImage)"))
            dropdownImageView.frame = rightView.bounds
            dropdownImageView.contentMode = .center
            rightView.addSubview(dropdownImageView)
            
            // Assign right views to text field
            
            self.rightView = rightView
            self.rightViewMode = .always
        }
    }
}
