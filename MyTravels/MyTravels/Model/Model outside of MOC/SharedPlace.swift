//
//  LocalPlace.swift
//  MyTravels
//
//  Created by Frank Martin Jr on 2/16/18.
//  Copyright © 2018 Frank Martin Jr. All rights reserved.
//

import UIKit
import CloudKit

class SharedPlace {
    
    var address: String?
    var comments: String?
    var name: String?
    var rating: Int16?
    var type: String?
    var photos: [UIImage]?

    // CloudKit - Turn a record into a Place
    init?(dictionary: [String : Any]) {
        
        guard let name = dictionary["name"] as? String,
            let address = dictionary["address"] as? String,
            let rating = dictionary["rating"] as? Int16,
            let type = dictionary["type"] as? String,
            let comments = dictionary["comments"] as? String
            else { return nil }
    
        self.name = name
        self.address = address
        self.rating = rating
        self.type = type
        self.comments = comments
    }
}
