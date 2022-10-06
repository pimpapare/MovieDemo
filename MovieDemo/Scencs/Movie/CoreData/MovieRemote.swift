//
//  MovieRemote.swift
//  MovieDemo
//
//  Created by Foodstory on 5/10/2565 BE.
//

import UIKit
import FirebaseDatabase
import FirebaseFirestore

public class MovieRemote {
    
    static let shared = MovieRemote()
    
    var db: Firestore?
    var ref: DatabaseReference!

    init() {
        
        let settings = FirestoreSettings()
        Firestore.firestore().settings = settings
        
        db = Firestore.firestore()
        ref = Database.database().reference()
    }
    
    func fetchMovie(with name: String, completion: @escaping (_ success: Bool, _ errorMessage: String?, _ result: [Movie]?)-> Void) {
        
        MovieService.getMovie(with: name) { success, errorMessage, result in
            
            completion(success, errorMessage, result)
        }
    }
    
    func fetchMovieFavorite(of userId: String,
                            completion: @escaping (_ success: Bool, _ errorMessage: String?, _ result: QuerySnapshot?)-> Void) {
                
        db?.collection(userId).getDocuments() { (querySnapshot, err) in
            
            completion(err == nil, err?.localizedDescription, querySnapshot)
        }
    }
    
    func updateMovieStatus(with movie: MD_Movie, userId: String,
                           completion: @escaping (_ success: Bool, _ errorMessage: String?, _ documentId: String?)-> Void) {
        
        var ref: DocumentReference? = nil
        
        ref = db?.collection(userId).addDocument(data: [
            "malId": movie.malId,
            "title": movie.title ?? "",
            "score": movie.score,
            "image": movie.image ?? "",
            "small_image": movie.smallImage ?? "",
            "large_image": movie.largeImage ?? ""
        ]) { err in
            
            completion(err == nil, err?.localizedDescription, ref?.documentID)
        }
    }
    
    func removeFavoriteMovie(from userId: String, documentId: String,
                             completion: @escaping (_ success: Bool, _ errorMessage: String?)-> Void) {
        
        db?.collection(userId).document(documentId).delete { error in
            
            print(error?.localizedDescription)
            completion(error == nil, error?.localizedDescription)
        }
    }
}
