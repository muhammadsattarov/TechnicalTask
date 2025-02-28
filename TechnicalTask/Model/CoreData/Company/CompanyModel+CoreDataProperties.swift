//
//  CompanyModel+CoreDataProperties.swift
//  TechnicalTask
//
//  Created by user on 26/02/25.
//
//

import Foundation
import CoreData


extension CompanyModel {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CompanyModel> {
        return NSFetchRequest<CompanyModel>(entityName: "CompanyModel")
    }

    @NSManaged public var name: String?
    @NSManaged public var catchPhrase: String?
    @NSManaged public var bs: String?

}

extension CompanyModel : Identifiable {

}
