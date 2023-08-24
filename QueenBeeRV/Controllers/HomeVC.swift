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

        let viewTop = UIView()
        viewTop.backgroundColor = .red
        view.addSubview(viewTop)
        
        viewTop.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            viewTop.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            viewTop.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            viewTop.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: -30),
            viewTop.heightAnchor.constraint(equalToConstant: 200)
        ])
        
//        let scrollView = UIScrollView()
//        scrollView.backgroundColor = .blue
//        view.addSubview(scrollView)
//        scrollView.pin(to: view)
        
        
        
        
//        guard let customFont = UIFont(name: "FontdinerdotcomSparkly", size: UIFont.labelFontSize) else {
//            fatalError("""
//                Failed to load the "FontdinerdotcomSparkly" font.
//                Make sure the font file is included in the project and the font name is spelled correctly.
//                """
//            )
//        }
        
//        for family in UIFont.familyNames.sorted() {
//            let names = UIFont.fontNames(forFamilyName: family)
//            print("Family: \(family) Font names: \(names)")
//        }
//        navigationController?.setStatusBar(backgroundColor: UIColor(named: "MenuColor")!)

//        let tempView = UIView()
//        tempView.backgroundColor = .systemBackground
//        view.addSubview(tempView)
        
        
        
        
        
        
        
//        let tempLabel = UILabel()
//        tempLabel.font = UIFont.boldSystemFont(ofSize: 40)
//        let tempString = "Get Organized and Stay Safe"
//        let tempAttributes = [NSAttributedString.Key.foregroundColor: UIColor.label, NSAttributedString.Key.font: UIFont(name: "FontdinerdotcomSparkly", size: 30.0)!]
//        let tempAttributedString = NSAttributedString(string: tempString, attributes: tempAttributes)
//        tempLabel.attributedText = tempAttributedString
//        view.addSubview(tempLabel)
//        tempLabel.translatesAutoresizingMaskIntoConstraints = false
//
//        NSLayoutConstraint.activate([
//            tempLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
//            tempLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
//            tempLabel.heightAnchor.constraint(equalToConstant: 100.0)
//        ])
    }
}
