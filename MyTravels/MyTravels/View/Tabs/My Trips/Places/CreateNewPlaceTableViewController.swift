//
//  CreateNewPlaceTableViewController.swift
//  MyTravels
//
//  Created by Frank Martin Jr on 2/2/18.
//  Copyright © 2018 Frank Martin Jr. All rights reserved.
//

import UIKit
import MapKit

class CreateNewPlaceTableViewController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, CLLocationManagerDelegate {
    
    // MARK: - Properties
    var trip: Trip? {
        didSet {
            print("hello")
        }
    }
    let imagePickerController = UIImagePickerController()
    var photo: Data?
    var rating: Int16 = 0
    var photos: [Data] = []
    let locationManager = CLLocationManager()
    var usersLocation = CLLocationCoordinate2D()
    
    var stars: [UIImageView] = []
    
    // MARK: - IBOutlets
    @IBOutlet weak var starOne: UIImageView!
    @IBOutlet weak var starTwo: UIImageView!
    @IBOutlet weak var starThree: UIImageView!
    @IBOutlet weak var starFour: UIImageView!
    @IBOutlet weak var starFive: UIImageView!
    
    @IBOutlet weak var placeNameTextField: UITextField!
    @IBOutlet weak var placeTypeTextField: UITextField!
    @IBOutlet weak var placeAddressTextView: UITextView!
    @IBOutlet weak var placeCommentsTextView: UITextView!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let stars: [UIImageView] = [starOne, starTwo, starThree, starFour, starFive]
        self.stars = stars
        
        guard let addPhotoImage = UIImage(named: "AddTripPhoto256"),
            let addPhotoImageAsData = UIImagePNGRepresentation(addPhotoImage) else { return }
        self.photos.insert(addPhotoImageAsData, at: 0)
        
        imagePickerController.allowsEditing = true
        
        // Delegates
        imagePickerController.delegate = self
        collectionView.delegate = self
        collectionView.dataSource = self
        locationManager.delegate = self
        placeCommentsTextView.delegate = self
        
        // Set textview placeholder text
        placeCommentsTextView.text = "Comments"
        placeCommentsTextView.textColor = #colorLiteral(red: 0.8037719131, green: 0.8036019206, blue: 0.8242246509, alpha: 1)
    }
    
    // MARK: - IBActions
    @IBAction func cancelButtonTapped(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveButtonTapped(_ sender: UIBarButtonItem) {
        
        // Check to see if any required fields are empty, if so, present alertcontroller and jump out of function
        guard let placeNameTF = placeNameTextField,
            let placeTypeTF = placeTypeTextField,
            let placeAddressTV = placeAddressTextView
            else { return }
        
        let textFields = [placeNameTF, placeTypeTF, placeAddressTV]
        
        if placeNameTextField.text?.isEmpty == true ||
            placeTypeTextField.text == "Choose a type" ||
            placeAddressTextView.text?.isEmpty == true  {
            //            missingFieldAlert(textFields: textFields)
            return
        }
        
        guard let trip = self.trip,
            let name = placeNameTextField.text,
            let type = placeTypeTextField.text,
            let address = placeAddressTV.text,
            let comments = placeCommentsTextView.text
            else { return }
        
        self.photos.remove(at: 0)
        
        PlaceController.shared.create(name: name, type: type, address: address, comments: comments, rating: rating, trip: trip)
        guard let place = PlaceController.shared.place else { return }
        
        if self.photos.count > 0 {
            PhotoController.shared.add(photos: self.photos, place: place)
            dismiss(animated: true, completion: nil)
        }
        
        dismiss(animated: true, completion: nil)
        
    }
    
    @IBAction func addPhotoButtonTapped(_ sender: UIButton) {
        present(imagePickerController, animated: true, completion: nil)
        
    }
    
    // MARK: - Tap gesture recognizers
    // Star rating
    @IBAction func starOneGestureRecognizerTapped(_ sender: UITapGestureRecognizer) {
        calculateStars(starTapped: 0)
    }
    
    @IBAction func starTwoGestureRecognizerTapped(_ sender: UITapGestureRecognizer) {
        calculateStars(starTapped: 1)
    }
    
    @IBAction func starThreeGestureRecognizerTapped(_ sender: UITapGestureRecognizer) {
        calculateStars(starTapped: 2)
    }
    
    @IBAction func starFourGestureRecognizerTapped(_ sender: UITapGestureRecognizer) {
        calculateStars(starTapped: 3)
    }
    
    @IBAction func starFiveGestureRecognizerTapped(_ sender: UITapGestureRecognizer) {
        calculateStars(starTapped: 4)
    }
    
    @IBAction func typeTapGestureRecognizerTapped(_ sender: Any) {
        performSegue(withIdentifier: "toTypeSelectionViewController", sender: self)
        
    }
    
    @IBAction func addressTapGestureRecognizerTapped(_ sender: UITapGestureRecognizer) {
        locationManager.requestWhenInUseAuthorization()
        guard let searchVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "searchVC") as? SearchViewController else { return }
        searchVC.delegate = self
        
        present(searchVC, animated: true, completion: nil)
    }
}

