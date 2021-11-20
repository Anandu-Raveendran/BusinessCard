//
//  Contact+CoreDataProperties.swift
//  
//
//  Created by Anandu on 2021-11-20.
//
//

import Foundation
import CoreData


extension Contact {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Contact> {
        return NSFetchRequest<Contact>(entityName: "Contact")
    }

    @NSManaged public var companyUrl: String?
    @NSManaged public var email: String?
    @NSManaged public var job_title: String?
    @NSManaged public var linkedInUrl: String?
    @NSManaged public var name: String?
    @NSManaged public var phone: Int64
    @NSManaged public var uid: String?

}
