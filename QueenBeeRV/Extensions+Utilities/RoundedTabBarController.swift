//
//  RoundedTabBarController.swift
//  QueenBeeRV
//
//  Created by Stephen Walton on 7/12/23.
//

import UIKit

class RoundedTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let layer = CAShapeLayer()
        layer.path = UIBezierPath(roundedRect: CGRect(x: 15, y: tabBar.bounds.minY, width: tabBar.bounds.width - 30, height: tabBar.bounds.height), cornerRadius: (tabBar.frame.width/2)).cgPath
//        layer.shadowColor = UIColor.lightGray.cgColor
//        layer.shadowOffset = CGSize(width: 5.0, height: 5.0)
//        layer.shadowRadius = 25.0
//        layer.shadowOpacity = 0.3
        layer.borderWidth = 1.0
        layer.opacity = 1.0
        layer.isHidden = false
        layer.masksToBounds = false
        layer.fillColor = UIColor(named: "MenuColor")?.cgColor
        
        tabBar.layer.insertSublayer(layer, at: 0)
        let appearance = UITabBarAppearance()
        appearance.configureWithTransparentBackground()
        
        let tabBarItemAppearance = UITabBarItemAppearance()
        tabBarItemAppearance.selected.titleTextAttributes = [.foregroundColor: UIColor.white, NSAttributedString.Key.baselineOffset: 2]
        tabBarItemAppearance.normal.titleTextAttributes = [.foregroundColor: UIColor.systemGray6, NSAttributedString.Key.baselineOffset: 2]
        tabBarItemAppearance.selected.iconColor = UIColor.white
        tabBarItemAppearance.normal.iconColor = UIColor.systemGray4
        appearance.stackedLayoutAppearance = tabBarItemAppearance
        
//        let bgView = UIView()
//        bgView.backgroundColor = .systemBackground
//        view.addSubview(bgView)
//        bgView.translatesAutoresizingMaskIntoConstraints = false
//        bgView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
//        bgView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
//        bgView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
//        bgView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
//
//      tab bar gradient background
        let gradient = CAGradientLayer()
        gradient.frame = tabBar.bounds
        gradient.frame.size.height = 150
        gradient.colors = [UIColor.clear.withAlphaComponent(0).cgColor, UIColor.systemBackground.withAlphaComponent(1).cgColor]
        gradient.startPoint = CGPoint.zero
        gradient.endPoint = CGPoint(x: 0, y: 0.5)
        tabBar.layer.insertSublayer(gradient, at: 0)
        
        tabBar.standardAppearance = appearance
        tabBar.scrollEdgeAppearance = tabBar.standardAppearance
        
        tabBar.itemWidth = 30.0
        tabBar.itemPositioning = .centered
    }
}
