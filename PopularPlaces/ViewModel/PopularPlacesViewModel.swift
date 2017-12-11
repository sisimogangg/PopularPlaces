//
//  PopularPlacesViewModel.swift
//  PopularPlaces
//
//  Created by Godfrey Sisimogang on 2017/11/30.
//  Copyright © 2017 Godfrey Sisimogang. All rights reserved.
//

import Foundation
import CoreLocation
import Alamofire
import os

class PopularPlacesViewModel {
    var currentLocation: CLLocation?
    var foursquareApi: FoursQuarePlace?{
        didSet{
            populatePlaces()
        }
    }
    var placesChanged: (()->())?
    var places = [Venue]()
    var placesSet = false {
        didSet {
            placesChanged?()
        }
    }
    var util:Util
    
    init?(using location: CLLocation){
        self.currentLocation = location
        util = Util()
        getFourSquareData()
    }
    
    
    private func getFourSquareData(){
        guard let location = currentLocation else{
            os_log("Could not retrieve current location, please give Popular Places location consent", log: OSLog.default, type: .debug)
            return
        }
        Alamofire.request(util.buildRequestURL(using: location)).responseData{ [weak self](responseData) -> Void in
            do {
                self?.foursquareApi = try JSONDecoder().decode(FoursQuarePlace.self, from: responseData.data!)
                
            }catch let jsonErr {
                print("Could not decode json", jsonErr)
            }
        }
    }
    
    
    private func populatePlaces(){
        
        if let placeResults = foursquareApi?.response?.group?.results{
            for (index,place) in placeResults.enumerated(){
                var name = "" , photoUrl = URL(string:""), checkins = 0 , address = "", rating = 0, users = 0, id = "", lat = 0.0 , lon =  0.0
                if let venue = place.venue ,let venueName = venue.name{
                    id = venue.id
                    name = venueName
                    address = getCustomAddress(using: index)
                    // Divide rating by 2 since we only have five stars
                    let div = venue.rating / 2
                    rating = Int(div)
                    
                    if let photo = place.photo {
                        photoUrl = URL(string: util.buildPhotoRequestURL(usingPrefix: photo.prefix, andSuffix: photo.suffix))
                    }
                    
                    if let location = venue.location{
                       lat = location.lat!
                        lon = location.lng!
                    }
                    
                    if let stats = venue.stats {
                        checkins = stats.checkinsCount
                        users = stats.usersCount
                    }
                    places.append(Venue(id: id,name: name,address: address,photoUrl: photoUrl,checkins: checkins, rating: rating, users: users, lat: lat, lon:lon))
                    
                }
            }
            placesSet = true
        }
    }
    
    
    // To Refactor later
    private func getCustomAddress(using index: Int) -> String{
        var customAddress = ""
        let place =  foursquareApi?.response?.group?.results![index]
        if let venue = place?.venue{
            if let address = venue.location?.address{
                return address
            }  else{
                if let city = venue.location?.city{
                    customAddress = city
                }
                if let state = venue.location?.state {
                    if customAddress != "" {
                        customAddress += ","
                    }
                    customAddress += " \(state)"
                }
                if let country = venue.location?.country {
                    if customAddress != "" {
                        customAddress += ","
                    }
                    customAddress += " \(country)"
                }
                return customAddress
            }
        }
        return "No Address"
    }
    
    
    
}
