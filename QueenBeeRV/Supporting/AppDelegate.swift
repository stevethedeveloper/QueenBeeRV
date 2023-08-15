//
//  AppDelegate.swift
//  QueenBeeRV
//
//  Created by Stephen Walton on 5/17/23.
//

import UIKit
import CoreData

@main
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        preloadTemplateData()
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "QueenBeeRV")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

    private func preloadTemplateData() {
        let preloadKey = "didPreload"
        let userDefaults = UserDefaults.standard

        if userDefaults.bool(forKey: preloadKey) == false {
            guard let templatesFileURL = Bundle.main.url(forResource: "checklist_templates", withExtension: "json") else { return }
                        
            DispatchQueue.global(qos: .userInitiated).async {
                if let templatesContents = try? String(contentsOf: templatesFileURL) {
                    let decoder = JSONDecoder()
                    
                    do {
                        let jsonString = templatesContents.data(using: .utf8)
                        if let jsonString = jsonString {
                            let templatesDecoded = try decoder.decode(Templates.self, from: jsonString)
                            for template in templatesDecoded.templates {
                                if template.items.count > 0 {
                                    self.insertChecklistFromTemplate(template: template)
                                }
                            }
                        }
                    } catch {
                        print("Could not load templates.  Please check your connection and try again.")
                    }
                }
                
                userDefaults.set(true, forKey: preloadKey)
            }
        }
    }
    
    private func insertChecklistFromTemplate(template: Template) {
        let context = persistentContainer.newBackgroundContext()
        let entity = NSEntityDescription.entity(forEntityName: "TodoList", in: context)!
        let checklist = NSManagedObject(entity: entity, insertInto: context)
        checklist.setValue(template.title, forKeyPath: "title")
        checklist.setValue(1, forKeyPath: "sortIndex")

        do {
            try context.save()
        } catch {
            print("Could not save checklist.  Please check your connection and try again.")
        }

        let entityItems = NSEntityDescription.entity(forEntityName: "TodoListItem", in: context)
                
        // No saving happens in this loop
        var sortIndex = 0
        for checklistItem in template.items {
            let item = NSManagedObject(entity: entityItems!, insertInto: context)
            item.setValue(checklistItem.name, forKeyPath: "name")
            item.setValue(checklist, forKey: "todoList")
            item.setValue(sortIndex, forKey: "sortIndex")
            sortIndex += 1
        }

        do {
            try context.save()
        } catch {
            print("Could not save checklist.  Please check your connection and try again.")
        }

    }
}

