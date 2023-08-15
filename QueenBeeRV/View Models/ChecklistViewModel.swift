//
//  ChecklistViewModel.swift
//  QueenBeeRV
//
//  Created by Stephen Walton on 7/10/23.
//

import Foundation
import UIKit.UIApplication
import CoreData

public class ChecklistViewModel {
    var onErrorHandling: ((String) -> Void)?
    var todoListRecordObjectID: NSManagedObjectID!
    var listTitle = ""
    
    // change to "as?"
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    var models: Observable<[TodoListItem]> = Observable([])

    // Core Data
    func getAllItems() {
        guard let listRecord = context.object(with: todoListRecordObjectID!) as? TodoList else { return }
        models.value = listRecord.itemArray
    }
    
    func createItem(name: String) {
        guard let listRecord = context.object(with: todoListRecordObjectID!) as? TodoList else { return }
        let newItem = TodoListItem(context: context)
        newItem.name = name
        newItem.createdAt = Date()
        newItem.todoList = listRecord
        do {
            try context.save()
            getAllItems()
        } catch {
            self.onErrorHandling?("Could not create item.  Please check your connection and try again.")
        }
    }
    
    func updateListOrder(lists: [TodoListItem]) {
        do {
            try context.save()
            getAllItems()
        } catch {
            self.onErrorHandling?("Could not save checklist.  Please check your connection and try again.")
        }
    }

    func deleteItem(item: TodoListItem) {
        context.delete(item)
        
        do {
            try context.save()
            getAllItems()
        } catch {
            self.onErrorHandling?("Could not delete item.  Please check your connection and try again.")
        }
    }
    
    func toggleCompleted(item: TodoListItem) {
        item.completed = !item.completed

        do {
            try context.save()
            getAllItems()
        } catch {
            self.onErrorHandling?("Could not change status.  Please check your connection and try again.")
        }
    }

    func toggleStarred(item: TodoListItem) {
        item.starred = !item.starred

        do {
            try context.save()
            getAllItems()
        } catch {
            self.onErrorHandling?("Could not change star status.  Please check your connection and try again.")
        }
    }

}
