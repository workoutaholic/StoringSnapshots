//
//  CoreDataHelper.swift
//  StoringSnapshots
//
//  Created by Geoff Glaeser on 9/8/17.
//  Copyright © 2017 Workoutaholic. All rights reserved.
//

import UIKit
import CoreData

protocol PersistenceProtocol {
    func managedObjectContext() -> NSManagedObjectContext
    func fetchSecurityImages() -> [AuthSecurityImage]
}

class CoreDataHelper: NSObject, PersistenceProtocol {
    
    static let sharedInstance = CoreDataHelper()
    
    func appDelegate()->AppDelegate
    {
        return UIApplication.shared.delegate as! AppDelegate
    }
    
    func managedObjectContext() -> NSManagedObjectContext
    {
        return self.appDelegate().persistentContainer.viewContext
    }
    
    
    func fetchSecurityImages() -> [AuthSecurityImage]
    {
        let request = AuthSecurityImage.fetchRequest() as NSFetchRequest
        
        let moc = self.managedObjectContext()
        
        do {
            let people = try moc.fetch(request)
            return people
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        
        return []
    }
    
}
