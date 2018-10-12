//
//  TripController.swift
//  MyTravels
//
//  Created by Frank Martin Jr on 1/30/18.
//  Copyright © 2018 Frank Martin Jr. All rights reserved.
//

import Foundation
import CoreData
import FirebaseDatabase

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
    
    func upload(trip: Trip, completion: @escaping (Bool) -> Void) {
        
        guard let username = InternalUserController.shared.loggedInUser?.username else { return completion(false) }
            // PRESENT ALERT CONTROLLER OR CREATE ACCOUNT
        
        var tripDict = [String : Any]()
        
        tripDict["name"] = trip.name
        tripDict["location"] = trip.location
        tripDict["description"] = trip.tripDescription
        tripDict["startDate"] = trip.startDate?.timeIntervalSince1970
        tripDict["endDate"] = trip.endDate?.timeIntervalSince1970
        
        let tripRef = FirebaseManager.ref.child("Trip").childByAutoId()
        trip.id = tripRef.key
        CoreDataManager.save()
        
        FirebaseManager.save(object: tripDict, to: tripRef) { (error) in
            if let _ = error {
                completion(false)
            }
            
            let userTripRef = FirebaseManager.ref.child("\(username) / + \(trip.id ?? "")")
            
            let tripID : [String : Any] = ["tripID" : trip.id]
            
            FirebaseManager.save(object: tripID, to: userTripRef, completion: { (error) in
                if let error = error {
                    print(error)
                    completion(false)
                }
            })
            
            completion(true)
        }
    }
}

