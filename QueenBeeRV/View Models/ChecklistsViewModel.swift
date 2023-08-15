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
            let sortDescriptor = NSSortDescriptor(key: "sortIndex", ascending: true)
            fetchRequest.sortDescriptors = [sortDescriptor]
                        
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

    func updateListOrder(lists: [TodoList]) {
        do {
            try context.save()
            getAllLists()
        } catch {
            self.onErrorHandling?("Could not save checklist.  Please check your connection and try again.")
        }
    }

    func insertChecklistFromTemplate(template: Template) {
//               print("selected: \(template)")
        let entity = NSEntityDescription.entity(forEntityName: "TodoList", in: context)!
        let checklist = NSManagedObject(entity: entity, insertInto: context)
        checklist.setValue(template.title, forKeyPath: "title")

        do {
            try context.save()
            getAllLists()
        } catch {
            self.onErrorHandling?("Could not save checklist.  Please check your connection and try again.")
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
            getAllLists()
        } catch {
            self.onErrorHandling?("Could not save checklist.  Please check your connection and try again.")
        }

    }
}
