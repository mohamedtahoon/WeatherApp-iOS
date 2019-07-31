//
//  MapViewPresenter.swift
//  WeatherApp-iOS
//
//  Created by MacBookPro on 7/25/19.
//  Copyright © 2019 MacBookPro. All rights reserved.
//

import Foundation
import MapKit
import CoreLocation

enum AlertAction {
    case cancel
    case confirm
}

protocol MapPresenterProtocol {
    
    func confirmAddingCity(coordinate: CLLocationCoordinate2D, completionHandler: @escaping (AlertAction) -> Void)
    func saveCity(location: LocationModel) -> Void
}

class MapViewPresenter: MapPresenterProtocol {
    let alert = Alert()
    
    // Show Alert to confirm or cancel adding city to bookmark
    func confirmAddingCity(coordinate: CLLocationCoordinate2D, completionHandler: @escaping (AlertAction) -> Void) {
        
        let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        CLGeocoder().reverseGeocodeLocation(location, completionHandler: { [unowned self] (placemarks, error) in
            if error != nil {
                self.alert.showAlert(title: "Something went wrong", message: error!.localizedDescription, actions: nil)
            } else {
                let placemark = placemarks?.first
            
                // if it was a correct place
                if let cityName = placemark?.administrativeArea , let countryName = placemark?.country {
                    
                    /// Actions of alert
                    self.alert.showAlert(title: cityName + ", " + countryName, message: "Bookmark this City?", actions: [(title:"Cancel",action: {
                        completionHandler(.cancel)
                    })
                        , (title:"Ok", action: {
                            completionHandler(.confirm)
                            
                            // save city to bookmark
                            let location = LocationModel(city: cityName, country: countryName, longitude: coordinate.longitude, latitude: coordinate.latitude)
                            
                            self.saveCity(location: location)
                            
                        })])
                }
                    // if couldn't get placemark
                else {
                    self.alert.showAlert(title: "Sorry", message: "Unable to identify location Press on correct location.", actions:[(title:"Ok",action: {
                        completionHandler(.cancel)
                    })])
                }
            }
        })
    }
    
    func saveCity(location: LocationModel) -> Void {
        var city: Location?
        city = Location(context:context)
        city?.city = location.city
        city?.country = location.country
        city?.lat = location.latitude
        city?.long = location.longitude
        do {
            appDelegate.saveContext()
            print("added successfully")
        }
    }
    
    
}
