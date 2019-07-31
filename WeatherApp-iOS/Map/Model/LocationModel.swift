//
//  LocationModel.swift
//  WeatherApp-iOS
//
//  Created by MacBookPro on 7/25/19.
//  Copyright © 2019 MacBookPro. All rights reserved.
//

import Foundation
import UIKit

class LocationModel {
    
    var country : String = ""
    var city : String = ""
    var latitude : Double
    var longitude : Double
    
    init(city :String, country:String, longitude:Double, latitude:Double) {
        self.latitude = latitude
        self.longitude = longitude
        self.city = city
        self.country = country
    }
}