extension CreateNewPlaceTableViewController {
    func getLocation() {
        func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
            guard let coordinate = locations.last?.coordinate else { return }
            usersLocation = coordinate
        }
    }
    
    func calculateStars(starTapped: Int) {
        if starTapped == 4 {
            for star in 0...4 {
                self.stars[star].image = UIImage(named: "star-black-16")
            }
            rating = Int16(starTapped)
            return
        }
        
        for star in 0...starTapped {
            self.stars[star].image = UIImage(named: "star-black-16")
        }
        
        for star in (starTapped + 1)...4 {
            self.stars[star].image = UIImage(named: "star-clear-16")
        }
        
        rating = Int16(starTapped)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "ToTypeSelectionViewControllerSegue" {
            guard let destinationVC = segue.destination as? TypeSelectionViewController else { return }
            destinationVC.delegate = self
        }
        
        if segue.identifier == "ToSearchViewControllerSegue" {
            guard let destinationVC = segue.destination as? SearchViewController else { return }
            destinationVC.delegate = self
        }
    }
}
    
    // MARK: - Image picker controller delegate methods
    
    extension CreateNewPlaceTableViewController {
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            dismiss(animated: true, completion: nil)
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
            
            guard let photo = info[UIImagePickerControllerEditedImage] as? UIImage,
                let photoAsData = UIImagePNGRepresentation(photo)
                else { return }
            
            self.photos.append(photoAsData)
            
            dismiss(animated: true, completion: collectionView.reloadData)
        }
    }
    
    extension CreateNewPlaceTableViewController: TypeSelectionViewControllerDelegate {
        func set(type: String) {
            placeTypeTextField.text = type
        }
    }
    
    extension CreateNewPlaceTableViewController: UICollectionViewDelegate, UICollectionViewDataSource {
        
        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return photos.count
        }
        
        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCell", for: indexPath) as! PhotoCollectionViewCell
            cell.photo = photos[indexPath.row]
            return cell
            
        }
        
        func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
            
            if indexPath.row == 0 {
                present(imagePickerController, animated: true, completion: nil)
            }
        }
        
    }
    
    extension CreateNewPlaceTableViewController: UITextViewDelegate {
        
        func textViewDidBeginEditing(_ textView: UITextView) {
            
            if self.placeCommentsTextView.text == "Comments" {
                self.placeCommentsTextView.text = ""
                self.placeCommentsTextView.textColor = UIColor.black
            }
        }
        
        func textViewDidEndEditing(_ textView: UITextView) {
            
            if self.placeCommentsTextView.text.isEmpty {
                self.placeCommentsTextView.text = "Comments"
                self.placeCommentsTextView.textColor = UIColor.lightGray
            }
        }
    }
    
    extension CreateNewPlaceTableViewController: SearchViewControllerDelegate {
        func set(address: String) {
            placeAddressTextView.text = address
        }
    }
    
    // MARK: - UITableViewDataSource
    
    extension CreateNewPlaceTableViewController {
        
        override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            switch indexPath.row {
            case 2:
                return UITableViewAutomaticDimension
            case 4:
                return UITableViewAutomaticDimension
            case 5:
                return 150
            default:
                return 60
            }
        }
}
