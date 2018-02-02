//
//  TripDetailViewController.swift
//  MyTravels
//
//  Created by Frank Martin Jr on 1/31/18.
//  Copyright © 2018 Frank Martin Jr. All rights reserved.
//

import UIKit
import CoreData

class TripDetailViewController: UIViewController, NSFetchedResultsControllerDelegate {
    
    // MARK: - Properties
    var trip: Trip? {
        didSet {
            print("Trip name: \(trip?.location)")
        }
    }
    var array: Array<Any>?
    var i = 0
    // MARK: - IBOutlets
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        // Delegates
        tableView.delegate = self
        tableView.dataSource = self
        PlaceController.shared.frc.delegate = self
        
        // Table view properties
        tableView.separatorStyle = .none
        
        setUpArrays()
       
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setUpArrays()
    }
    
    // MARK: - Functions
    func setUpArrays() {
        guard let trip = trip,
            let places = trip.places
            else { return }
        let placesArray = places.allObjects
        print(placesArray.count)
        var array: [[Place]] = []
        var lodgingArray: [Place] = []
        var restaurantsArray: [Place] = []
        var activitiesArray: [Place] = []
        
        for place in placesArray {
            
            guard let placeAsPlace = place as? Place else { return }
            
            if placeAsPlace.type == "Lodging" {
                lodgingArray.append(placeAsPlace)
                
            } else if placeAsPlace.type == "Restaurant" {
                restaurantsArray.append(placeAsPlace)
                
            } else if placeAsPlace.type == "Activity" {
                activitiesArray.append(placeAsPlace)
            }
            
        }
        
        if lodgingArray.count > 0 {
            array.append(lodgingArray)
        }
        
        if restaurantsArray.count > 0 {
            array.append(restaurantsArray)
        }
        
        if activitiesArray.count > 0 {
            array.append(activitiesArray)
        }
        
        print("Array count: \(array.count)")
        print("Full array: \(array)")
        self.array = array
        tableView.reloadData()
    }
    
    // MARK: - Fetched  Resuts Controller Delegate methods
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        switch type {
        case .delete:
            guard let indexPath = indexPath else { return }
            tableView.deleteRows(at: [indexPath], with: .fade)
        case .insert:
            guard let newIndexPath = newIndexPath else { return }
            tableView.insertRows(at: [newIndexPath], with: .automatic)
            
        case .move:
            guard let indexPath = indexPath,
                let newIndexPath = newIndexPath else { return }
            tableView.moveRow(at: indexPath, to: newIndexPath)
        case .update:
            guard let indexPath = indexPath else { return }
            tableView.reloadRows(at: [indexPath], with: .automatic)
        }
    }
    
    
     // MARK: - Navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
       
        if segue.identifier == "toCreateNewPlaceSegue" {
            guard let destinationVC = segue.destination as? CreateNewPlaceViewController,
                let trip = self.trip
                else { return }

            destinationVC.trip = trip
            
        }
     }

}

extension TripDetailViewController: UITableViewDelegate, UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        guard let array = array else { return 0 }
        
        return array.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard let placeArray = array as? [[Place]] else { return "Section" }
        
         return placeArray[section].first?.type
    }


    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        guard let placeArray = array as? [[Place]] else { return 0 }
        return placeArray[section].count
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "PlaceCell", for: indexPath) as! TripPlaceTableViewCell
        
        guard let placeArray = array as? [[Place]] else { return UITableViewCell() }
        let place = placeArray[indexPath.section][indexPath.row]
        
        
        cell.place = place
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            guard let placeArray = array as? [[Place]] else { return }
            let place = placeArray[indexPath.section][indexPath.row]
            PlaceController.shared.delete(place: place)
            setUpArrays()

        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
}
