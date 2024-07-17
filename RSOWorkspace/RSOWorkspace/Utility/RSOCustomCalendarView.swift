//
//  RSOCustomCalendarView.swift
//  RSOWorkspace
//
//  Created by Sumit Aquil on 29/02/24.
//

import Foundation
import UIKit

class RSOCustomCalendarView: UIView {
    
    // UI components
    private let headerView: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        return view
    }()
    
    private let monthLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        return label
    }()
    
    private let previousButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("◀︎", for: .normal)
        return button
    }()
    
    private let nextButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("▶︎", for: .normal)
        return button
    }()
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 10
        return stackView
    }()
    
    // Properties
    private var currentDate: Date = Date()
    
    // Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        updateCalendar()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
        updateCalendar()
    }
    
//    // Setup views
//    private func setupViews() {
//        addSubview(headerView)
//        headerView.addSubview(monthLabel)
//        headerView.addSubview(previousButton)
//        headerView.addSubview(nextButton)
//        addSubview(stackView)
//        
//        previousButton.addTarget(self, action: #selector(previousMonth), for: .touchUpInside)
//        nextButton.addTarget(self, action: #selector(nextMonth), for: .touchUpInside)
//        
//        headerView.translatesAutoresizingMaskIntoConstraints = false
//        monthLabel.translatesAutoresizingMaskIntoConstraints = false
//        previousButton.translatesAutoresizingMaskIntoConstraints = false
//        nextButton.translatesAutoresizingMaskIntoConstraints = false
//        stackView.translatesAutoresizingMaskIntoConstraints = false
//        
//        NSLayoutConstraint.activate([
//            headerView.topAnchor.constraint(equalTo: topAnchor),
//            headerView.leadingAnchor.constraint(equalTo: leadingAnchor),
//            headerView.trailingAnchor.constraint(equalTo: trailingAnchor),
//            headerView.heightAnchor.constraint(equalToConstant: 50),
//            
//            monthLabel.centerXAnchor.constraint(equalTo: headerView.centerXAnchor),
//            monthLabel.centerYAnchor.constraint(equalTo: headerView.centerYAnchor),
//            
//            previousButton.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 16),
//            previousButton.centerYAnchor.constraint(equalTo: headerView.centerYAnchor),
//            
//            nextButton.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -16),
//            nextButton.centerYAnchor.constraint(equalTo: headerView.centerYAnchor),
//            
//            stackView.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 5),
//            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
//            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
//            stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5)
//        ])
//        
//        setupWeekDays()
//    }
//    
//    // Setup week days
//    private func setupWeekDays() {
//        let weekdays = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
//        let stackView = UIStackView()
//        stackView.axis = .horizontal
//        stackView.distribution = .fillEqually
//        
//        for day in weekdays {
//            let label = UILabel()
//            label.textAlignment = .center
//            label.text = day
//            stackView.addArrangedSubview(label)
//        }
//        
//        self.stackView.addArrangedSubview(stackView)
//    }
//
//    
//    // Update calendar
//    private func updateCalendar() {
//        let calendar = Calendar.current
//        let month = calendar.component(.month, from: currentDate)
//        let year = calendar.component(.year, from: currentDate)
//        let day = calendar.component(.day, from: currentDate)
//        
//        monthLabel.text = "\(day)"
//        
//        let firstDayOfMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: currentDate))!
//        let startingWeekday = calendar.component(.weekday, from: firstDayOfMonth)
//        let numberOfDaysInMonth = calendar.range(of: .day, in: .month, for: currentDate)!.count
//        
//        var offset = startingWeekday - calendar.firstWeekday
//        if offset < 0 {
//            offset += 7
//        }
//        
//        let numberOfRows = Int(ceil(Double(numberOfDaysInMonth + offset) / Double(7)))
//        
//        // Remove existing labels
//        for subview in stackView.arrangedSubviews {
//            if subview is UIStackView {
//                for arrangedSubview in (subview as! UIStackView).arrangedSubviews {
//                    arrangedSubview.removeFromSuperview()
//                }
//            }
//            subview.removeFromSuperview()
//        }
//        
//        // Create day labels
//        for i in 0..<numberOfRows {
//            let stackView = UIStackView()
//            stackView.axis = .horizontal
//            stackView.distribution = .fillEqually
//            
//            for j in 0..<7 {
//                let dayLabel = UILabel()
//                dayLabel.textAlignment = .center
//                let dayNumber = i * 7 + j - offset + 1
//                if dayNumber > 0 && dayNumber <= numberOfDaysInMonth {
//                    dayLabel.text = "\(dayNumber)"
//                }
//                stackView.addArrangedSubview(dayLabel)
//            }
//            
//            self.stackView.addArrangedSubview(stackView)
//        }
//    }
    // Setup views
    private func setupViews() {
        addSubview(headerView)
        headerView.addSubview(monthLabel)
        headerView.addSubview(previousButton)
        headerView.addSubview(nextButton)
        addSubview(stackView)
        
        previousButton.addTarget(self, action: #selector(previousMonth), for: .touchUpInside)
        nextButton.addTarget(self, action: #selector(nextMonth), for: .touchUpInside)
        
        headerView.translatesAutoresizingMaskIntoConstraints = false
        monthLabel.translatesAutoresizingMaskIntoConstraints = false
        previousButton.translatesAutoresizingMaskIntoConstraints = false
        nextButton.translatesAutoresizingMaskIntoConstraints = false
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: topAnchor),
            headerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 50),
            
            monthLabel.centerXAnchor.constraint(equalTo: headerView.centerXAnchor),
            monthLabel.centerYAnchor.constraint(equalTo: headerView.centerYAnchor),
            
            previousButton.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 16),
            previousButton.centerYAnchor.constraint(equalTo: headerView.centerYAnchor),
            
            nextButton.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -16),
            nextButton.centerYAnchor.constraint(equalTo: headerView.centerYAnchor),
            
            stackView.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 5),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5)
        ])
        
        setupWeekDays()
    }
    // Setup week days
    private func setupWeekDays() {
        let weekdays = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"]
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        
        for day in weekdays {
            let label = UILabel()
            label.textAlignment = .center
            label.text = day
            stackView.addArrangedSubview(label)
        }
        
        self.stackView.addArrangedSubview(stackView)
    }

    // Update calendar
    private func updateCalendar() {
        let weekdays = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"]
        monthLabel.text = weekdays.joined(separator: " ")
        
        let calendar = Calendar.current
        let firstDayOfMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: currentDate))!
        let startingWeekday = calendar.component(.weekday, from: firstDayOfMonth)
        let numberOfDaysInMonth = calendar.range(of: .day, in: .month, for: currentDate)!.count
        
        var offset = startingWeekday - calendar.firstWeekday
        if offset < 0 {
            offset += 7
        }
        
        let numberOfRows = Int(ceil(Double(numberOfDaysInMonth + offset) / Double(7)))
        
        // Remove existing labels
        for subview in stackView.arrangedSubviews {
            if subview is UIStackView {
                for arrangedSubview in (subview as! UIStackView).arrangedSubviews {
                    arrangedSubview.removeFromSuperview()
                }
            }
            subview.removeFromSuperview()
        }
        
        // Create day labels
        for i in 0..<numberOfRows {
            let stackView = UIStackView()
            stackView.axis = .horizontal
            stackView.distribution = .fillEqually
            
            for j in 0..<7 {
                let dayLabel = UILabel()
                dayLabel.textAlignment = .center
                let dayNumber = i * 7 + j - offset + 1
                if dayNumber > 0 && dayNumber <= numberOfDaysInMonth {
                    dayLabel.text = "\(dayNumber)"
                }
                stackView.addArrangedSubview(dayLabel)
            }
            
            self.stackView.addArrangedSubview(stackView)
        }
    }

    // Navigate to previous month
    @objc private func previousMonth() {
        currentDate = Calendar.current.date(byAdding: .month, value: -1, to: currentDate)!
        updateCalendar()
    }
    
    // Navigate to next month
    @objc private func nextMonth() {
        currentDate = Calendar.current.date(byAdding: .month, value: 1, to: currentDate)!
        updateCalendar()
    }
}
