//
//  SceneDelegate.swift
//  QueenBeeRV
//
//  Created by Stephen Walton on 5/17/23.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let windowScene = (scene as? UIWindowScene) else { return }

        let homeViewController = HomeVC()
        homeViewController.title = "Home"
        homeViewController.tabBarItem.image = UIImage(systemName: "house.fill")?.withBaselineOffset(fromBottom: 5.0)
        let firstViewController = ChecklistsVC()
        firstViewController.title = "Checklists"
        firstViewController.tabBarItem.image = UIImage(systemName: "checklist")?.withBaselineOffset(fromBottom: 5.0)
        let secondViewController = VideoVC()
        secondViewController.title = "Videos"
        secondViewController.tabBarItem.image = UIImage(systemName: "play.tv.fill")?.withBaselineOffset(fromBottom: 5.0)
        let thirdViewController = BlogListVC()
        thirdViewController.title = "Articles"
        thirdViewController.tabBarItem.image = UIImage(systemName: "doc.text.fill")?.withBaselineOffset(fromBottom: 5.0)

        let titleColor = UIColor.white

        let homeNavController = UINavigationController(rootViewController: homeViewController)
        let firstNavController = UINavigationController(rootViewController: firstViewController)
        let secondNavController = UINavigationController(rootViewController: secondViewController)
        let thirdNavController = UINavigationController(rootViewController: thirdViewController)

        let allNavControllers = [homeNavController, firstNavController, secondNavController, thirdNavController]

        // init navigation bar on all views
        for (index, nc) in allNavControllers.enumerated() {
            if index == 0 {
                nc.navigationBar.isHidden = true
                continue
            }
            let navigationBarAppearance = UINavigationBarAppearance()
            navigationBarAppearance.configureWithOpaqueBackground()
            nc.navigationBar.prefersLargeTitles = true
            navigationBarAppearance.titleTextAttributes = [.foregroundColor: titleColor]
            navigationBarAppearance.largeTitleTextAttributes = [.foregroundColor: titleColor]
            nc.navigationBar.tintColor = titleColor
            navigationBarAppearance.backgroundColor = UIColor(named: "MenuColor")
            nc.navigationBar.layer.cornerRadius = 15
            nc.navigationBar.clipsToBounds = true
            nc.navigationBar.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
            nc.navigationBar.standardAppearance = navigationBarAppearance
            nc.navigationBar.scrollEdgeAppearance = nc.navigationBar.standardAppearance
        }
        
        let tabController = RoundedTabBarController()
        
        tabController.viewControllers = allNavControllers
    
        window = UIWindow(frame: windowScene.coordinateSpace.bounds)
        window?.backgroundColor = .systemBackground
        window?.windowScene = windowScene
        window?.rootViewController = tabController
        window?.makeKeyAndVisible()
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.

        // Save changes in the application's managed object context when the application transitions to the background.
        (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
    }
}

