//
//  HomeVC.swift
//  QueenBeeRV
//
//  Created by Stephen Walton on 7/28/23.
//

import UIKit

class HomeVC: UIViewController {
    override func loadView() {
        let view = UIView()
        self.view = view
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.titleView = UIView()
        
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationController?.setStatusBar(backgroundColor: UIColor(named: "MenuColor")!)

//        let tempView = UIView()
//        tempView.backgroundColor = .systemBackground
//        view.addSubview(tempView)
        let tempView = UIImageView(image: UIImage(named: "bren"))
        view.addSubview(tempView)
        tempView.contentMode = .scaleAspectFit
        tempView.pin(to: view)
        
        let tempLabel = UILabel()
        tempLabel.font = UIFont.boldSystemFont(ofSize: 40)
        let tempString = "Home Screen"
        let tempAttributes = [NSAttributedString.Key.foregroundColor: UIColor.label, NSAttributedString.Key.font: UIFont(name: "AmericanTypewriter-Bold", size: 40.0)!]
        let tempAttributedString = NSAttributedString(string: tempString, attributes: tempAttributes)
        tempLabel.attributedText = tempAttributedString
        tempView.addSubview(tempLabel)
        tempLabel.translatesAutoresizingMaskIntoConstraints = false
        tempLabel.centerXAnchor.constraint(equalTo: tempView.centerXAnchor).isActive = true
        tempLabel.centerYAnchor.constraint(equalTo: tempView.centerYAnchor).isActive = true
    }
}
