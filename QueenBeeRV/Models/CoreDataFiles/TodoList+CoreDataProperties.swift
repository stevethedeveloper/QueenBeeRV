//
//  TodoList+CoreDataProperties.swift
//  QueenBeeRV
//
//  Created by Stephen Walton on 6/30/23.
//
//

import Foundation
import CoreData


extension TodoList {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TodoList> {
        return NSFetchRequest<TodoList>(entityName: "TodoList")
    }

    @NSManaged public var title: String?
    @NSManaged public var sortIndex: Int32
    @NSManaged public var todoListItems: NSSet?

}

// MARK: Generated accessors for todoListItems
extension TodoList {

    @objc(addTodoListItemsObject:)
    @NSManaged public func addToTodoListItems(_ value: TodoListItem)

    @objc(removeTodoListItemsObject:)
    @NSManaged public func removeFromTodoListItems(_ value: TodoListItem)

    @objc(addTodoListItems:)
    @NSManaged public func addToTodoListItems(_ values: NSSet)

    @objc(removeTodoListItems:)
    @NSManaged public func removeFromTodoListItems(_ values: NSSet)

}

extension TodoList : Identifiable {

}
