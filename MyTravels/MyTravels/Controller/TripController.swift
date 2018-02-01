//
//  TripController.swift
//  MyTravels
//
//  Created by Frank Martin Jr on 1/30/18.
//  Copyright © 2018 Frank Martin Jr. All rights reserved.
//

import Foundation
import CoreData

class TripController {
    
    // MARK: - Properties
    static var shared = TripController()
    var frc: NSFetchedResultsController<Trip> = {
        let fetchRequest: NSFetchRequest<Trip> = Trip.fetchRequest()
        
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "location", ascending: true)]
        
        return NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: CoreDataStack.context, sectionNameKeyPath: nil, cacheName: nil)
    }()
    
    // MARK: - CRUD Functions
    
    // Create
    func create(trip: Trip) {
        
        saveToPersistentStore()
        
    }
    
    func delete(trip: Trip) {
        trip.managedObjectContext?.delete(trip)
        saveToPersistentStore()
    }
    
    
    // Save to Core Data
    func saveToPersistentStore() {
        do {
            try CoreDataStack.context.save()
        } catch let error {
            print("Error saving Managed Object Context (Trip): \(error)")
        }
    }
    
}

