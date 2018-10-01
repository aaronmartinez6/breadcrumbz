//
//  PlaceController.swift
//  MyTravels
//
//  Created by Frank Martin Jr on 1/30/18.
//  Copyright © 2018 Frank Martin Jr. All rights reserved.
//

import Foundation
import CoreData

class PlaceController {
    
    // MARK: - Properties
    static var shared = PlaceController()
    var frc: NSFetchedResultsController<Place> = {
        let fetchRequest: NSFetchRequest<Place> = Place.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        
        return NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: CoreDataStack.context, sectionNameKeyPath: nil, cacheName: nil)
    }()
    
    var place: Place?
    var places: [Place] = []
    
    // CRUD Functions
    // Create
    func create(name: String, type: String, address: String, comments: String, rating: Int16, trip: Trip) {
        let newPlace = Place(name: name, type: type, address: address, comments: comments, rating: rating, trip: trip)
        self.place = newPlace
        CoreDataManager.save()
    }
    
    // Update
    func update(place: Place, name: String, type: String, address: String, comments: String, rating: Int16, trip: Trip) {
        place.name = name
        place.type = type
        place.address = address
        place.comments = comments
        place.rating = rating
        place.trip = trip
        
        self.place = place
        
        CoreDataManager.save()
    }
    
    // Delete
    func delete(place: Place) {
        CoreDataManager.delete(object: place)
    }
    
    func uploadPlaces(for trip: Trip, completion: @escaping (Bool) -> Void) {
        guard let tripUID = trip.uid, let places = trip.places?.allObjects as? [Place] else { return }
        
        let dispatchGroup = DispatchGroup()
        for place in places {
            dispatchGroup.enter()
            let ref = FirebaseManager.ref.child(tripUID).childByAutoId()
            
            let placeDict: [String : Any] = ["name" : place.name ?? "",
                                             "type" : place.type ?? "",
                                             "address" : place.address ?? "",
                                             "rating" : place.rating,
                                             "comments" : place.comments ?? ""
            ]
            FirebaseManager.save(object: placeDict, to: ref) { (error) in
                if let error = error {
                    print("Error saving data in uploadPlaces: \(error)"
                    completion(false)
                    return
                }
            }
            dispatchGroup.leave()
        }
        
        dispatchGroup.notify(queue: .main) {
            completion(true)
        }
    }
    
    
}
