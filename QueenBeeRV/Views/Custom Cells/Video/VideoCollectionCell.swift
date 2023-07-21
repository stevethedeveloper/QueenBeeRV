//
//  PlaylistCell.swift
//  QueenBeeRV
//
//  Created by Stephen Walton on 6/9/23.
//

import UIKit
import SDWebImage

class VideoCollectionCell: UICollectionViewCell {
    static let identifier = "VideoCollectionCell"

    private let placeholderImage = UIImage(named: "placeholder")

    var text = UILabel()
    var imageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.layer.borderColor = UIColor.systemGray4.cgColor
        self.layer.backgroundColor = UIColor.systemBackground.cgColor
        self.layer.borderWidth = 1
        self.layer.cornerRadius = 10
//        self.contentView.layer.cornerRadius = 10
//        self.contentView.layer.masksToBounds = true
        
        self.addSubview(text)
        self.addSubview(imageView)
        configureImageView()
        configureTextLabel()
        setImageConstraints()
        setTextLabelConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configureImageView() {
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 10
    }
    
    func configureTextLabel() {
        text.numberOfLines = 0
//        text.font = text.font.withSize(15)
        text.font = UIFont.boldSystemFont(ofSize: 16)
        text.numberOfLines = 0
        text.textColor = .label
    }
    
    func setImageConstraints() {
        imageView.translatesAutoresizingMaskIntoConstraints                                           = false
        imageView.topAnchor.constraint(equalTo: self.topAnchor).isActive                      = true
        imageView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive                              = true
        imageView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive                              = true
//        imageView.bottomAnchor.constraint(equalTo: text.topAnchor).isActive                     = true
//        imageView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive                      = true
//        imageView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive                        = true
        imageView.heightAnchor.constraint(equalToConstant: 120).isActive                               = true
//        imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor, multiplier: 16/9).isActive   = true
        imageView.contentMode = .scaleAspectFill
    }

    func setTextLabelConstraints() {
        text.translatesAutoresizingMaskIntoConstraints                                                = false
//        text.centerYAnchor.constraint(equalTo: centerYAnchor).isActive                                = true
        text.topAnchor.constraint(equalTo: imageView.bottomAnchor).isActive       = true
        text.heightAnchor.constraint(equalToConstant: 60).isActive                                    = true
        text.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10).isActive               = true
        text.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10).isActive               = true
    }
    
    
    public func configure(with playlist: Playlist) {
        self.text.text = playlist.title
//        self.imageView.image = UIImage(named: playlist.thumbnailLarge)
        self.imageView.sd_setImage(with: URL(string: playlist.thumbnailLarge), placeholderImage: placeholderImage, options: SDWebImageOptions.highPriority, context: nil, progress: nil)

    }
}
