//
//  PostCell.swift
//  QueenBeeRV
//
//  Created by Stephen Walton on 5/17/23.
//

import UIKit
import SDWebImage

class PostCell: UITableViewCell {
    
    let cellView = UIView()
    var blogImageView   = UIImageView()
    var blogTitleLabel  = UILabel()
    let placeholderImage = UIImage(named: "placeholder")

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubview(cellView)
        addSubview(blogImageView)
        addSubview(blogTitleLabel)
        
        configureViewCell()
        configureImageView()
        configureTitleLabel()
        setCellViewConstraints()
        setImageConstraints()
        setTitleLabelConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func set(post: Post) {
        // get paragraph
//        let paragraph = post.html_content.components(separatedBy: "<p>").last?.replacingOccurrences(of: "</p>", with: "", options: .regularExpression) ?? ""
        //get images
        let regex: Regex = /src\s*=\s*"(.+?)"/
        if let match = post.html_content.firstMatch(of: regex) {
            blogImageView.sd_setImage(with: URL(string: String(match.output.1)), placeholderImage: placeholderImage, options: SDWebImageOptions.highPriority, context: nil, progress: nil)
        }
        // get title
        blogTitleLabel.text = post.title
    }

    func configureViewCell() {
        cellView.layer.cornerRadius = 10
        cellView.layer.borderWidth = 1
        cellView.layer.borderColor = UIColor.systemGray5.cgColor
    }

    func configureImageView() {
        blogImageView.layer.cornerRadius = 10
        blogImageView.clipsToBounds = true
        blogImageView.contentMode = .scaleAspectFill
    }
    
    func configureTitleLabel() {
        blogTitleLabel.numberOfLines = 0
        blogTitleLabel.adjustsFontSizeToFitWidth = false
    }
    
    func setCellViewConstraints() {
        cellView.translatesAutoresizingMaskIntoConstraints = false
        cellView.topAnchor.constraint(equalTo: self.topAnchor, constant: 20).isActive = true
        cellView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        cellView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        cellView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
    }
    
    func setImageConstraints() {
        blogImageView.translatesAutoresizingMaskIntoConstraints = false
        blogImageView.topAnchor.constraint(equalTo: topAnchor, constant: 30).isActive = true
        blogImageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10).isActive = true
//        blogImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        blogImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12).isActive = true
//        blogImageView.heightAnchor.constraint(equalToConstant: 80).isActive = true
        blogImageView.widthAnchor.constraint(equalTo: blogImageView.heightAnchor, multiplier: 16/9).isActive = true
    }

    func setTitleLabelConstraints() {
        blogTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        blogTitleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 30).isActive = true
        blogTitleLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10).isActive = true
//        blogTitleLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        blogTitleLabel.leadingAnchor.constraint(equalTo: blogImageView.trailingAnchor, constant: 20).isActive = true
//        blogTitleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12).isActive = true
//        blogTitleLabel.heightAnchor.constraint(equalToConstant: 80).isActive = true
        blogTitleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12).isActive = true
    }

}
