//
//  SharedPlaceDetailTableViewController.swift
//  MyTravels
//
//  Created by Frank Martin Jr on 3/13/18.
//  Copyright © 2018 Frank Martin Jr. All rights reserved.
//

import UIKit

class SharedPlaceDetailTableViewController: UITableViewController {
    
    // MARK: Properties
    var sharedTrip: SharedTrip?
    var sharedPlace: SharedPlace?
    
    var photos: [Photo] = []
    
    // MARK: - IBOutlets
    @IBOutlet weak var sharedPlaceMainPhotoImageView: UIImageView!
    @IBOutlet weak var sharedPlaceNameLabel: UILabel!
    @IBOutlet weak var sharedPlaceAddressLabel: UILabel!
    @IBOutlet var sharedPlaceCommentsTextView: UITextView!
    
    @IBOutlet weak var starOne: UIImageView!
    @IBOutlet weak var starTwo: UIImageView!
    @IBOutlet weak var starThree: UIImageView!
    @IBOutlet weak var starFour: UIImageView!
    @IBOutlet weak var starFive: UIImageView!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Delegates
        collectionView.delegate = self
        collectionView.dataSource = self
        
        tableView.contentOffset = CGPoint(x: 30, y: 30)
        
        guard let sharedPlace = sharedPlace
            else { return }
        self.title = sharedPlace.name
        updateViewsForSharedPlace()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateViewsForSharedPlace()
        collectionView.reloadData()
    }
    
    // MARK: - Functions
    
    func updateViewsForSharedPlace() {
        guard let sharedPlace = sharedPlace,
            let photos = sharedPlace.photos
            else { return }
        
        if photos.count > 0 {
            guard let photo = photos.first,
                let image = UIImage(data: photo) else { return }
            sharedPlaceMainPhotoImageView.image = image
            sharedPlaceNameLabel.text = sharedPlace.name
            sharedPlaceAddressLabel.text = sharedPlace.address
            updateStarsImageViews(sharedPlace: sharedPlace)
            
        } else {
            var placeholderImage = UIImage()
            if sharedPlace.type == "Lodging" {
                guard let lodgingPlaceholderImage = UIImage(named: "Lodging") else { return }
                placeholderImage = lodgingPlaceholderImage
            } else if sharedPlace.type == "Restaurant" {
                guard let restaurantPlaceholderImage = UIImage(named: "Restaurant") else { return }
                placeholderImage = restaurantPlaceholderImage
            } else if sharedPlace.type == "Activity" {
                guard let activityPlaceholderImage = UIImage(named: "Activity") else { return }
                placeholderImage = activityPlaceholderImage
            }
            sharedPlaceMainPhotoImageView.image = placeholderImage
            sharedPlaceNameLabel.text = sharedPlace.name
            sharedPlaceAddressLabel.text = sharedPlace.address
            updateStarsImageViews(sharedPlace: sharedPlace)
        }
    }
    
    func updateStarsImageViews(sharedPlace: SharedPlace) {
        guard let sharedPlaceRating = sharedPlace.rating else { return }
        let starImageViewsArray = [starOne, starTwo, starThree, starFour, starFive]
        
        if sharedPlace.rating == 0 {
            for starImageView in starImageViewsArray {
                starImageView?.image = UIImage(named: "star-clear-16")
            }
        } else if Int(sharedPlaceRating) > 0 {
            var i = 0
            
            while i < Int(sharedPlaceRating) {
                starImageViewsArray[i]?.image = UIImage(named: "star-black-16")
                i += 1
            }
            
            while i <= starImageViewsArray.count - 1 {
                starImageViewsArray[i]?.image = UIImage(named: "star-clear-16")
                i += 1
            }
        }
    }
}

extension SharedPlaceDetailTableViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        guard let sharedPlace = sharedPlace,
            let sharedPlacePhotos = sharedPlace.photos
            else { return 0 }
        
        return sharedPlacePhotos.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCell", for: indexPath) as! PhotoCollectionViewCell
        
        guard let sharedPlace = sharedPlace,
            let sharedPlacePhotos = sharedPlace.photos
            else { return UICollectionViewCell() }
        
        cell.sharedPlacePhoto = sharedPlacePhotos[indexPath.row]
        
        return cell
    }
    
}
