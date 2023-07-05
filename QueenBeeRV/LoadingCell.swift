//
//  LoadingCell.swift
//  QueenBeeRV
//
//  Created by Stephen Walton on 6/20/23.
//

import UIKit

class LoadingCell: UITableViewCell {

    var activityIndicator = UIActivityIndicatorView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        addSubview(activityIndicator)
        activityIndicator.translatesAutoresizingMaskIntoConstraints                 = false
        activityIndicator.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
