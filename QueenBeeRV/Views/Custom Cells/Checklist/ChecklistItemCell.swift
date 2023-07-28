//
//  ChecklistCell.swift
//  QueenBeeRV
//
//  Created by Stephen Walton on 7/26/23.
//

import UIKit

class ChecklistItemCell: UITableViewCell {
    let cellView = UIView()

    var itemTitleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.adjustsFontSizeToFitWidth = false
        return label
    }()
    
    var completedButton: UIButton = {
        var buttonConfiguration = UIButton.Configuration.bordered()
        buttonConfiguration.title = ""
        buttonConfiguration.imagePadding = 0
        buttonConfiguration.background.backgroundColor = .systemBackground

        let button = UIButton(configuration: buttonConfiguration)
        button.setTitle("", for: .normal)
        button.layer.cornerRadius = 10.0
        button.imageView?.tintColor = .systemGreen
        button.layer.borderColor = UIColor.systemGray.cgColor
        button.layer.borderWidth = 1.0
        button.clipsToBounds = true
        return button
    }()
    
    var notesButton: UIButton = {
        var buttonConfiguration = UIButton.Configuration.bordered()
        buttonConfiguration.title = ""
        buttonConfiguration.imagePadding = 0
        buttonConfiguration.background.backgroundColor = .clear

        let button = UIButton(configuration: buttonConfiguration)
        button.setTitle("", for: .normal)
        button.clipsToBounds = true
        return button
    }()
    
    var notesLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.adjustsFontSizeToFitWidth = false
        label.font = .systemFont(ofSize: 15)
