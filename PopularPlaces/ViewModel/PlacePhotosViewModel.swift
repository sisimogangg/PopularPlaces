//
//  PlacePhotosViewModel.swift
//  PopularPlaces
//
//  Created by Godfrey Sisimogang on 2017/11/30.
//  Copyright © 2017 Godfrey Sisimogang. All rights reserved.
//

import Foundation
import Alamofire

class PlacePhotosViewModel{
    private var venue: SelectedVenue?
    
    private var venuePhotosApi : VenuePhotos?{
        didSet{
            organizePhotoUrls()
        }
    }
    var photosChanged: (()->())?
    var selectedVenuePhotos = [VenuePhoto]()
    var photoSet = false {
        didSet{
            photosChanged?()
        }
    }
    var util:Util
    
    init?(with selectedVenue: SelectedVenue){
        venue = selectedVenue
        util = Util()
        getVenuePhotos()
    }
    
    private func getVenuePhotos(){
        if let id = venue?.id {
            Alamofire.request(util.buildVenuePhotosRequestURL(with: id)).responseData{ [weak self](responseData) -> Void in
                do{
                    self?.venuePhotosApi = try JSONDecoder().decode(VenuePhotos.self, from: responseData.data!)
                }catch let jsonErr{
                    print("Could not decode json", jsonErr)
                }
            }
        }
    }
    
    private func organizePhotoUrls(){
        if let photos = venuePhotosApi?.response?.photos?.items{
            for photo in photos{
                let vPhoto = VenuePhoto(url: URL(string: util.buildPhotoRequestURL(usingPrefix: photo.prefix, andSuffix: photo.suffix)),user: photo.user!, source: photo.source!, venueName: venue?.name ?? "Place Name not available")
                selectedVenuePhotos.append(vPhoto)
            }
            photoSet = true
        }
    }
    
}
