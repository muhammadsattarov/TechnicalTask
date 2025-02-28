//
//  TodoListModel+CoreDataProperties.swift
//  TechnicalTask
//
//  Created by user on 26/02/25.
//
//

import Foundation
import CoreData


extension TodoListModel {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TodoListModel> {
        return NSFetchRequest<TodoListModel>(entityName: "TodoListModel")
    }

    @NSManaged public var userId: Int64
    @NSManaged public var id: Int64
    @NSManaged public var title: String?
    @NSManaged public var completed: Bool

}

extension TodoListModel : Identifiable {

}
