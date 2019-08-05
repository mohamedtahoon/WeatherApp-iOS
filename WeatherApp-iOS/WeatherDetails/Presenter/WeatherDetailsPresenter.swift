//
//  WeatherDetailsPresenter.swift
//  WeatherApp-iOS
//
//  Created by MacBookPro on 7/28/19.
//  Copyright © 2019 MacBookPro. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

protocol WeatherDelegate {
    func updateUIWithWeatherData(_ weather: (temperature: Int, city: String, icon: String, humidity: Int, windDegree : Int, windSpeed : Float, description : String, country : String, condition : Int))
}

class WeatherDetailsPresenter {
    
    var weatherService: WeatherService
    var weatherDelegate: WeatherDelegate?
    
    
        init(weatherService: WeatherService){
            self.weatherService = weatherService
    
        }
    
    func setViewDelegate(weatherDelegate: WeatherDelegate?){
        self.weatherDelegate = weatherDelegate
    }
    
    
    func weatherInfo(long: Double, lat: Double){
        weatherService.getWeatherData(Longitude: long ,Latitude: lat) { (error, result) in
            if let result = result {
                self.weatherDelegate?.updateUIWithWeatherData(result.weather)
                
            }
        }
    }
    
    
    
    
}
