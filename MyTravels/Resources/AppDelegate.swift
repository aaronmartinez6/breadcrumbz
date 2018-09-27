//
//  AppDelegate.swift
//  MyTravels
//
//  Created by Frank Martin Jr on 1/30/18.
//  Copyright © 2018 Frank Martin Jr. All rights reserved.
//

import UIKit
import CoreData
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        FirebaseApp.configure()
        
//        TripController.shared.upload(with: "test", location: "test", tripDescription: "test", startDate: "test", endDate: "test")
        let trip = Trip(name: "asdsF", location: "afsafas", tripDescription: "adsdsa", startDate: Date(), endDate: Date())
        TripController.shared.upload(trip: trip)
        
        return true
    }
}

