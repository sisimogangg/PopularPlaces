//
//  Place.swift
//  PopularPlaces
//
//  Created by Godfrey Sisimogang on 2017/11/26.
//  Copyright © 2017 Godfrey Sisimogang. All rights reserved.
//

import Foundation

struct Venue {
    let id: String
    let name: String
    let address: String
    let photoUrl: URL?
    let checkins: Int
    let rating: Int
    let users: Int
    let lat: Double?
    let lon: Double?
}


