//
//  HomeCell.swift
//  QueenBeeRV
//
//  Created by Stephen Walton on 8/24/23.
//

import UIKit

class HomeCell: UITableViewCell {
    private let cellView = UIView()
    private let title: UILabel = {
        let label = UILabel()
        let customFont = UIFont(name: "FontdinerdotcomSparkly", size: 40)
        label.font = customFont
        label.textColor = UIColor(named: "AccentColor")
        return label
    }()
    private let text = UILabel()
    private let symbol = UIImageView()
    private var row = 0
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubview(cellView)
        cellView.addSubview(title)
        cellView.addSubview(text)
        cellView.addSubview(symbol)
        
        setCellViewConstraints()
        setTitleConstraints()
    }
    
    func set(title: String, text: String, symbol: String, row: Int) {
        self.title.text = title
        self.text.text = text
        self.symbol.image = UIImage(systemName: symbol)
        self.row = row
        setSymbolConstraints()
        setTextConstraints()
    }
    
    private func setCellViewConstraints() {
        cellView.backgroundColor = .quaternarySystemFill
        cellView.layer.cornerRadius = 10.0
        cellView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            cellView.topAnchor.constraint(equalTo: self.topAnchor, constant: 15.0),
            cellView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            cellView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            cellView.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        ])

    }
    
    private func setTitleConstraints() {
        title.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            title.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            title.heightAnchor.constraint(equalToConstant: 45.0)
        ])
        let titleConstraintTop = title.topAnchor.constraint(equalTo: cellView.topAnchor, constant: 10.0)
        titleConstraintTop.priority = UILayoutPriority(1000)
        titleConstraintTop.isActive = true
    }

    private func setSymbolConstraints() {
        symbol.tintColor = UIColor(named: "SalmonColor")
        symbol.translatesAutoresizingMaskIntoConstraints = false
        print(row)
        if row % 2 == 0 {
            NSLayoutConstraint.activate([
                symbol.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 20.0),
                symbol.leftAnchor.constraint(equalTo: cellView.leftAnchor, constant: 10.0),
                symbol.widthAnchor.constraint(equalToConstant: 120.0),
                symbol.heightAnchor.constraint(equalToConstant: 100.0)
            ])
        } else {
            NSLayoutConstraint.activate([
                symbol.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 20.0),
                symbol.rightAnchor.constraint(equalTo: cellView.rightAnchor, constant: -10.0),
                symbol.widthAnchor.constraint(equalToConstant: 120.0),
                symbol.heightAnchor.constraint(equalToConstant: 100.0)
            ])
        }
        let symbolLayoutConstraintBottom = symbol.bottomAnchor.constraint(equalTo: cellView.bottomAnchor)
        symbolLayoutConstraintBottom.priority = UILayoutPriority(1)
        symbolLayoutConstraintBottom.isActive = true
    }
    
    private func setTextConstraints() {
        text.numberOfLines = 0
        text.translatesAutoresizingMaskIntoConstraints = false
        if row % 2 == 0 {
            NSLayoutConstraint.activate([
                text.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 20.0),
                text.leadingAnchor.constraint(equalTo: symbol.trailingAnchor, constant: 10.0),
                text.trailingAnchor.constraint(equalTo: cellView.trailingAnchor, constant: -10.0)
            ])
        } else {
            NSLayoutConstraint.activate([
                text.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 20.0),
                text.leadingAnchor.constraint(equalTo: cellView.leadingAnchor, constant: 10.0),
                text.trailingAnchor.constraint(equalTo: symbol.leadingAnchor, constant: -10.0)
            ])
        }
        let textLayoutConstraintBottom = symbol.bottomAnchor.constraint(equalTo: cellView.bottomAnchor)
        textLayoutConstraintBottom.priority = UILayoutPriority(1)
        textLayoutConstraintBottom.isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
