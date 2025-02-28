//
//  AddressModel+CoreDataProperties.swift
//  TechnicalTask
//
//  Created by user on 26/02/25.
//
//

import Foundation
import CoreData


extension AddressModel {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<AddressModel> {
        return NSFetchRequest<AddressModel>(entityName: "AddressModel")
    }

    @NSManaged public var street: String?
    @NSManaged public var suite: String?
    @NSManaged public var city: String?
    @NSManaged public var zipcode: String?
    @NSManaged public var geo: Geo?

}

extension AddressModel : Identifiable {

}
