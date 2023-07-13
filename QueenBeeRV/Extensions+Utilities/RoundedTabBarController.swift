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
    layer.path = UIBezierPath(roundedRect: CGRect(x: 15, y: tabBar.bounds.minY, width: tabBar.bounds.width - 30, height: tabBar.bounds.height + 5), cornerRadius: (tabBar.frame.width/2)).cgPath
    layer.shadowColor = UIColor.lightGray.cgColor
    layer.shadowOffset = CGSize(width: 5.0, height: 5.0)
    layer.shadowRadius = 25.0
    layer.shadowOpacity = 0.3
    layer.borderWidth = 1.0
    layer.opacity = 1.0
    layer.isHidden = false
    layer.masksToBounds = false
//    layer.fillColor = UIColor.white.cgColor
    layer.fillColor = UIColor(named: "AccentColor")?.cgColor
  
    tabBar.layer.insertSublayer(layer, at: 0)
    let appearance = UITabBarAppearance()
    appearance.configureWithTransparentBackground()
    appearance.stackedLayoutAppearance.selected.titleTextAttributes = [.foregroundColor: UIColor.white]
    appearance.stackedLayoutAppearance.normal.titleTextAttributes = [.foregroundColor: UIColor.systemGray6]
    appearance.stackedLayoutAppearance.selected.iconColor = UIColor.white
    appearance.stackedLayoutAppearance.normal.iconColor = UIColor.systemGray4
    tabBar.standardAppearance = appearance
    tabBar.scrollEdgeAppearance = tabBar.standardAppearance

    if let items = tabBar.items {
        items.forEach { item in
            item.imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: -15, right: 0)
        }
    }

    tabBar.itemWidth = 30.0
    tabBar.itemPositioning = .centered
  }
}
