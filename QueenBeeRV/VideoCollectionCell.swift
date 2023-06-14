//
//  PlaylistCell.swift
//  QueenBeeRV
//
//  Created by Stephen Walton on 6/9/23.
//

import UIKit
import SDWebImage

class VideoCollectionCell: UICollectionViewCell {

    fileprivate var bg: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.image = UIImage(named: "placeholder")
        iv.layer.cornerRadius = 12
        return iv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        contentView.addSubview(bg)
        
        bg.pin(to: contentView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//    var playlistImageView   = UIImageView()
//    var playlistTitleLabel  = UILabel()
//    let placeholderImage = UIImage(named: "placeholder")
//
//    override init(style: UICollectionViewCell.CellStyle, reuseIdentifier: String?) {
//        super.init(style: style, reuseIdentifier: reuseIdentifier)
//        addSubview(playlistImageView)
//        addSubview(playlistTitleLabel)
//
////        configureImageView()
////        configureTitleLabel()
////        setImageConstraints()
////        setTitleLabelConstraints()
//    }

}
