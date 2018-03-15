//
//  Trip+CoreDataProperties.swift
//  MyTravels
//
//  Created by Frank Martin Jr on 3/14/18.
//  Copyright © 2018 Frank Martin Jr. All rights reserved.
//
//

import Foundation
import CoreData


extension Trip {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Trip> {
        return NSFetchRequest<Trip>(entityName: "Trip")
    }

    @NSManaged public var cloudKitRecordIDString: String?
    @NSManaged public var endDate: NSDate?
    @NSManaged public var location: String?
    @NSManaged public var startDate: NSDate?
    @NSManaged public var name: String?
    @NSManaged public var tripDescription: String?
    @NSManaged public var photo: Photo?
    @NSManaged public var places: NSSet?
    @NSManaged public var usersSharedWithRecordIDs: NSSet?

}

// MARK: Generated accessors for places
extension Trip {

    @objc(addPlacesObject:)
    @NSManaged public func addToPlaces(_ value: Place)

    @objc(removePlacesObject:)
    @NSManaged public func removeFromPlaces(_ value: Place)

    @objc(addPlaces:)
    @NSManaged public func addToPlaces(_ values: NSSet)

    @objc(removePlaces:)
    @NSManaged public func removeFromPlaces(_ values: NSSet)

}

// MARK: Generated accessors for usersSharedWithRecordIDs
extension Trip {

    @objc(addUsersSharedWithRecordIDsObject:)
    @NSManaged public func addToUsersSharedWithRecordIDs(_ value: UsersSharedWithRecordIDs)

    @objc(removeUsersSharedWithRecordIDsObject:)
    @NSManaged public func removeFromUsersSharedWithRecordIDs(_ value: UsersSharedWithRecordIDs)

    @objc(addUsersSharedWithRecordIDs:)
    @NSManaged public func addToUsersSharedWithRecordIDs(_ values: NSSet)

    @objc(removeUsersSharedWithRecordIDs:)
    @NSManaged public func removeFromUsersSharedWithRecordIDs(_ values: NSSet)

}
