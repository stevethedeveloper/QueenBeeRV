//
//  ChecklistEditItemVC.swift
//  QueenBeeRV
//
//  Created by Stephen Walton on 7/24/23.
//

import UIKit

class ChecklistEditItemVC: UIViewController {
    let viewModel = ChecklistEditItemViewModel()
    
    // callback to refresh calling view
    var onViewWillDisappear: (()->())?
    
    private let scrollView = UIScrollView()
    
//    public var item = TodoListItem()
    
    // Notes view
    private let notesView = UITextView()
    // Title View
    private let titleField = UITextField()
    // Date view
//    private let dateButton = UIButton()
    private let lastCompleteDateLabel = UILabel()
    // Date components selected
    private var saveDateComponents: DateComponents?
    
    private let headerView = UIView()

    private let calendarView = UICalendarView()

    
//    let stackView: UIStackView = {
//        let stackView = UIStackView()
//        stackView.translatesAutoresizingMaskIntoConstraints = false
//        stackView.distribution = .fill
//        stackView.alignment = .fill
//        stackView.axis = .vertical
//        stackView.isLayoutMarginsRelativeArrangement = true
//        stackView.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16)
//        return stackView
//    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        hideKeyboardWhenLosesFocus()
        
        configureButtons()
                
        // labels
        let titleLabel = UILabel()
        titleLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        titleLabel.widthAnchor.constraint(equalToConstant: self.view.frame.width - 40).isActive = true
        titleLabel.textColor = .systemGray
        titleLabel.text = "Task Name"

        let notesLabel = UILabel()
        notesLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        notesLabel.widthAnchor.constraint(equalToConstant: self.view.frame.width - 40).isActive = true
        notesLabel.textColor = .systemGray
        notesLabel.text = "Notes"

        let dateLabel = UILabel()
        dateLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        dateLabel.widthAnchor.constraint(equalToConstant: self.view.frame.width - 40).isActive = true
        dateLabel.textColor = .systemGray
        dateLabel.text = "Last Completed Date"

        // Notes View
        notesView.widthAnchor.constraint(equalToConstant: self.view.frame.width - 40).isActive = true
        notesView.heightAnchor.constraint(equalToConstant: 175.0).isActive = true
        notesView.layer.borderColor = UIColor.systemGray4.cgColor
        notesView.layer.borderWidth = 1
        notesView.layer.cornerRadius = 10.0
        notesView.textColor = .label
        notesView.backgroundColor = .systemBackground
        notesView.font = .systemFont(ofSize: 16)
        notesView.text = viewModel.todoListRecord.notes

        // Title field
        titleField.widthAnchor.constraint(equalToConstant: self.view.frame.width - 40).isActive = true
        titleField.layer.borderColor = UIColor.systemGray4.cgColor
        titleField.layer.borderWidth = 1
        titleField.layer.cornerRadius = 10.0
        titleField.textColor = .label
        titleField.heightAnchor.constraint(equalToConstant: 40.0).isActive = true
        titleField.backgroundColor = .systemBackground
        // Extension
        titleField.setLeftPaddingPoints(10)
        titleField.setRightPaddingPoints(10)
        titleField.text = viewModel.todoListRecord.name

