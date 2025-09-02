//
//  CDToDoItem+CoreDataProperties.swift
//  ToDoListEM
//
//  Created by Илья Востров on 01.09.2025.
//
//

import Foundation
import CoreData


extension CDToDoItem {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CDToDoItem> {
        return NSFetchRequest<CDToDoItem>(entityName: "CDToDoItem")
    }

    @NSManaged public var createdAt: Date?
    @NSManaged public var id: Int16
    @NSManaged public var isCompleted: Bool
    @NSManaged public var note: String?
    @NSManaged public var title: String?

}

extension CDToDoItem : Identifiable {

}
