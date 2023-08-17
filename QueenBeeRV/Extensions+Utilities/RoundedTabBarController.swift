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
        tabBarItemAppearance.normal.titleTextAttributes = [.foregroundColor: UIColor(named: "LightTealColor") ?? UIColor.white, NSAttributedString.Key.baselineOffset: 2]
        tabBarItemAppearance.normal.iconColor = UIColor(named: "LightTealColor")
        tabBarItemAppearance.selected.iconColor = UIColor.white
        appearance.stackedLayoutAppearance = tabBarItemAppearance
        
        // Add background gradient
        addGradient()
        
        tabBar.standardAppearance = appearance
        tabBar.scrollEdgeAppearance = tabBar.standardAppearance
        
        tabBar.itemWidth = 30.0
        tabBar.itemPositioning = .centered
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        // This is a technique I found to refresh the gradient layer when user switches to dark mode.
        // Normally, with solid colors and no extra layer, you can just change the values here,
        // But this needs to update an added layer, not the standard tabBar.
        
        if traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
            // Remove background gradient
            tabBar.layer.sublayers?[1].removeFromSuperlayer()
            // Add background gradient
            addGradient()
        }
    }
    
    private func addGradient() {
        let gradient = CAGradientLayer()
        gradient.frame = tabBar.bounds
        gradient.frame.size.height = 150
        gradient.colors = [UIColor.clear.withAlphaComponent(0).cgColor, UIColor.systemBackground.withAlphaComponent(1).cgColor]
        gradient.startPoint = CGPoint.zero
        gradient.endPoint = CGPoint(x: 0, y: 0.5)
        tabBar.layer.insertSublayer(gradient, at: 0)
    }
}