        let lastCompletedView = UIView()
        lastCompletedView.widthAnchor.constraint(equalToConstant: self.view.frame.width - 40).isActive = true
        lastCompletedView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        lastCompletedView.addSubview(lastCompleteDateLabel)
        lastCompleteDateLabel.translatesAutoresizingMaskIntoConstraints = false
        lastCompleteDateLabel.widthAnchor.constraint(equalToConstant: self.view.frame.width * 0.5).isActive = true
        lastCompleteDateLabel.heightAnchor.constraint(equalToConstant: 40.0).isActive = true
        lastCompleteDateLabel.layer.borderColor = UIColor.systemGray4.cgColor
        lastCompleteDateLabel.layer.borderWidth = 1
        lastCompleteDateLabel.layer.cornerRadius = 10.0
//        lastCompleteDateLabel.setTitleColor(UIColor(named: "AccentColor"), for: .normal)
        if let lastCompletedDate = viewModel.todoListRecord.lastCompleted {
            setLastCompleteDateLabel(toDate: lastCompletedDate)
        }
        let lastCompletedClearButton = UIButton()
//        lastCompletedChageButton.addTarget(self, action: #selector(saveChanges), for: .touchUpInside)
        lastCompletedView.addSubview(lastCompletedClearButton)
        lastCompletedClearButton.setTitleColor(.systemRed, for: .normal)
        lastCompletedClearButton.setTitle("Clear", for: .normal)
        lastCompletedClearButton.translatesAutoresizingMaskIntoConstraints = false
        lastCompletedClearButton.titleLabel?.font = .systemFont(ofSize: 14)
        lastCompletedClearButton.centerYAnchor.constraint(equalTo: lastCompletedView.centerYAnchor).isActive = true
//        lastCompletedClearButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        lastCompletedClearButton.rightAnchor.constraint(equalTo: lastCompletedView.rightAnchor, constant: -10).isActive = true
        lastCompletedClearButton.addTarget(self, action: #selector(clearLastCompletedDate), for: .touchUpInside)

        let lastCompletedChangeButton = UIButton()
//        lastCompletedChageButton.addTarget(self, action: #selector(saveChanges), for: .touchUpInside)
        lastCompletedView.addSubview(lastCompletedChangeButton)
        lastCompletedChangeButton.setTitleColor(UIColor(named: "AccentColor"), for: .normal)
        lastCompletedChangeButton.setTitle("Change", for: .normal)
        lastCompletedChangeButton.translatesAutoresizingMaskIntoConstraints = false
        lastCompletedChangeButton.titleLabel?.font = .systemFont(ofSize: 14)
        lastCompletedChangeButton.centerYAnchor.constraint(equalTo: lastCompletedView.centerYAnchor).isActive = true
//        lastCompletedChangeButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        lastCompletedChangeButton.rightAnchor.constraint(equalTo: lastCompletedClearButton.leftAnchor, constant: -20).isActive = true
        lastCompletedChangeButton.addTarget(self, action: #selector(toggleCalendar), for: .touchUpInside)



        
        calendarView.isHidden = true
        calendarView.calendar = Calendar(identifier: .gregorian)
        calendarView.locale = .current
        calendarView.fontDesign = .rounded
        calendarView.delegate = self
        calendarView.widthAnchor.constraint(equalToConstant: self.view.frame.width - 100).isActive = true
        calendarView.heightAnchor.constraint(equalTo: calendarView.widthAnchor).isActive = true
        let selection = UICalendarSelectionSingleDate(delegate: self)
        calendarView.selectionBehavior = selection
        
        
        let spacer = UIView()
        // maximum width constraint
        let spacerHeightConstraint = spacer.heightAnchor.constraint(equalToConstant: 200)
        spacerHeightConstraint.priority = .defaultLow
        spacerHeightConstraint.isActive = true

        view.addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: headerView.bottomAnchor),
            scrollView.leftAnchor.constraint(equalTo: view.leftAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            scrollView.rightAnchor.constraint(equalTo: view.rightAnchor)
        ])
        
        //Stack View
        let stackView   = UIStackView()
        stackView.axis  = NSLayoutConstraint.Axis.vertical
        stackView.distribution  = UIStackView.Distribution.equalSpacing
        stackView.alignment = UIStackView.Alignment.center
        stackView.spacing = 8

        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(titleField)
        stackView.addArrangedSubview(notesLabel)
        stackView.addArrangedSubview(notesView)
        stackView.addArrangedSubview(dateLabel)
        stackView.addArrangedSubview(lastCompletedView)
        stackView.addArrangedSubview(calendarView)
        stackView.addArrangedSubview(spacer)
        stackView.translatesAutoresizingMaskIntoConstraints = false

//        self.view.addSubview(stackView)
        scrollView.addSubview(stackView)

        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
        
