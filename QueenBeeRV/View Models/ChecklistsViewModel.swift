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
    var onErrorHandling: ((String) -> Void)?
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var models: Observable<[TodoList]> = Observable([])

    // Core Data
    func getAllLists() {
        do {
            let fetchRequest: NSFetchRequest<TodoList>
            fetchRequest = TodoList.fetchRequest()
                        
            models.value = try context.fetch(fetchRequest)
        } catch {
            self.onErrorHandling?("Could not retrieve checklists.  Please check your connection and try again.")
        }
    }
    
    func createList(title: String) {
        let newList = TodoList(context: context)
        newList.title = title
        
        do {
            try context.save()
            getAllLists()
        } catch {
            self.onErrorHandling?("Could not save checklist.  Please check your connection and try again.")
        }
    }
    
    func deleteList(list: TodoList) {
        context.delete(list)
        
        do {
            try context.save()
            getAllLists()
        } catch {
            self.onErrorHandling?("Could not delete checklist.  Please check your connection and try again.")
        }
    }
    
    func updateList(list: TodoList, newName: String) {
        list.title = newName
        
        do {
            try context.save()
            getAllLists()
        } catch {
            self.onErrorHandling?("Could not update checklist.  Please check your connection and try again.")
        }
    }

}
