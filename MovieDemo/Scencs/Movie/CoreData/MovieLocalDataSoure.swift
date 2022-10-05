//
//  MovieLocalDataSoure.swift
//  MovieDemo
//
//  Created by Pimpaphorn Chaichompoo on 5/10/2565 BE.
//


import UIKit
import CoreData

class MovieLocalDataSoure: NSObject {
    
    public static let shared = MovieLocalDataSoure()
    
    var coreDataStore: MDCoreData!
    var callCenterNumber: String?
    
    private override init() {
        self.coreDataStore = MDCoreData.shared
        super.init()
    }
}

extension MovieLocalDataSoure {
    
    func fetchMovie() -> [MD_Movie]? {
        
        let fetchRequest: NSFetchRequest<MD_Movie> = NSFetchRequest(entityName: "MD_Movie")
        fetchRequest.returnsObjectsAsFaults = false
        
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
    
    
    func saveMovie(from movieList: [Movie]) -> [MD_Movie] {
        
        var savedMovies: [MD_Movie] = [MD_Movie]()
        
        for movie in movieList {
            
            let savedMovie: MD_Movie?
            
            let fetchRequest: NSFetchRequest<MD_Movie> = NSFetchRequest(entityName: "MD_Movie")
            fetchRequest.predicate = NSPredicate(format: "name == %@", movie.title ?? "")
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
            
            savedMovie?.name = movie.title
            savedMovie?.image = movie.image
            savedMovie?.detail = movie.detail
            savedMovie?.score = movie.score ?? 0.0
            savedMovie?.url = movie.url
            
            if let value = savedMovie {
                savedMovies.append(value)
            }
            
            self.coreDataStore.saveContext(self.coreDataStore.backgroundContext)
        }
        
        return savedMovies
    }
}
