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
    
    static var shared = PlaceController()
    var frc: NSFetchedResultsController<Place> = {
        let fetchRequest: NSFetchRequest<Place> = Place.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        
        return NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: CoreDataStack.context, sectionNameKeyPath: nil, cacheName: nil)
    
    }()
    
    // CRUD Functions
    
    // Create
    func create(name: String, type: String, address: String, comments: String, recommendation: Bool, photo: Data, trip: Trip) {
        let newPlace = Place(name: name, type: type, address: address, comments: comments, recommendation: recommendation, photo: photo, trip: trip)
        saveToPersistentStore()
        
    }
    
    func delete(place: Place) {
        place.managedObjectContext?.delete(place)
        saveToPersistentStore()
    }
    
    func saveToPersistentStore() {
        do {
            try CoreDataStack.context.save()
        } catch let error {
            print("Error saving Managed Object Context (Place): \(error)")
            
        }
    }
}
