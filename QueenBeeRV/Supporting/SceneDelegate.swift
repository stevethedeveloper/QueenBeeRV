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

//        UILabel.appearance(whenContainedInInstancesOf: [UINavigationBar.self]).adjustsFontSizeToFitWidth = true
        
        let thirdViewController = ChecklistsVC()
        thirdViewController.title = "Checklists"
        thirdViewController.tabBarItem.image = UIImage(systemName: "checklist")
        let firstViewController = VideoVC()
        firstViewController.title = "Videos"
        firstViewController.tabBarItem.image = UIImage(systemName: "video")
        let secondViewController = BlogListVC()
        secondViewController.title = "Blog"
        secondViewController.tabBarItem.image = UIImage(systemName: "square.and.pencil")

//        viewController.view.backgroundColor = UIColor.white
        let firstNavController = UINavigationController(rootViewController: firstViewController)
        let secondNavController = UINavigationController(rootViewController: secondViewController)
        let thirdNavController = UINavigationController(rootViewController: thirdViewController)

//        firstNavController.viewControllers = [firstNavController, secondNavController]
        
        firstNavController.navigationBar.prefersLargeTitles = true
        let titleColor = UIColor.tintColor
        firstNavController.navigationBar.titleTextAttributes = [.foregroundColor: titleColor]
        firstNavController.navigationBar.largeTitleTextAttributes = [.foregroundColor: titleColor]
        firstNavController.navigationBar.tintColor = titleColor
        
        let tabController = UITabBarController()
        tabController.viewControllers = [firstNavController, secondNavController, thirdNavController]
        tabController.tabBar.tintColor = titleColor
//        tabController.tabBar.backgroundColor = #colorLiteral(red: 0.913140689, green: 0.913140689, blue: 0.913140689, alpha: 1)
//        navController.navigationBar.backgroundColor = .black
//        navController.navigationBar.isTranslucent = false
        
//        let navigationBarAppearance = UINavigationBarAppearance()
//        navigationBarAppearance.configureWithOpaqueBackground()
//        navigationBarAppearance.titleTextAttributes = [
//            NSAttributedString.Key.foregroundColor : UIColor(red: 66 / 255, green: 190 / 255, blue: 181 / 255, alpha: 1)
//        ]
//        navigationBarAppearance.largeTitleTextAttributes = [
//            NSAttributedString.Key.foregroundColor : UIColor(red: 66 / 255, green: 190 / 255, blue: 181 / 255, alpha: 1)
//        ]
//        navigationBarAppearance.backgroundColor = UIColor.black
//        UINavigationBar.appearance().standardAppearance = navigationBarAppearance
//        UINavigationBar.appearance().compactAppearance = navigationBarAppearance
//        UINavigationBar.appearance().scrollEdgeAppearance = navigationBarAppearance
        
//        let tabBarApperance = UITabBarAppearance()
//        tabBarApperance.configureWithOpaqueBackground()
//        tabBarApperance.backgroundColor = UIColor.black
//        UITabBar.appearance().scrollEdgeAppearance = tabBarApperance
//        UITabBar.appearance().standardAppearance = tabBarApperance
    
        
        
        
        window = UIWindow(frame: windowScene.coordinateSpace.bounds)
        window?.backgroundColor = .white
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

