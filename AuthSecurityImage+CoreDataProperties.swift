//
//  AuthSecurityImage+CoreDataProperties.swift
//  StoringSnapshots
//
//  Created by Geoff Glaeser on 9/8/17.
//  Copyright © 2017 Workoutaholic. All rights reserved.
//

import Foundation
import CoreData


extension AuthSecurityImage {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<AuthSecurityImage> {
        return NSFetchRequest<AuthSecurityImage>(entityName: "AuthSecurityImage")
    }

    @NSManaged public var image: NSData?

}
