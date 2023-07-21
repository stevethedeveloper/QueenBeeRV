//
//  VideoCell.swift
//  QueenBeeRV
//
//  Created by Stephen Walton on 6/15/23.
//

import UIKit
import SDWebImage
import Lottie

class VideoCell: UITableViewCell {
    static let identifier = "VideoCell"

    var videoImageView   = UIImageView()
    var videoTitleLabel  = UILabel()
    let placeholderImage = UIImage(named: "placeholder")
    var animationView = LottieAnimationView()

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
    
    func set(video: Video, isNowPlaying showAnimation: Bool = false) {
        videoImageView.sd_setImage(with: URL(string: video.thumbnailSmall), placeholderImage: placeholderImage, options: SDWebImageOptions.highPriority, context: nil, progress: nil)
        if showAnimation {
            loadNowPlayingAnimation()
        }
        videoTitleLabel.text = video.title
    }

    func set(playlist: Playlist) {
        videoImageView.sd_setImage(with: URL(string: playlist.thumbnailSmall), placeholderImage: placeholderImage, options: SDWebImageOptions.highPriority, context: nil, progress: nil)
        videoTitleLabel.text = playlist.title
    }

    func configureImageView() {
        videoImageView.clipsToBounds = true
    }
    
    func configureTitleLabel() {
        videoTitleLabel.numberOfLines = 0
        videoTitleLabel.font = videoTitleLabel.font.withSize(15)
    }
    
    func setImageConstraints() {
        videoImageView.translatesAutoresizingMaskIntoConstraints                                                = false
        videoImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive                                = true
        videoImageView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive                                = true
        videoImageView.heightAnchor.constraint(equalToConstant: 60).isActive                                    = true
        videoImageView.widthAnchor.constraint(equalTo: videoImageView.heightAnchor, multiplier: 4/3).isActive   = true
        videoImageView.contentMode = .scaleAspectFit
    }

    func setTitleLabelConstraints() {
        videoTitleLabel.translatesAutoresizingMaskIntoConstraints                                               = false
        videoTitleLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive                               = true
        videoTitleLabel.leadingAnchor.constraint(equalTo: videoImageView.trailingAnchor, constant: 10).isActive = true
        videoTitleLabel.heightAnchor.constraint(equalToConstant: 60).isActive                                   = true
        videoTitleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -40).isActive              = true
    }
    
    func loadNowPlayingAnimation() {
        videoImageView.addSubview(animationView)
        animationView.animation = LottieAnimation.named("waves")
        animationView.backgroundColor = .black
        animationView.isOpaque = false
        animationView.alpha = 0.7
        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = .loop
        
        animationView.translatesAutoresizingMaskIntoConstraints                                 = false
        animationView.centerXAnchor.constraint(equalTo: videoImageView.centerXAnchor).isActive  = true
        animationView.centerYAnchor.constraint(equalTo: videoImageView.centerYAnchor).isActive  = true
        animationView.widthAnchor.constraint(equalTo: videoImageView.widthAnchor).isActive      = true
        animationView.heightAnchor.constraint(equalTo: videoImageView.heightAnchor).isActive    = true

        animationView.play()
    }
    
    func reset() {
        animationView.stop()
        animationView.removeFromSuperview()
    }

}
