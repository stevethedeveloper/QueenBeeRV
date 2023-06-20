//
//  PostCell.swift
//  QueenBeeRV
//
//  Created by Stephen Walton on 5/17/23.
//

import UIKit
import SDWebImage

class PostCell: UITableViewCell {
    
    var blogImageView   = UIImageView()
    var blogTitleLabel  = UILabel()
    let placeholderImage = UIImage(named: "placeholder")

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(blogImageView)
        addSubview(blogTitleLabel)
        
        configureImageView()
        configureTitleLabel()
        setImageConstraints()
        setTitleLabelConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func set(post: Post) {
        // get paragraph
        let paragraph = post.html_content.components(separatedBy: "<p>").last?.replacingOccurrences(of: "</p>", with: "", options: .regularExpression) ?? ""
        //get images
        let regex: Regex = /src\s*=\s*"(.+?)"/
        if let match = post.html_content.firstMatch(of: regex) {
            blogImageView.sd_setImage(with: URL(string: String(match.output.1)), placeholderImage: placeholderImage, options: SDWebImageOptions.highPriority, context: nil, progress: nil)
        }
        // get title
        blogTitleLabel.text = post.title
    }

    func configureImageView() {
        blogImageView.layer.cornerRadius = 10
        blogImageView.clipsToBounds = true
    }
    
    func configureTitleLabel() {
        blogTitleLabel.numberOfLines = 0
        blogTitleLabel.adjustsFontSizeToFitWidth = false
    }
    
    func setImageConstraints() {
        blogImageView.translatesAutoresizingMaskIntoConstraints = false
        blogImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        blogImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12).isActive = true
        blogImageView.heightAnchor.constraint(equalToConstant: 80).isActive = true
        blogImageView.widthAnchor.constraint(equalTo: blogImageView.heightAnchor, multiplier: 16/9).isActive = true
        blogImageView.contentMode = .scaleAspectFit
    }

    func setTitleLabelConstraints() {
        blogTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        blogTitleLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        blogTitleLabel.leadingAnchor.constraint(equalTo: blogImageView.trailingAnchor, constant: 20).isActive = true
//        blogTitleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12).isActive = true
        blogTitleLabel.heightAnchor.constraint(equalToConstant: 80).isActive = true
        blogTitleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12).isActive = true
    }

}
