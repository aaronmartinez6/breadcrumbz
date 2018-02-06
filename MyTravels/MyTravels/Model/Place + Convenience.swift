//
//  Place + Convenience.swift
//  MyTravels
//
//  Created by Frank Martin Jr on 1/30/18.
//  Copyright © 2018 Frank Martin Jr. All rights reserved.
//

import Foundation
import CoreData

extension Place {
    
    convenience init(name: String, type: String, address: String, comments: String, rating: Int16, trip: Trip, context: NSManagedObjectContext = CoreDataStack.context) {
        
        self.init(context: context)
        self.name = name
        self.type = type
        self.address = address
        self.comments = comments
        self.rating = rating
        self.trip = trip
        
    }


// FIXME: - CloudKit convenience initializer

}