        // Keyboard handling
//        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
//        view.addGestureRecognizer(tap)
        
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // callback to refresh calling view
        onViewWillDisappear?()
    }
    
    @objc private func clearLastCompletedDate() {
        setLastCompleteDateLabel(toDate: nil)
    }
    
    @objc private func toggleCalendar() {
        if calendarView.isHidden {
            UIView.animate(withDuration: 0.35) { [unowned self] in
                self.calendarView.isHidden = false
                self.calendarView.alpha = 1
            }
        } else {
            UIView.animate(withDuration: 0.35) { [unowned self] in
               self.calendarView.isHidden = true
               self.calendarView.alpha = 0
            }
        }
    }
        
//    @objc private func dismissKeyboard() {
//        view.endEditing(true)
//    }
   
    private func configureButtons() {
        let saveButton = UIButton()
        let cancelButton = UIButton()

        view.addSubview(headerView)
        headerView.backgroundColor = .systemBackground
        headerView.translatesAutoresizingMaskIntoConstraints = false
        headerView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        headerView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        headerView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        headerView.heightAnchor.constraint(equalToConstant: 50).isActive = true


        saveButton.addTarget(self, action: #selector(saveChanges), for: .touchUpInside)
        headerView.addSubview(saveButton)
        saveButton.setTitleColor(UIColor(named: "AccentColor"), for: .normal)
        saveButton.setTitle("Save", for: .normal)
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        saveButton.centerYAnchor.constraint(equalTo: headerView.centerYAnchor).isActive = true
        saveButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        saveButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10).isActive = true

        cancelButton.addTarget(self, action: #selector(dismissModal), for: .touchUpInside)
        headerView.addSubview(cancelButton)
        cancelButton.setTitleColor(UIColor.red, for: .normal)
        cancelButton.setTitle("Cancel", for: .normal)
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        cancelButton.centerYAnchor.constraint(equalTo: headerView.centerYAnchor).isActive = true
        cancelButton.widthAnchor.constraint(equalToConstant: 60).isActive = true
        cancelButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10).isActive = true
    }

    @objc private func saveChanges() {
        viewModel.updateItem(item: viewModel.todoListRecord, newName: titleField.text ?? "(no task name provided)", newNotes: notesView.text, newLastCompleted: saveDateComponents)
        dismissModal()
    }
    
    @objc private func dismissModal() {
        self.dismiss(animated: true)
    }
    
    private func setLastCompleteDateLabel(toDate newDate: Date?) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "M/d/y"
        if let newDate = newDate {
            let dateString = dateFormatter.string(from: newDate)
            lastCompleteDateLabel.text = "  \(dateString)"
        } else {
            lastCompleteDateLabel.text = nil
        }
//        dateButton.setTitle(dateString, for: .normal)
    }

}

extension ChecklistEditItemVC: UICalendarViewDelegate, UICalendarSelectionSingleDateDelegate {
    func dateSelection(_ selection: UICalendarSelectionSingleDate, didSelectDate dateComponents: DateComponents?) {
        self.saveDateComponents = dateComponents

        if let dateComponents = dateComponents, let newLastCompletedYear = dateComponents.year, let newLastCompletedMonth = dateComponents.month, let newLastCompletedDay = dateComponents.day {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-M-d"
            let dateString = "\(newLastCompletedYear)-\(newLastCompletedMonth)-\(newLastCompletedDay)"
            if let newDate = dateFormatter.date(from: dateString) {
                setLastCompleteDateLabel(toDate: newDate)
            }
            UIView.animate(withDuration: 0.35) { [unowned self] in
               self.calendarView.isHidden = true
               self.calendarView.alpha = 0
            }

        } else {
            lastCompleteDateLabel.text = "No date selected."
        }
    }
    
    func dateSelection(_ selection: UICalendarSelectionSingleDate, canSelectDate dateComponents: DateComponents?) -> Bool {
        return true
    }
    
//    func calendarView(_ calendarView: UICalendarView, decorationFor dateComponents: DateComponents) -> UICalendarView.Decoration? {
//        return nil
//    }
}
