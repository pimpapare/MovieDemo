//
//  AuthenLocal.swift
//  MovieDemo
//
//  Created by Pimpaphorn Chaichompoo on 5/10/2565 BE.
//

import UIKit
import CoreData

class AuthenLocal: NSObject {
    
    public static let shared = AuthenLocal()
    
    var coreDataStore: MDCoreData!
    var callCenterNumber: String?
    
    private override init() {
        self.coreDataStore = MDCoreData.shared
        super.init()
    }
}

extension AuthenLocal {
    
    func fetchUser() -> MD_User? {
        
        let fetchRequest: NSFetchRequest<MD_User> = NSFetchRequest(entityName: "MD_User")
        fetchRequest.returnsObjectsAsFaults = false
        
        var result: [MD_User]?
        
        var error: NSError? = nil
        
        do {
            result = try self.coreDataStore.managedObjectContext.fetch(fetchRequest)
        } catch let nserror1 as NSError{
            error = nserror1
            debugPrint("\(String(describing: error?.description))")
        }
        
        return result?.first
    }
    
    func saveUser(_ email: String, userId: String) -> MD_User? {
        
        let savedUser: MD_User?
        
        let fetchRequest: NSFetchRequest<MD_User> = NSFetchRequest(entityName: "MD_User")
        fetchRequest.predicate = NSPredicate(format: "userId == %@", userId)
        fetchRequest.returnsObjectsAsFaults = false
        
        var result = [MD_User]()
        
        do {
            result = try self.coreDataStore.backgroundContext.fetch(fetchRequest)
        } catch _ {
        }
        
        if result.isEmpty {
            savedUser = NSEntityDescription.insertNewObject(forEntityName: "MD_User", into: self.coreDataStore.backgroundContext) as? MD_User
        }else{
            savedUser = result.first
        }
        
        savedUser?.email = email
        savedUser?.userId = userId

        self.coreDataStore.saveContext(self.coreDataStore.backgroundContext)
        
        return savedUser
    }
    
    func removeUser() {
        
        let fetchRequest: NSFetchRequest<MD_User> = NSFetchRequest(entityName: "MD_User")
        fetchRequest.returnsObjectsAsFaults = false
        
        var result: [MD_User]?
        var error: NSError? = nil
        
        do {
            result = try self.coreDataStore.backgroundContext.fetch(fetchRequest)
        } catch let nserror1 as NSError{
            error = nserror1
        }
        
        if let r = result {
            for item in r {
                self.coreDataStore.backgroundContext.delete(item)
            }
        }
        
        self.coreDataStore.saveContext(self.coreDataStore.backgroundContext)
    }
}
