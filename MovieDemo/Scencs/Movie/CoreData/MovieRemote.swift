//
//  MovieRemote.swift
//  MovieDemo
//
//  Created by Foodstory on 5/10/2565 BE.
//

import UIKit
import FirebaseFirestore

public class MovieRemote {
    
    static let shared = MovieRemote()
    
    var db: Firestore?
    
    init() {
        
        let settings = FirestoreSettings()
        Firestore.firestore().settings = settings
        
        db = Firestore.firestore()
    }
    
    func fetchAnime(with name: String, completion: @escaping (_ success: Bool, _ errorMessage: String?, _ result: [Movie]?)-> Void) {
        
        MovieService.getAnime(with: name) { success, errorMessage, result in
            
            completion(success, errorMessage, result)
        }
    }
    
    func fetchMovieFavorite(of userId: String) {
        
        db?.collection(userId).getDocuments() { (querySnapshot, err) in
            
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    print("\(document.documentID) => \(document.data())")
                }
            }
        }
    }
    
    func updateMovieStatus(with movie: MD_Movie, isFavorite: Bool, completion: @escaping (_ success: Bool, _ errorMessage: String?, _ result: [MD_Movie]?)-> Void) {
        
        var ref: DocumentReference? = nil
        ref = db?.collection("users").addDocument(data: [
            "first": "Ada",
            "last": "Lovelace",
            "born": 1815
        ]) { err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                print("Document added with ID: \(ref!.documentID)")
            }
        }
    }
}
