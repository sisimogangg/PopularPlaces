//
//  VenuePhotosCollectionViewCell.swift
//  PopularPlaces
//
//  Created by Godfrey Sisimogang on 2017/11/28.
//  Copyright © 2017 Godfrey Sisimogang. All rights reserved.
//

import UIKit

class VenuePhotosCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var venuePhotoImageView: UIImageView!
    var photo: VenuePhoto?{
        didSet{
            setPhoto()
        }
    }
    
    private func setPhoto(){
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            if let url = self?.photo?.url {
                if let imageData = try?Data(contentsOf: url){
                    DispatchQueue.main.async {
                        self?.venuePhotoImageView?.image = UIImage(data: imageData)
                    }
                }
            }
        }
    }
    
}
