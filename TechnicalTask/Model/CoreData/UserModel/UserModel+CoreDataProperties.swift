//
//  UserModel+CoreDataProperties.swift
//  TechnicalTask
//
//  Created by user on 26/02/25.
//
//

import Foundation
import CoreData


extension UserModel {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<UserModel> {
        return NSFetchRequest<UserModel>(entityName: "UserModel")
    }

    @NSManaged public var id: Int64
    @NSManaged public var name: String?
    @NSManaged public var username: String?
    @NSManaged public var email: String?
    @NSManaged public var phone: String?
    @NSManaged public var website: String?
    @NSManaged public var address: AddressModel?
    @NSManaged public var company: CompanyModel?

}

extension UserModel : Identifiable {

}
