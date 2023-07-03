//
//  LoadingCell.swift
//  QueenBeeRV
//
//  Created by Stephen Walton on 6/20/23.
//

import UIKit

class LoadingCell: UITableViewCell {

//    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    var activityIndicator = UIActivityIndicatorView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        addSubview(activityIndicator)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
//
//    override func awakeFromNib() {
//        super.awakeFromNib()
//
//
//        // Initialization code
    }

//    override func setSelected(_ selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)
//
//        // Configure the view for the selected state
//    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
