//
//  VideoTableSectionHeader.swift
//  QueenBeeRV
//
//  Created by Stephen Walton on 6/19/23.
//

import UIKit

class VideoTableSectionHeader: UITableViewHeaderFooterView {
    static let identifier = "TableHeader"
    
    var labelText: String? = "" {
        didSet {
            label.text = labelText
        }
    }
    
    var sectionName: String?
        
    private let label: UILabel = {
        let label = UILabel()
        label.text = ""
        label.textColor = UIColor(named: "AccentColor")
        label.font = UIFont.systemFont(ofSize: 24)
        label.numberOfLines = 2
        label.adjustsFontSizeToFitWidth = true
        label.textAlignment = .left
        return label
    }()
    
    let button: UIButton = {
        let button = UIButton()
        button.setTitleColor(UIColor(named: "AccentColor"), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        button.setTitle("View All >", for: .normal)
        button.contentHorizontalAlignment = .right
        return button
    }()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        contentView.addSubview(label)
        contentView.addSubview(button)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        label.sizeToFit()
        label.frame = CGRect(x: 20,
                             y: contentView.frame.size.height - 10 - label.frame.size.height,
                             width: contentView.frame.size.width - 30,
                             height: label.frame.size.height)
    }
}
