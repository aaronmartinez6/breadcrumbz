//
//  TripTableViewCell
//  MyTravels
//
//  Created by Frank Martin Jr on 1/30/18.
//  Copyright © 2018 Frank Martin Jr. All rights reserved.
//

import UIKit

class TripTableViewCell: UITableViewCell {
    
    // MARK: - Properties
    var trip: Trip? {
        didSet {
            updateViews()
        }
    }
    
    // MARK: - IBOutlets
    // Trip
    @IBOutlet weak var tripImageView: UIImageView!
    @IBOutlet weak var tripNameLabel: UILabel!
    @IBOutlet weak var tripDatesLabel: UILabel!
    @IBOutlet weak var tripStartDateLabel: UILabel!
    @IBOutlet weak var tripEndDateLabel: UILabel!
    
    // MARK: - Functions
    func updateViews() {
        
        tripImageView.layer.cornerRadius = 4
        tripImageView.clipsToBounds = true
        
        guard let trip = trip,
            let startDate = trip.startDate,
            let endDate = trip.endDate,
            let photo = trip.photo?.photo
            else { return }
        
        let image = UIImage(data: photo)
        tripImageView.image = image
        tripNameLabel.text = trip.location
        
        tripStartDateLabel.text = "\(shortDateString(date: startDate)) -"
        tripEndDateLabel.text = shortDateString(date: endDate)
    
    }
    
    func shortDateString(date: Date) -> String {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        let date = dateFormatter.string(from: date)
        
        return date
        
    }

}
