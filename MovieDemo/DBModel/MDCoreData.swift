//
//  MDCoreData.swift
//  MovieDemo
//
//  Created by Pimpaphorn Chaichompoo on 5/10/2565 BE.
//

import Foundation
import CoreData

class MDCoreData {
    
    static let shared = MDCoreData()
    
    private let storeName: String = "MovieDemo"
    private let storeFilename: String = "MovieDemo.sqlite"
    
    var persistentStoreCoordinator: NSPersistentStoreCoordinator!
    
    private init() {
        setupPersistentStoreCoordinator()
//        super.init()
        // save later
        NotificationCenter.default.addObserver(self, selector: #selector(contextDidSaveContext(_:)), name: NSNotification.Name.NSManagedObjectContextDidSave, object: nil)
    }
    
    lazy var applicationDocumentsDirectory: URL = {
        // The directory the application uses to store the Core Data store file. This code uses a directory named "me.iascchen.MyTTT" in the application's documents Application Support directory.
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return urls[urls.count-1]
    }()
    
    lazy var managedObjectModel: NSManagedObjectModel = {
        // The managed object model for the application. This property is not optional. It is a fatal error for the application not to be able to find and load its model.
        let modelURL = Bundle.main.url(forResource: self.storeName, withExtension: "momd")!
        return NSManagedObjectModel(contentsOf: modelURL)!
    }()
    
    private func setupPersistentStoreCoordinator() {
        // The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it. This property is optional since there are legitimate error conditions that could cause the creation of the store to fail.
        // Create the coordinator and store
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        persistentStoreCoordinator = coordinator
        
        let url = self.applicationDocumentsDirectory.appendingPathComponent(self.storeFilename)
        //let failureReason = "There was an error creating or loading the application's saved data."
        do {
            let options = [NSMigratePersistentStoresAutomaticallyOption: true, NSInferMappingModelAutomaticallyOption:true]
            try coordinator.addPersistentStore(ofType: NSSQLiteStoreType,
                                               configurationName: nil,
                                               at: url,
                                               options: options)
        } catch let error as Error? {
            // Report any error we got.
            print("Error :\(String(describing: error?.localizedDescription))")
            
            var isUpdate: Bool = false
            let previousVersionList: [String] = ["4.6","4.6.1","4.6.2","4.6.3","4.7.0","4.7.1","4.7.2","4.7.3","4.7.4","4.7.5"];

            for version in previousVersionList{
                if UserDefaults.standard.bool(forKey: version){
                    isUpdate = true
                    break
                }
            }
            if (isUpdate){
                for version in previousVersionList{
                    UserDefaults.standard.removeObject(forKey: version)
                }
            }
            
            if (FileManager.default.fileExists(atPath: url.path)){
            
                let corruptURL = self.applicationDocumentsDirectory.appendingPathComponent(self.nameForIncompatibleStore())
                do {
                    try FileManager.default.moveItem(at: url, to: corruptURL)
                    setupPersistentStoreCoordinator()
                    
                }catch let fileError as Error?{

                    if fileError != nil{
                        print("Unable to create directory for data stores.")
                    }
                }
                
            }else{
                setupPersistentStoreCoordinator()
            }
        }
    }
    
    
    func nameForIncompatibleStore () -> String {
        let dateformatt = DateFormatter()
        dateformatt.formatterBehavior = .behavior10_4
        dateformatt.dateFormat = "yyyy-MM-dd-HH-mm-ss"
        return String(format: "%@_%@.sqlite",storeFilename, dateformatt.string(from: Date()))
    }

    lazy var managedObjectContext: NSManagedObjectContext = {
        // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.) This property is optional since there are legitimate error conditions that could cause the creation of the context to fail.
        let context = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        context.persistentStoreCoordinator = self.persistentStoreCoordinator
        context.mergePolicy = NSOverwriteMergePolicy
        
//        let appVersion = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String
//
//        switch appVersion {
//            case "4.6.2", "4.6.3", "4.6.4", "4.6.1", "4.6.0":
//                break
//            case "4.7":
//                break
//        default:
//            break
//        }
        
        return context
    }()
    
    // Returns the background object context for the application.
    // You can use it to process bulk data update in background.
    // If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.

    lazy var backgroundContext: NSManagedObjectContext = {
        // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.) This property is optional since there are legitimate error conditions that could cause the creation of the context to fail.
        let context = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        context.parent = self.managedObjectContext
//        context.persistentStoreCoordinator = self.persistentStoreCoordinator
        context.mergePolicy = self.managedObjectContext.mergePolicy

        return context
    }()
    
    
    // save NSManagedObjectContext
    func saveContext(_ context: NSManagedObjectContext) {
        if context.hasChanges {
            do {
                try context.save()
            } catch let error as NSError {
                // Replace this implementation with code to handle the error appropriately.
                // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                debugPrint("Unresolved error \(error), \(error.userInfo)")
//                abort()
            }
        }
    }
    
    func saveContext () {
        self.saveContext(backgroundContext)
    }
    
    func deleteContext (object:NSManagedObject) {
        self.deleteContext(managedObjectContext,object: object)
    }
    
    // delete
    func deleteContext(_ context: NSManagedObjectContext, object:NSManagedObject) {
        
        context.delete(object)
        
        if context.hasChanges {
            do {
                try context.save()
            } catch let error as NSError {
                // Replace this implementation with code to handle the error appropriately.
                // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                debugPrint("Unresolved error \(error), \(error.userInfo)")
                //                abort()
            }
        }
    }

    // call back function by saveContext, support multi-thread
    @objc func contextDidSaveContext(_ notification: Notification) {
        
        if let context = notification.object as? NSManagedObjectContext {

            switch context {
            case managedObjectContext:
                //debugPrint("⚠️ ******** Saved main Context in this thread")
                backgroundContext.perform {
                    self.backgroundContext.mergeChanges(fromContextDidSave: notification)
                    if self.backgroundContext.hasChanges {
                        do {
                            try self.backgroundContext.save()
                        } catch let error as NSError {
                            debugPrint("Unresolved error \(error), \(error.userInfo)")
                        }
                    }
                }
            case backgroundContext:
                //debugPrint("⚠️ ******** Saved background Context in this thread")
                managedObjectContext.perform {
                    self.managedObjectContext.mergeChanges(fromContextDidSave: notification)
                    if self.managedObjectContext.hasChanges {
                        do {
                            try self.managedObjectContext.save()
                        } catch let error as NSError {
                            debugPrint("Unresolved error \(error), \(error.userInfo)")
                        }
                    }
                }
                
            default:
                break
            }
        }
    }
}
