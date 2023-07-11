//
//  TodoListItem+CoreDataClass.swift
//  QueenBeeRV
//
//  Created by Stephen Walton on 6/30/23.
//
//

import Foundation
import CoreData

@objc(TodoListItem)
public class TodoListItem: NSManagedObject {
    public var wrappedName: String {
        name ?? "Unknown name"
    }
}
