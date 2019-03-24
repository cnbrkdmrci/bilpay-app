//
//  UserRecords+CoreDataProperties.swift
//  BilPay
//
//  Created by Canberk Demirci on 14.01.2019.
//  Copyright © 2019 Canberk Demirci. All rights reserved.
//
//

import Foundation
import CoreData


extension UserRecords {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<UserRecords> {
        return NSFetchRequest<UserRecords>(entityName: "UserRecords")
    }

    @NSManaged public var token: String?

}
