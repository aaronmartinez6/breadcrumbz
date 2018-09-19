//
//  TripController.swift
//  MyTravels
//
//  Created by Frank Martin Jr on 1/30/18.
//  Copyright © 2018 Frank Martin Jr. All rights reserved.
//

import Foundation
import CoreData
import CloudKit

class TripController {
    
    // MARK: - Properties
    static var shared = TripController()
    var frc: NSFetchedResultsController<Trip> = {
        let fetchRequest: NSFetchRequest<Trip> = Trip.fetchRequest()
        
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "startDate", ascending: false)]
        
        return NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: CoreDataStack.context, sectionNameKeyPath: nil, cacheName: nil)
    }()
    
    var trip: Trip?
    var trips: [Trip] = []
    
    // MARK: - CRUD Functions
    // Create
    func createTripWith(name: String, location: String, tripDescription: String?, startDate: Date, endDate: Date) {
        let trip = Trip(name: name, location: location, tripDescription: tripDescription, startDate: startDate, endDate: endDate)
        self.trip = trip
        CoreDataManager.save()
    }
    
    func save(trip: Trip) {
        guard let record = CKRecord(trip: trip) else { return }
        CloudKitManager.shared.saveToCloudKit(ckRecord: record) { (success) in
        }
    }
    
    func delete(trip: Trip) {
        CoreDataManager.delete(object: trip)
    }
    
    func fetchAllTrips() {
        do {
            try frc.performFetch()
        } catch {
            NSLog("Error starting fetched results controller")
        }
        
        guard let trips = frc.fetchedObjects else { return }
        self.trips = trips
    }
}

