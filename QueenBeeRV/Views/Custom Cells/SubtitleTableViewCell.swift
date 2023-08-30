//
//  SubtitleTableViewCell.swift
//  QueenBeeRV
//
//  Created by Stephen Walton on 7/24/23.
//

import UIKit

class SubtitleTableViewCell: UITableViewCell {
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
