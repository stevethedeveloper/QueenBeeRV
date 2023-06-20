//
//  VideoCell.swift
//  QueenBeeRV
//
//  Created by Stephen Walton on 6/15/23.
//

import UIKit
import SDWebImage

class VideoCell: UITableViewCell {
    
    var videoImageView   = UIImageView()
    var videoTitleLabel  = UILabel()
    let placeholderImage = UIImage(named: "placeholder")

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(videoImageView)
        addSubview(videoTitleLabel)
        
        configureImageView()
        configureTitleLabel()
        setImageConstraints()
        setTitleLabelConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func set(video: Video) {
        videoImageView.sd_setImage(with: URL(string: video.thumbnailSmall), placeholderImage: placeholderImage, options: SDWebImageOptions.highPriority, context: nil, progress: nil)
        videoTitleLabel.text = video.title
    }

    func set(playlist: Playlist) {
        videoImageView.sd_setImage(with: URL(string: playlist.thumbnailSmall), placeholderImage: placeholderImage, options: SDWebImageOptions.highPriority, context: nil, progress: nil)
        videoTitleLabel.text = playlist.title
    }

    func configureImageView() {
//        videoImageView.layer.cornerRadius = 20
        videoImageView.clipsToBounds = true
    }
    
    func configureTitleLabel() {
        videoTitleLabel.numberOfLines = 0
//        videoTitleLabel.adjustsFontSizeToFitWidth = true
        videoTitleLabel.font = videoTitleLabel.font.withSize(15)
    }
    
    func setImageConstraints() {
        videoImageView.translatesAutoresizingMaskIntoConstraints = false
        videoImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        videoImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12).isActive = true
        videoImageView.heightAnchor.constraint(equalToConstant: 60).isActive = true
        videoImageView.widthAnchor.constraint(equalTo: videoImageView.heightAnchor, multiplier: 16/9).isActive = true
        videoImageView.contentMode = .scaleAspectFit
    }

    func setTitleLabelConstraints() {
        videoTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        videoTitleLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        videoTitleLabel.leadingAnchor.constraint(equalTo: videoImageView.trailingAnchor, constant: 10).isActive = true
        videoTitleLabel.heightAnchor.constraint(equalToConstant: 60).isActive = true
        videoTitleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -40).isActive = true
    }

}
