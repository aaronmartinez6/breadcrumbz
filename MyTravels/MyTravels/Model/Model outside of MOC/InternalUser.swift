//
//  User.swift
//  MyTravels
//
//  Created by Frank Martin Jr on 2/9/18.
//  Copyright © 2018 Frank Martin Jr. All rights reserved.
//

import Foundation
import FirebaseDatabase

class InternalUser {
    
    let firstName: String
    let lastName: String?
    let email: String
    var uid: String?
    
    init(firstName: String, lastName: String?, email: String) {
        self.firstName = firstName
        self.lastName = lastName
        self.email = email
    }
    
    // Turn snapshot into User
    init?(snapshot: DataSnapshot) {
        
        guard let tripDict = snapshot.value as? [String : Any],
            let firstName = tripDict["firstName"] as? String,
            let lastName = tripDict["lastName"] as? String?,
            let username = tripDict["email"] as? String
            //FIXME profle pic
            else { return nil }
        
        self.firstName = firstName
        self.lastName = lastName
        self.email = username
        // FIX ME
        //        self.profilePicture = photoData
        // FIX ME - Set UID - Am I going to need this? May be set when user signs in/registers.
    }
}
