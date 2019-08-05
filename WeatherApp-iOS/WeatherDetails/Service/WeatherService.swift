//
//  WeatherService.swift
//  WeatherApp-iOS
//
//  Created by MacBookPro on 8/5/19.
//  Copyright © 2019 MacBookPro. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class WeatherService{
    
    let apiKey = "f9f89e3f8df9497aef7f3556f912f872"
    let units = "metric"
    
    func getWeatherData(Longitude lon: Double, Latitude lat: Double, completion: @escaping (String?, _ weather:WeatherDataModel?) -> Void) {
        
        let baseURL = "http://api.openweathermap.org/data/2.5/weather"
        let paramString = "?lat=\(lat)&lon=\(lon)&appid=\(apiKey)&units=\(units)"
        let url = baseURL + paramString
        print(url)
        
        
        Alamofire.request(url, method: .get, parameters: nil, encoding: URLEncoding.default, headers: nil)
            .responseJSON {
                response in
                switch response.result{
                case .failure:
                    print("faild")
                case .success:
                    
                    let json = JSON(response.value!)
                    print(json)
                    let tempResult = json["main"]["temp"].intValue
                    let city = json["name"].stringValue
                    let humidity = json["main"]["humidity"].intValue
                    let windDegree = json["wind"]["deg"].intValue
                    let windSpeed = json["wind"]["speed"].floatValue
                    let condition = json["weather"][0]["id"].intValue
                    let description = json["weather"][0]["description"].stringValue
                    let country = json["sys"]["country"].stringValue
                    
                    let weather = WeatherDataModel(temperature: tempResult,
                                                   condition: condition,
                                                   city: city,
                                                   humidity: humidity,
                                                   windDegree: windDegree,
                                                   windSpeed: windSpeed,
                                                   description: description,
                                                   country: country,
                                                   latitude: lat,
                                                   longitude: lon)
                    
                    completion(nil,weather)
                    print(weather)
                }
        }
    }
}
