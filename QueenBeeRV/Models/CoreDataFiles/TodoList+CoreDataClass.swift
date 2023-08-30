//
//  TodoList+CoreDataClass.swift
//  QueenBeeRV
//
//  Created by Stephen Walton on 6/30/23.
//
//

import Foundation
import CoreData

@objc(TodoList)
public class TodoList: NSManagedObject {
    public var itemArray: [TodoListItem] {
        let set = todoListItems as? Set<TodoListItem> ?? []
        return set.sorted {
            $0.sortIndex < $1.sortIndex
        }
    }
}
