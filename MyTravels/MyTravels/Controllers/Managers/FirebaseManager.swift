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
    
    
    // Constants & Variables
    static var ref: DatabaseReference! = Database.database().reference()
    static var storeRef: StorageReference! = Storage.storage().reference()
    
    // MARK: - Firebase Database
    
    static func saveSingleObject(_ object: Any, to databaseReference: DatabaseReference, completion: @escaping (Error?) -> Void) {
        databaseReference.setValue(object) { (error, _) in
            if let error = error {
                print("There was an error saving an object to the database")
                completion(error)
                return
            }
            completion(nil)
        }
    }
    
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
    
    static func removeObject(ref: DatabaseReference, completion: @escaping (Error?) -> Void) {
        ref.removeValue { (error, _) in
            completion(error)
        }
    }
    
    static func fetchObject(from ref: DatabaseReference, completion: @escaping (DataSnapshot) -> Void) {

        ref.observeSingleEvent(of: .value) { (snapshot) in
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
    
    static func save(data: Data, to storeRef: StorageReference, completion: @escaping (StorageMetadata?, Error?) -> Void) {
        storeRef.putData(data, metadata: nil) { (metadata, error) in
            completion(metadata, error)
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
}


