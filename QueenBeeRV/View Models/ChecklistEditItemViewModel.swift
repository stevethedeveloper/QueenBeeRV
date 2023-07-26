//
//  ChecklistEditItemViewModel.swift
//  QueenBeeRV
//
//  Created by Stephen Walton on 7/24/23.
//

import Foundation
import UIKit.UIApplication
import CoreData

final public class ChecklistEditItemViewModel {
    var onErrorHandling: ((String) -> Void)?
//    var todoListRecordObjectID: NSManagedObjectID!
    var todoListRecord: TodoListItem!
    
    // change to "as?"
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    func updateItem(item: TodoListItem, newName: String, newNotes: String, newLastCompleted: DateComponents?) {
        item.name = newName
        item.notes = newNotes
        
        if let newLastCompleted = newLastCompleted, let newLastCompletedYear = newLastCompleted.year, let newLastCompletedMonth = newLastCompleted.month, let newLastCompletedDay = newLastCompleted.day {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-M-d"
            let dateString = "\(newLastCompletedYear)-\(newLastCompletedMonth)-\(newLastCompletedDay)"
            item.lastCompleted = dateFormatter.date(from: dateString)
        } else {
            item.lastCompleted = nil
        }
        
        
        do {
            try context.save()
//            getAllItems()
        } catch {
            self.onErrorHandling?("Could not update item.  Please check your connection and try again.")
        }
    }
}
