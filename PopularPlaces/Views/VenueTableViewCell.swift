//
//  PlaceTableViewCell.swift
//  PopularPlaces
//
//  Created by Godfrey Sisimogang on 2017/11/26.
//  Copyright © 2017 Godfrey Sisimogang. All rights reserved.
//

import UIKit

class VenueTableViewCell: UITableViewCell {
    @IBOutlet weak var placeNameLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var checkinsLabel: UILabel!
    @IBOutlet weak var placePhotoImageView: UIImageView!
    @IBOutlet weak var ratingStars: RatingView!
    @IBOutlet weak var userCountLabel: UILabel!
    
    var venue: Venue?{
        didSet{
            updateCell()
        }
    }
    
    
    private func updateCell(){
        
        guard let place = venue else {
            return
        }
        ratingStars.rating = place.rating
        placeNameLabel.text = place.name
        addressLabel.text = place.address
        checkinsLabel.text = "Checkins:\(place.checkins)"
        userCountLabel.text = "Users: \(place.users)"
        DispatchQueue.global(qos: .userInitiated).async {  [weak self] in
            if let photoUrl = place.photoUrl{
                if let imageData = try?Data(contentsOf: photoUrl){
                    DispatchQueue.main.async {
                        self?.placePhotoImageView?.image = UIImage(data: imageData)
                    }
                }
            }else {
                DispatchQueue.main.async {
           
                    self?.placePhotoImageView?.image = UIImage(named:"defaultPhoto")
                }
            }
        }
        
    }
}
