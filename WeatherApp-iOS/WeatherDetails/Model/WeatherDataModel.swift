//
//  Weather.swift
//  WeatherApp-iOS
//
//  Created by MacBookPro on 8/1/19.
//  Copyright © 2019 MacBookPro. All rights reserved.
//

import UIKit

struct WeatherDataModel{
    
    var temperature: Int
    var condition: Int
    var city: String
    var humidity: Int
    var windDegree: Int
    var windSpeed: Float
    var weatherIconeName: String {return updateWeatherIcon(condition: condition)}
    var description: String
    var country: String
    var latitude: Double
    var longitude: Double
    
    
    
    var weather: (Int, String, String, Int, Int, Float, String, String, Int){
        return (temperature: temperature,
                city: city,
                icon: weatherIconeName,
                humidity: humidity,
                windDegree : windDegree,
                windSpeed : windSpeed,
                description : description,
                country : country,
                condition : condition)
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
