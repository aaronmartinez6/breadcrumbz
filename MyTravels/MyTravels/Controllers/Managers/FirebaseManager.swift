//
//  FirebaseManager.swift
//  MyTravels
//
//  Created by Frank Martin Jr on 9/24/18.
//  Copyright © 2018 Frank Martin Jr. All rights reserved.
//

import Foundation
import FirebaseDatabase
import FirebaseStorage
import FirebaseStorageUI
import FirebaseAuth

protocol FirebaseSyncable {
    var id: String? { get set }
}

class FirebaseManager {
    
    // MARK: - Firebase Database
    
    // Constants & Variables
    static var ref: DatabaseReference! = Database.database().reference()
    static var storeRef: StorageReference! = Storage.storage().reference()
    
    static func save(object: [String : Any?], to databaseReference: DatabaseReference, completion: @escaping (Error?) -> Void) {
        databaseReference.setValue(object) { (error, _) in
            if let error = error {
                print("There was an error saving an object to the database")
                completion(error)
                return
            }
            completion(nil)
        }
    }
    
    static func fetchObject(from ref: DatabaseReference, completion: @escaping (DataSnapshot) -> Void) {

        ref.observeSingleEvent(of: .value) { (snapshot) in
            print("saaf")
            completion(snapshot)
        }
    }
    
    // MARK: - Firebase Auth
    
    static func addUser(with email: String, password: String, username: String, completion: @escaping (User?, Error?) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
            if let error = error {
                
                print("There was an error creating a new user: \(error.localizedDescription)")
                completion(nil, error)
                return
            }
            guard let user = user else { completion(nil, error) ; return }
           
            // Update displayName in Authentication storage
            let changeRequest = user.createProfileChangeRequest()
            changeRequest.displayName = username
            changeRequest.commitChanges(completion: { (error) in
                if let error = error {
                    print(error as Any)
                }
                completion(user, nil)
            })
        }
    }
    
    static func login(with email: String, and password: String, completion: @escaping (User?, Error?) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { (firebaseUser, error) in
            if let error = error {
                completion(nil, error)
                return
            }
            completion(firebaseUser, nil)
        }
    }
    
    static func getLoggedInUser() -> User? {
         return Auth.auth().currentUser
    }
    
    // MARK: - Firebase Storage
    static func saveImages(for trip: Trip, to storeRef: StorageReference, completion: @escaping (Bool) -> Void) {
        FirebaseManager.saveTripPhoto(trip: trip, storeRef: storeRef) { (_) in
            FirebaseManager.savePlacePhotos(for: trip, to: storeRef) { (_) in
                completion(true)
            }
        }
    }
    
    static func saveTripPhoto(trip: Trip, storeRef: StorageReference, completion: @escaping (Bool) -> Void) {
        guard let tripPhoto = trip.photo?.photo else { completion(false) ; return }
        let data = Data(referencing: tripPhoto)
        storeRef.putData(data, metadata: nil) { (_, error) in
            completion(true)            
        }
    }
    
    static func savePlacePhotos(for trip: Trip, to storeRef: StorageReference, completion: @escaping (Bool) -> Void) {
       
        if let places = trip.places?.allObjects as? [Place] {
           
            for place in places {
                
                if let photos = place.photos?.allObjects as? [Photo] {
                   
                    let dispatchGroup = DispatchGroup()
                  
                    for photo in photos {
                      
                    let photoDBRef = FirebaseManager.ref.child("Trip").child(trip.id!).child("places").child(place.name).child("photoURLs").childByAutoId()
                    let photoRef = storeRef.child("Places").child(place.name).child(photoDBRef.key)
                        
                        guard let photoData = photo.photo
                            else { completion(false) ; return }
                        
                        let data = Data(referencing: photoData)
                        
                        dispatchGroup.enter()
                        photoRef.putData(data, metadata: nil) { (metadata, error) in
                            photo.uid = photoRef.name
                            CoreDataManager.save()

                            let photoDictionary: [String : Any] = [photo.uid! : metadata?.downloadURL()?.absoluteString as Any]
                            
                            dispatchGroup.enter()
                            FirebaseManager.save(object: photoDictionary, to: photoDBRef, completion: { (error) in
                                if let error = error {
                                    print(error)
                                    
                                }
                                dispatchGroup.leave()
                            })
                            dispatchGroup.leave()
                        }
                    }
                    
                    dispatchGroup.notify(queue: .main) {
                        completion(true)
                    }
                }
            }
        }
    }
    
    static func fetchImage(storeRef: StorageReference, completion: @escaping (UIImage?) -> Void) {
        storeRef.getData(maxSize: 9999999) { (data, error) in
            if let error = error {
                print("There was an error getting the image: \(error.localizedDescription)")
                completion(nil)
                return
            }

            guard let data = data else { completion(nil) ; return }
            let image = UIImage(data: data)
            completion(image)
        }
    }
    
    static func fetchImages(storeRef: StorageReference, completion: @escaping ([UIImage]?) -> Void) {
      
    }
}

