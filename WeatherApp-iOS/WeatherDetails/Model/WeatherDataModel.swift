//
//  WeatherDataModel.swift
//  WeatherApp-iOS
//
//  Created by MacBookPro on 7/26/19.
//  Copyright © 2019 MacBookPro. All rights reserved.
//

import Foundation

class WeatherDataModel {
    
    var temperature: Int?
    var condition: Int?
    var city: String?
    var humidity: Int?
    var windDegree: Int?
    var windSpeed: Float?
    var weatherIconeName: String {
        return updateWeatherIcon(condition: condition)
    }
    var description: String?
    var country: String?
    var coord: Double?
    var latitude: Double?
    var longitude: Double?
    
    init() {
        
    }
    
    init(temperature: Int ,condition: Int ,city: String ,humidity: Int,windDegree: Int,windSpeed: Float ,description: String ,country: String){
        
        self.temperature = temperature
        self.condition = condition
        self.city = city
        self.description = description
        self.country = country
        self.humidity = humidity
        self.windSpeed = windSpeed
        self.windDegree = windDegree
    }
    
    func updateWeatherIcon(condition: Int?) -> String {
        guard let condition = condition else { return "dunno"}
        switch (condition) {
            
        case 0...300 :
            return "tstorm1"
            
        case 301...500 :
            return "light_rain"
            
        case 501...600 :
            return "shower3"
            
        case 601...700 :
            return "snow4"
            
        case 701...771 :
            return "fog"
            
        case 772...799 :
            return "tstorm3"
            
        case 800 :
            return "sunny"
            
        case 801...804 :
            return "cloudy2"
            
        case 900...903, 905...1000  :
            return "tstorm3"
            
        case 903 :
            return "snow5"
            
        case 904 :
            return "sunny"
            
        default :
            return "dunno"
        }
        
    }
}

