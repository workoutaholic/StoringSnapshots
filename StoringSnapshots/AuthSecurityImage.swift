//
//  AuthSecurityImage.swift
//  StoringSnapshots
//
//  Created by Geoff Glaeser on 9/8/17.
//  Copyright © 2017 Workoutaholic. All rights reserved.
//

import Foundation
import CoreData

extension AuthSecurityImage {
    
    convenience init(imgData: NSData) {
        
        self.init(context: CoreDataHelper.sharedInstance.managedObjectContext())
        self.image = imgData
    }
    
    func save() {
        
        do {
            try self.managedObjectContext!.save()
            
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
            
        }
        
    }
    
    func delete() {
        
        self.managedObjectContext!.delete(self)
        
        do {
            try self.managedObjectContext!.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
            
        }
    }
    
    func undo() {
        self.managedObjectContext?.rollback()
    }
    
}
