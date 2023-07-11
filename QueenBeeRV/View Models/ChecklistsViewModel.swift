//
//  ChecklistsViewModel.swift
//  QueenBeeRV
//
//  Created by Stephen Walton on 7/10/23.
//

import Foundation
import UIKit.UIApplication
import CoreData

public class ChecklistsViewModel {
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var models: Observable<[TodoList]> = Observable([])

    // Core Data
    func getAllLists() {
        do {
            let fetchRequest: NSFetchRequest<TodoList>
            fetchRequest = TodoList.fetchRequest()
                        
            models.value = try context.fetch(fetchRequest)
//            DispatchQueue.main.async {
//                self.tableView.reloadData()
//            }
        } catch {
            
        }
        
        
//        do {
//            models = try context.fetch(TodoList.fetchRequest())
//            print(models)
//
//            DispatchQueue.main.async {
//                self.tableView.reloadData()
//            }
//        } catch {
//
//        }
        
    }
    
    func createList(title: String) {
        let newList = TodoList(context: context)
        newList.title = title
        
        do {
            try context.save()
            getAllLists()
        } catch {
            
        }
    }
    
    func deleteList(list: TodoList) {
        context.delete(list)
        
        do {
            try context.save()
            getAllLists()
        } catch {
            
        }
    }
    
    func updateList(list: TodoList, newName: String) {
        list.title = newName
        
        do {
            try context.save()
            getAllLists()
        } catch {
            
        }
    }

}