//        label.clipsToBounds = true
        return label
    }()
    
    var starImage: UIImageView = {
        let imageView = UIImageView()
        let image = UIImage(systemName: "star.fill")?.withTintColor(.systemYellow, renderingMode: .alwaysOriginal)
        imageView.image = image
        return imageView
    }()
    
    var currentItem: TodoListItem!
    var notesHidden = true
    let notesView = UIView()

    let stackView = UIStackView()

    // callback to refresh calling view
    public var toggleCompletedCallback: () -> () = {}
    public var reloadCell: () -> () = {}

    @objc private func didTapCheckbox() {
        toggleCompletedCallback()
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        

        cellView.addSubview(itemTitleLabel)
        cellView.addSubview(completedButton)
        completedButton.addTarget(self, action: #selector(didTapCheckbox), for: .touchUpInside)
        cellView.addSubview(notesButton)
        notesButton.addTarget(self, action: #selector(toggleNotes), for: .touchUpInside)
        cellView.addSubview(notesButton)
        cellView.addSubview(starImage)

        stackView.axis  = NSLayoutConstraint.Axis.vertical
        stackView.distribution  = UIStackView.Distribution.equalSpacing
        stackView.alignment = UIStackView.Alignment.fill
        stackView.spacing = 0

        stackView.translatesAutoresizingMaskIntoConstraints = false

        contentView.addSubview(stackView)

        stackView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        stackView.widthAnchor.constraint(equalTo: contentView.widthAnchor).isActive = true
        // Set some constraints to priority 999 to supress warnings when removing and inserting elements
        let bottomStackView = stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        bottomStackView.priority = UILayoutPriority(999)
        bottomStackView.isActive = true

        stackView.addArrangedSubview(cellView)
        // Start with notes hidden
        notesView.isHidden = true
        stackView.addArrangedSubview(notesView)

        let cellHeight = cellView.widthAnchor.constraint(equalTo: stackView.widthAnchor)
        cellHeight.priority = UILayoutPriority(999)
        cellHeight.isActive = true
        cellView.heightAnchor.constraint(greaterThanOrEqualToConstant: 44).isActive = true
        
        notesView.widthAnchor.constraint(equalTo: stackView.widthAnchor).isActive = true
        let notesHeight = notesView.heightAnchor.constraint(greaterThanOrEqualToConstant: 44)
        notesHeight.priority = UILayoutPriority(999)
        notesHeight.isActive = true

        setCompletedButtonConstraints()
        setNotesButtonConstraints()
        setStarImageConstraints()
        setTitleLabelConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func set(item: TodoListItem) {
        self.currentItem = item
        
        if let itemName = item.name {
            itemTitleLabel.text = itemName
        }
        
        if item.completed {
            completedButton.configuration?.image  = UIImage(systemName: "checkmark")
        } else {
            completedButton.configuration?.image = UIImage()
        }
        
        if let notes = item.notes, !notes.isEmpty {
            setNotesLabelConstraints()
            
            let attributedString = NSMutableAttributedString(string: "Notes:\n\(notes)")
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineSpacing = 1.4
            attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, attributedString.length))
            notesLabel.attributedText = attributedString
            
            let image = UIImage(systemName: "list.clipboard.fill")?.withTintColor(UIColor(red: 118/255, green: 152/255, blue: 218/255, alpha: 1), renderingMode: .alwaysOriginal)
            notesButton.setImage(image, for: .normal)
        } else {
            setNotesLabelConstraints()
            notesLabel.text = "No notes yet. Swipe left to edit."
            let image = UIImage(systemName: "list.clipboard")?.withTintColor(UIColor(red: 118/255, green: 152/255, blue: 218/255, alpha: 1), renderingMode: .alwaysOriginal)
            notesButton.setImage(image, for: .normal)
        }
        
        if item.starred {
            starImage.isHidden = false
        } else {
            starImage.isHidden = true
        }

    }
    
    @objc public func toggleNotes() {
        notesHidden = !notesHidden
        if notesHidden {
            notesView.isHidden = true
            reloadCell()
        } else {
            notesView.isHidden = false
            reloadCell()
        }
    }
    
    private func setStarImageConstraints() {
        starImage.translatesAutoresizingMaskIntoConstraints = false
        starImage.topAnchor.constraint(equalTo: cellView.topAnchor, constant: 15).isActive = true
        starImage.leadingAnchor.constraint(equalTo: cellView.leadingAnchor, constant: 10).isActive = true
        starImage.heightAnchor.constraint(equalToConstant: 15).isActive = true
        starImage.widthAnchor.constraint(equalToConstant: 15).isActive = true
}

    private func setTitleLabelConstraints() {
        itemTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        itemTitleLabel.topAnchor.constraint(equalTo: cellView.topAnchor, constant: 7).isActive = true
        itemTitleLabel.leadingAnchor.constraint(equalTo: starImage.trailingAnchor, constant: 10).isActive = true
        itemTitleLabel.trailingAnchor.constraint(equalTo: notesButton.leadingAnchor, constant: -5).isActive = true
        itemTitleLabel.bottomAnchor.constraint(equalTo: cellView.bottomAnchor, constant: -7).isActive = true
    }

    private func setNotesLabelConstraints() {
        let notesLabelWrapperView = UIView()
        notesView.addSubview(notesLabelWrapperView)

        notesLabelWrapperView.backgroundColor = UIColor.secondarySystemBackground
        notesLabelWrapperView.layer.borderColor = UIColor.secondarySystemBackground.cgColor
        notesLabelWrapperView.layer.borderWidth = 1
        notesLabelWrapperView.layer.cornerRadius = 7

        notesLabelWrapperView.translatesAutoresizingMaskIntoConstraints = false
        notesLabelWrapperView.topAnchor.constraint(equalTo: itemTitleLabel.bottomAnchor, constant: 20).isActive = true
        notesLabelWrapperView.leadingAnchor.constraint(equalTo: notesView.leadingAnchor, constant: 10).isActive = true
        notesLabelWrapperView.bottomAnchor.constraint(equalTo: notesView.bottomAnchor, constant: -10).isActive = true
        notesLabelWrapperView.trailingAnchor.constraint(equalTo: notesView.trailingAnchor, constant: -10).isActive = true

        notesLabelWrapperView.addSubview(notesLabel)
        notesLabel.translatesAutoresizingMaskIntoConstraints = false
        notesLabel.topAnchor.constraint(equalTo: notesLabelWrapperView.topAnchor, constant: 5).isActive = true
        notesLabel.leadingAnchor.constraint(equalTo: notesLabelWrapperView.leadingAnchor, constant: 5).isActive = true
        notesLabel.bottomAnchor.constraint(equalTo: notesLabelWrapperView.bottomAnchor, constant: -5).isActive = true
        notesLabel.trailingAnchor.constraint(equalTo: notesLabelWrapperView.trailingAnchor, constant: -5).isActive = true
    }

    private func setNotesButtonConstraints() {
        notesButton.translatesAutoresizingMaskIntoConstraints = false
        notesButton.topAnchor.constraint(equalTo: cellView.topAnchor, constant: 7).isActive = true
        notesButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        notesButton.widthAnchor.constraint(equalToConstant: 30).isActive = true
        notesButton.trailingAnchor.constraint(equalTo: completedButton.leadingAnchor, constant: -20).isActive = true
    }

    private func setCompletedButtonConstraints() {
        completedButton.translatesAutoresizingMaskIntoConstraints = false
        completedButton.widthAnchor.constraint(equalToConstant: 30).isActive = true
        completedButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        completedButton.topAnchor.constraint(equalTo: cellView.topAnchor, constant: 7).isActive = true
        completedButton.trailingAnchor.constraint(equalTo: cellView.trailingAnchor, constant: -10).isActive = true
    }
}
