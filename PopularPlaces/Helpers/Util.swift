//
//  Util.swift
//  PopularPlaces
//
//  Created by Godfrey Sisimogang on 2017/11/25.
//  Copyright © 2017 Godfrey Sisimogang. All rights reserved.
//

import Foundation
import CoreLocation

struct Util {
    static let client_id = "ZJTPTUS5BSNCE5VOP2ZMHVJ5D2HY2T5V2LJF3GGT5ESVRCTM"
    static let client_secret = "PGPLB4DUMM4S4JIQFCGSEOTZRL41JKLVA5OORKZCLOK1ZLV5"
    static let photo_size = "300x300"
    
    func buildRequestURL(using currentLocation: CLLocation) -> String{
        return "https://api.foursquare.com/v2/search/recommendations?ll=\(currentLocation.coordinate.latitude),\(currentLocation.coordinate.longitude)&v=20171121&intent=browse&limit=15&client_id=\(Util.client_id)&client_secret=\(Util.client_secret)"
    }
    
    func buildPhotoRequestURL(usingPrefix prefix: String, andSuffix suffix: String) -> String{
        return "\(prefix)\(Util.photo_size)\(suffix)"
    }
    
    func buildVenuePhotosRequestURL(with venueId: String) -> String {
        return "https://api.foursquare.com/v2/venues/\(venueId)/photos?client_id=\(Util.client_id)&client_secret=\(Util.client_secret)&v=20171121"
    }
}
