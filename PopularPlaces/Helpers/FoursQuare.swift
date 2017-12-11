//
//  Places.swift
//  PopularPlaces
//
//  Created by Godfrey Sisimogang on 2017/11/25.
//  Copyright © 2017 Godfrey Sisimogang. All rights reserved.
//

import Foundation

// Venue Photos API
struct VenuePhotos: Decodable {
    let response : PhotoResponse?
}

struct PhotoResponse: Decodable {
    let photos : Photos?
    
}

struct Photos : Decodable{
    let count : Int
    let items : [PhotoItem]?
    
}

struct PhotoItem : Decodable {
    let id : String
    let source: Source?
    let prefix : String
    let suffix: String
    let user : User?
    
}

struct Source : Decodable{
    let name: String
}

struct User: Decodable {
    let firstName : String?
    let lastname : String?
}


// Recommendations API
struct FoursQuarePlace :Decodable {
    let meta : Meta?
    let response : Response?
}

struct Meta : Decodable {
    let code : Int?
    let requestId : String?
}

struct Response : Decodable {
    let group : Group?
}
struct Group : Decodable {
    let results : [Result]?
    let totalResults : Int?
}

struct Result : Codable {
    let id : String?
    let venue : VenueDetails?
    let photo : Photo?
}

struct VenueDetails : Codable {
    let id : String
    let name : String?
    let contact : Contact?
    let location : Location?
    let stats : Stats?
    let rating : Float
}

struct Contact : Codable {
    let phone : String?
    let formattedPhone : String?
}

struct Stats : Codable {
    let checkinsCount : Int
    let usersCount : Int
    let tipCount : Int
}

struct Location : Codable {
    let address : String?
    let lat : Double?
    let lng : Double?
    let city: String?
    let state: String?
    let country: String?
}

struct Photo : Codable {
    let id : String?
    let createdAt : Int?
    let prefix : String
    let suffix : String
    let width : Int?
    let height : Int?
    let visibility : String?
}
