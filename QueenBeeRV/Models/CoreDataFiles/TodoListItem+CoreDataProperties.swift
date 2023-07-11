//
//  TodoListItem+CoreDataProperties.swift
//  QueenBeeRV
//
//  Created by Stephen Walton on 6/30/23.
//
//

import Foundation
import CoreData


extension TodoListItem {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TodoListItem> {
        return NSFetchRequest<TodoListItem>(entityName: "TodoListItem")
    }

    @NSManaged public var completed: Bool
    @NSManaged public var createdAt: Date?
    @NSManaged public var name: String?
    @NSManaged public var starred: Bool
    @NSManaged public var sortIndex: Int16
    @NSManaged public var todoList: TodoList?

}

extension TodoListItem : Identifiable {

}
