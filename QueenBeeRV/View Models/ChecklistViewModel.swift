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
    var todoListRecordObjectID: NSManagedObjectID!
    
    // change to "as?"
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    var models: Observable<[TodoListItem]> = Observable([])

    // Core Data
    func getAllItems() {
        guard let listRecord = context.object(with: todoListRecordObjectID!) as? TodoList else { return }
        models.value = listRecord.itemArray
        
//        DispatchQueue.main.async {
//            self.tableView.reloadData()
//        }
        
        //        let fetchRequest: NSFetchRequest<TodoList>
        //        fetchRequest = TodoList.fetchRequest()
        
        //        fetchRequest.predicate = NSPredicate(
        //            format: "title = %@", todoListRecord.title!
        //        )
        
        //        do {
        //            let listRecord = try context.fetch(fetchRequest)
        //            print(listRecord)
        ////            models = listRecord.itemArray
        ////            print(models)
        //
        //            DispatchQueue.main.async {
        //                self.tableView.reloadData()
        //            }
        //        } catch {
        //
        //        }
        
    }
    
    func createItem(name: String) {
        guard let listRecord = context.object(with: todoListRecordObjectID!) as? TodoList else { return }
        let newItem = TodoListItem(context: context)
        newItem.name = name
        newItem.createdAt = Date()
        newItem.todoList = listRecord
        //        newItem.todoList = todoListRecord
        
        //        todoListRecord.addToTodoListItems(newItem)
        do {
            try context.save()
            getAllItems()
        } catch {
            
        }
    }
    
    func deleteItem(item: TodoListItem) {
        context.delete(item)
        
        do {
            try context.save()
            getAllItems()
        } catch {
            
        }
    }
    
    func updateItem(item: TodoListItem, newName: String) {
        item.name = newName
        
        do {
            try context.save()
            getAllItems()
        } catch {
            
        }
    }
    
    func toggleCompleted(item: TodoListItem) {
        item.completed = !item.completed
        
        do {
            try context.save()
            getAllItems()
        } catch {
            
        }
    }

}
