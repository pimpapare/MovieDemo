//
//  MovieLocal.swift
//  MovieDemo
//
//  Created by Pimpaphorn Chaichompoo on 5/10/2565 BE.
//

import UIKit
import CoreData

class MovieLocal: NSObject {
    
    public static let shared = MovieLocal()
    
    var coreDataStore: MDCoreData!
    var callCenterNumber: String?
    
    private override init() {
        self.coreDataStore = MDCoreData.shared
        super.init()
    }
}

extension MovieLocal {
    
    func fetchMovies() -> [MD_Movie]? {
        
        let fetchRequest: NSFetchRequest<MD_Movie> = NSFetchRequest(entityName: "MD_Movie")
        fetchRequest.returnsObjectsAsFaults = false
        
        let sorter: NSSortDescriptor = NSSortDescriptor(key: "title" , ascending: true)
        fetchRequest.sortDescriptors = [sorter]
        
        var result: [MD_Movie]?
        
        var error: NSError? = nil
        
        do {
            result = try self.coreDataStore.managedObjectContext.fetch(fetchRequest)
        } catch let nserror1 as NSError{
            error = nserror1
            debugPrint("\(String(describing: error?.description))")
        }
        
        return result
    }
    
    func fetchMovie(from title: String) -> MD_Movie? {
        
        let fetchRequest: NSFetchRequest<MD_Movie> = NSFetchRequest(entityName: "MD_Movie")
        fetchRequest.predicate = NSPredicate(format: "title == %@", title)
        fetchRequest.returnsObjectsAsFaults = false
        
        var result: [MD_Movie]?
        
        var error: NSError? = nil
        
        do {
            result = try self.coreDataStore.managedObjectContext.fetch(fetchRequest)
        } catch let nserror1 as NSError{
            error = nserror1
            debugPrint("\(String(describing: error?.description))")
        }
        
        return result?.first
    }
    
    func saveMovies(from movieList: [Movie]) -> [MD_Movie] {
        
        var savedMovies: [MD_Movie] = [MD_Movie]()
        
        for movie in movieList {
            
            let savedMovie: MD_Movie?
            
            let fetchRequest: NSFetchRequest<MD_Movie> = NSFetchRequest(entityName: "MD_Movie")
            fetchRequest.predicate = NSPredicate(format: "title == %@", movie.title ?? "")
            fetchRequest.returnsObjectsAsFaults = false
            
            var result = [MD_Movie]()
            
            do {
                result = try self.coreDataStore.backgroundContext.fetch(fetchRequest)
            } catch _ {
            }
            
            if result.isEmpty {
                savedMovie = NSEntityDescription.insertNewObject(forEntityName: "MD_Movie", into: self.coreDataStore.backgroundContext) as? MD_Movie
            }else{
                savedMovie = result.first
            }
            
            savedMovie?.malId = movie.malId ?? 0

            savedMovie?.title = movie.title
            savedMovie?.synopsis = movie.synopsis
            savedMovie?.image = movie.image
            savedMovie?.smallImage = movie.smallImage
            savedMovie?.largeImage = movie.largeImage
            savedMovie?.score = movie.score ?? 0.0
            savedMovie?.url = movie.url
            savedMovie?.isFav = movie.isFav
            savedMovie?.documentId = movie.documentId

            if let value = savedMovie {
                savedMovies.append(value)
            }
            
            self.coreDataStore.saveContext(self.coreDataStore.backgroundContext)
        }
        
        savedMovies = savedMovies.sorted(by: { lItem, rItem in
            return (lItem.title ?? "") < (rItem.title ?? "")
        })
        
        return savedMovies
    }
    
    func saveMovieStatus(of movie: MD_Movie, isFav: Bool, documentId: String?) {
        
        let savedMovie: MD_Movie?
        
        let fetchRequest: NSFetchRequest<MD_Movie> = NSFetchRequest(entityName: "MD_Movie")
        fetchRequest.predicate = NSPredicate(format: "title == %@", movie.title ?? "")
        fetchRequest.returnsObjectsAsFaults = false
        
        var result = [MD_Movie]()
        
        do {
            result = try self.coreDataStore.backgroundContext.fetch(fetchRequest)
        } catch _ {
        }
        
        if result.isEmpty {
            savedMovie = NSEntityDescription.insertNewObject(forEntityName: "MD_Movie", into: self.coreDataStore.backgroundContext) as? MD_Movie
        }else{
            savedMovie = result.first
        }
        
        savedMovie?.isFav = isFav
        savedMovie?.documentId = documentId
        
        self.coreDataStore.saveContext(self.coreDataStore.backgroundContext)
    }
    
    func removeMovies() {
        
        let fetchRequest: NSFetchRequest<MD_Movie> = NSFetchRequest(entityName: "MD_Movie")
        fetchRequest.returnsObjectsAsFaults = false
        
        var result: [MD_Movie]?
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
