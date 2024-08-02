import UIKit

class ExpirationDatePicker: NSObject, UIPickerViewDelegate, UIPickerViewDataSource {

    private var months: [String] = []
    private var years: [String] = []
    private let pickerView = UIPickerView()
    weak var textField: UITextField?

    init(textField: UITextField) {
        super.init()
        self.textField = textField
        setupPickerView()
        updateDateOptions()
    }

    private func setupPickerView() {
        pickerView.delegate = self
        pickerView.dataSource = self
        textField?.inputView = pickerView
    }

    private func updateDateOptions() {
        let currentYear = Calendar.current.component(.year, from: Date())
        let currentMonth = Calendar.current.component(.month, from: Date())

        // Initialize years with current year and up to 20 future years
        years = Array(currentYear...currentYear + 20).map { String($0) }

        // Initialize months with all months, then filter out invalid months based on current date
        months = (1...12).map { String(format: "%02d", $0) }

        // Filter months if the selected year is the current year
        if let selectedYear = textField?.text?.components(separatedBy: "/").last, let year = Int(selectedYear), year == currentYear {
            months = months.filter { Int($0)! >= currentMonth }
        }
    }

    // MARK: - UIPickerViewDataSource
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2 // One for months and one for years
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch component {
        case 0:
            return months.count
        case 1:
            return years.count
        default:
            return 0
        }
    }

    // MARK: - UIPickerViewDelegate
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch component {
        case 0:
            return months[row]
        case 1:
            return years[row]
        default:
            return nil
        }
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let selectedMonth = months[pickerView.selectedRow(inComponent: 0)]
        let selectedYear = years[pickerView.selectedRow(inComponent: 1)]
        let selectedDateString = "\(selectedMonth)/\(selectedYear)"

        textField?.text = selectedDateString
    }

    // MARK: - UIPickerView Delegate
    func pickerView(_ pickerView: UIPickerView, didChangeValue value: Int, forComponent component: Int) {
        // Ensure the months and years are updated based on the currently selected year and month
        if component == 1 {
            updateDateOptions()
            pickerView.reloadComponent(0)
        }
    }
}
