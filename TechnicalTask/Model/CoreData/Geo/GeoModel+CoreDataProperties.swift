//
//  Geo+CoreDataProperties.swift
//  TechnicalTask
//
//  Created by user on 26/02/25.
//
//

import Foundation
import CoreData


extension GeoModel {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<GeoModel> {
        return NSFetchRequest<GeoModel>(entityName: "GeoModel")
    }

    @NSManaged public var lat: String?
    @NSManaged public var lng: String?

}

extension GeoModel : Identifiable {

}
